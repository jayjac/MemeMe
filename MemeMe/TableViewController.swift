//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 12/06/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit


// MARK:- For version 2.0
class MemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    private let cellReuseIdentifier = "MemeTableViewCell"
    private let editMemeSegueIdentifier = "EditMemeSegue"
    private var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemesTableViewCell
        let index = indexPath.row
        let meme = MemeManager.memesArray[index]
        let font = UIFont(name: "Arial", size: 12.0)
        cell.topTextLabel.text = meme.topText
        cell.topTextLabel.font = font
        cell.bottomTextLabel.text = meme.bottomText
        cell.bottomTextLabel.font = font
        cell.pictureImageView.image = UIImage(contentsOfFile: meme.originalImageUrl.path)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeManager.memesArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "EditMemeSegue", sender: nil)
    }
    
    
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = selectedIndexPath else { return }
        if segue.identifier == editMemeSegueIdentifier {
            let memeEditor = segue.destination as! MemeEditorViewController
            let dataSource = MemeManager.memesArray[indexPath.row]
            memeEditor.setMeme(from: dataSource)
        }
    }


}
