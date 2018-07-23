//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by WY NG on 26/6/2018.
//  Copyright © 2018 lumanman. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var selectedMeme: Meme?
    var selectedMemeIndex: Int?
    enum Destination {
        case editor
        case detail
    }
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        memeImageView.image = selectedMeme!.memedImage
        memeImageView.contentMode = .scaleAspectFit
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func editClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "toEdit" == segue.identifier {
            let vc = segue.destination as! MemeViewController
            vc.sentMeme = self.selectedMeme
            vc.dataLoaded = true
        }
    }

    
}
