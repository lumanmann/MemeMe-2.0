//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by WY NG on 7/7/2018.
//  Copyright © 2018 lumanman. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    // MARK: Properties
    var memes: [Meme]!
    var selectedMeme : Meme?
    
    enum Destination {
        case editor
        case detail
    }
    
    // MARK: Outlets
    @IBOutlet var memeTableView: UITableView!
    
    // MARK: controller lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideControllers(isOn: false)
        
        // set it to the memes array from the AppDelegat
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        // reload the data to show when view refreshed
        memeTableView.reloadData()
    }
    
    func hideControllers(isOn status: Bool) {
        self.tabBarController?.tabBar.isHidden = status
        navigationController?.isNavigationBarHidden = status
    }
    
    @IBAction func addClicked(_ sender: Any) {
        navigateWithSegue(meme: nil, to: .editor)
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
    
    // MARK: - TableViewDataSource
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemeTableViewCell
        
        // Configure the cell...
        let selectedMeme = memes![indexPath.row]
        cell.label?.text = selectedMeme.topText
        cell.label2?.text = selectedMeme.bottomText
        cell.memeImage?.image = selectedMeme.memedImage
        cell.memeImage?.contentMode = .scaleAspectFit
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = self.memes[indexPath.row]
        navigateWithSegue(meme: meme, to: .detail)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "toEdit" == segue.identifier {
            let vc = segue.destination as! MemeViewController
            vc.sentMeme = self.selectedMeme
            vc.dataLoaded = true
        } else if "toDetails" == segue.identifier {
            let vc = segue.destination as! MemeDetailViewController
            vc.selectedMeme = self.selectedMeme
        }
    }

    
}
