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
    private let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        tableView.delegate = self
        tableView.dataSource = self
    }
    


    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemesTableViewCell
        let index = indexPath.row
        let meme = MemeManager.memesArray[index]
        cell.topTextLabel.text = meme.topText + " " + meme.bottomText
        cell.pictureImageView.image = UIImage(contentsOfFile: meme.originalImageUrl.path)
        cell.activityTypeLabel.text = ""
        if let activityType = meme.activityType {
            let date = meme.date
            switch activityType {
            case UIActivityType.postToFacebook:
                cell.activityTypeLabel.text = "Shared on Facebook"

            case UIActivityType.postToTwitter:
                cell.activityTypeLabel.text = "Shared on Twitter"
                
            case UIActivityType.postToFlickr:
                cell.activityTypeLabel.text = "Shared on Flickr"
                
            case UIActivityType.postToVimeo:
                cell.activityTypeLabel.text = "Shared on Vimeo"

            case UIActivityType.message:
                cell.activityTypeLabel.text = "Sent via text message"
                
            case UIActivityType.mail:
                cell.activityTypeLabel.text = "Sent via email"
                
            default:
                cell.activityTypeLabel.text = "Shared via unknown medium"
            }
            cell.activityTypeLabel.text = "(\(cell.activityTypeLabel.text!) on \(dateFormatter.string(from: date)))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeManager.memesArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        performSegue(withIdentifier: editMemeSegueIdentifier, sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MemeManager.deleteMemeFromDisk(with: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = selectedIndexPath else { return }
        if segue.identifier == editMemeSegueIdentifier {
            let memeEditor = segue.destination as! MemeEditorViewController
            let dataSource = MemeManager.memesArray[indexPath.row]
            memeEditor.setMeme(from: dataSource)
        }
    }


}
