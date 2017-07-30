//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 12/06/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit


// MARK:- For version 2.0
class MemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let cellReuseIdentifier = "MemesCollectionViewCell"
    private let segueIdentifier = "EditMemeSegue"
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 400
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MemesCollectionViewCell
        if MemeManager.memesArray.count > 0 {
            let index = 0 //indexPath.row
            let meme = MemeManager.memesArray[index]
            cell.topTextLabel.text = meme.topText
            cell.bottomTextLabel.text = meme.bottomText
            cell.pictureImageView.image = UIImage(contentsOfFile: meme.originalImageUrl.path)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.bounds.width
        let width = viewWidth < 400.0 ? viewWidth / 3 - 1 : viewWidth / 4 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }



}



