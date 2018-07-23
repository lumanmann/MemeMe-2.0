//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by WY NG on 7/7/2018.
//  Copyright © 2018 lumanman. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // MARK: Properties & Outlet
    var memes: [Meme]!
    var selectedMeme : Meme?
    
    enum Destination {
        case editor
        case detail
    }
    
    @IBOutlet var memeCollectionView: UICollectionView!
    
    
    // MARK: Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideControllers(isOn: false)
        
        // set it to the memes array from the AppDelegat
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes

        memeCollectionView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        navigateWithSegue(meme: nil, to: .editor)
    }
    
    func hideControllers(isOn status: Bool) {
        self.tabBarController?.tabBar.isHidden = status
        navigationController?.isNavigationBarHidden = status
    }
    
    
    func navigateWithSegue(meme : Meme?, to destination: Destination){
        
        self.selectedMeme = meme
        switch destination {
        case .detail:
            self.performSegue(withIdentifier: "toDetails", sender: self)
        case .editor:
            self.performSegue(withIdentifier: "toEdit", sender: self)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MemeCollectionViewCell
        
        // Configure the cell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView.image = meme.memedImage
        cell.imageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! MemeDetailViewController
        // Pass the Meme Data
        let meme = self.memes[indexPath.row]
        detailVC.selectedMeme = meme
        detailVC.selectedMemeIndex = indexPath.row
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "toEdit" == segue.identifier {
            let vc = segue.destination as! MemeViewController
            vc.sentMeme = self.selectedMeme
        } else if "toDetails" == segue.identifier {
            let vc = segue.destination as! MemeDetailViewController
            vc.selectedMeme = self.selectedMeme
        }
    }
    
    
}
