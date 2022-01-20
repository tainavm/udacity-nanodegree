//
//  TableViewController.swift
//  Meme Me 2.0
//
//  Created by Taina Viriato on 31/12/21.
//

import UIKit

class TableViewController: UIViewController {
    var memes = [Meme]()
    
    //    MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        memes = getMemes()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        memes = getMemes()
        tableView.reloadData()
    }
    
    // Retrieve saved memes
    private func getMemes() -> [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // Setup navigation bar
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMeme))
    }
    
    // Add the setup for the table view
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Call the create meme view controller
    @objc func createMeme() {
        let selectImageViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController (withIdentifier: "SelectImageViewController") as! SelectImageViewController
        self.navigationController?.pushViewController(selectImageViewController, animated: true)
    }
}

// MARK: Table View setup
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.lbMemeTitle.text = meme.topText
        cell.ivMeme.image = meme.memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
