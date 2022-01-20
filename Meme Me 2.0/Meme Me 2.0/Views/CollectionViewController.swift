//
//  CollectionViewController.swift
//  Meme Me 2.0
//
//  Created by Taina Viriato on 20/01/22.
//

import UIKit

class CollectionViewController: UIViewController { 
    var memes = [Meme]()
    
    //    MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupFlowLayout()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        memes = getMemes()
        collectionView.reloadData()
    }
    
    // Setup navigation bar
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMeme))
    }
    
    // Retrieve saved memes
    private func getMemes() -> [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // Add the setup for the collection view
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupFlowLayout() {
        let space: CGFloat = 2.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // Call the create meme view controller
    @objc func createMeme() {
        let selectImageViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController (withIdentifier: "SelectImageViewController") as! SelectImageViewController
        self.present(selectImageViewController, animated: true, completion: nil)
    }
}

// MARK: Collection View setup
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.ivMeme?.image = meme.memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
