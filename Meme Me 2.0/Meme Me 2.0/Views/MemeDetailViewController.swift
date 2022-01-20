//
//  MemeDetailViewController.swift
//  Meme Me 2.0
//
//  Created by Taina Viriato on 20/01/22.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var selectedMeme: Meme!

    @IBOutlet weak var ivMeme: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        ivMeme.image = selectedMeme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
}
