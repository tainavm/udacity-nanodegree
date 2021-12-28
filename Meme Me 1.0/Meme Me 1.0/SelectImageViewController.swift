//
//  ViewController.swift
//  Meme Me 1.0
//
//  Created by Taina Viriato on 28/12/21.
//

import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let image: UIImage
    let memedImage: UIImage
}

// TODO
// arrumar teclado e texto
// limpar texto ao clicar

class SelectImageViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var ivMeme: UIImageView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var tfTop: UITextField!
    @IBOutlet weak var tfBottom: UITextField!
    @IBOutlet var textFields: [UITextField]!
    
    // MARK: Properties
    private var shareItem: UIBarButtonItem! = nil
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopToolbar()
        setupBottomToolbar()
        setupTexts()
        resetText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Keyboard Functions
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
     
    // MARK: Text Functions
    private func setupTexts() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            .strokeColor: UIColor.black,
            .strokeWidth: -3
        ]
        
        for text in textFields {
            text.adjustsFontSizeToFitWidth = false
            text.defaultTextAttributes = attributes
            text.delegate = self
        }
    }
    
    // Clear texts to initial state
    private func resetText() {
        tfTop.text = "TOP"
        tfBottom.text = "BOTTOM"
    }
    
    // MARK: Toolbar Functions - Setup
    private func setupTopToolbar() {
        shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        let spaceItemRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        shareItem.isEnabled = false
        topToolbar.setItems([shareItem, spaceItemRight, cancelItem], animated: true)
    }
    
    private func setupBottomToolbar() {
        let cameraItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
        let spaceItemRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let albumItem = UIBarButtonItem(title: "Album", style: .plain, target: self, action: #selector(pickImage))
        // Disable camera if not availabe in device
        cameraItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        bottomToolbar.setItems([cameraItem, spaceItemRight, albumItem], animated: true)
    }
    
    // MARK: Toolbar Actions
    
    func saveMeme(_ generatedMeme: UIImage) {
        _ = Meme(topText: tfTop.text!, bottomText: tfBottom.text!, image: ivMeme.image!, memedImage: generatedMeme)
    }
    
    @objc func shareMeme() {
        let meme = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if (completed) {
                self.saveMeme(meme)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    @objc func cancel() {
        resetText()
        ivMeme.image = nil
    }
    
    // Render view to an image
    func generateMemedImage() -> UIImage {
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }
}

// MARK: Image Picker Delegate
extension SelectImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            ivMeme.image = image
            shareItem.isEnabled = true
        }
    }
    
    // Pick image from gallery
    @objc func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // Take photo with camera
    @objc func takePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
}

// MARK: Text Field Delegate
extension SelectImageViewController: UITextFieldDelegate {
    private func textViewDidBeginEditing(_ textView: UITextView) {
        // limpar texto ao clicar
        for text in textFields {
            text.text = ""
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
