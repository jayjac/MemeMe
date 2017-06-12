//
//  TakeAPictureViewController.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 12/06/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class TakeAPictureViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func didTapTakeAPictureButton() {
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        let hasLibrary = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        let hasPhotoAlbum = UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        
        print("Device has camera ? \(hasCamera)")
        print("Device has library ? \(hasLibrary)")
        print("Device has photo album ? \(hasPhotoAlbum)")
        let pictureVC = UIImagePickerController()
        pictureVC.sourceType = .photoLibrary
        pictureVC.delegate = self
        self.present(pictureVC, animated: true, completion: nil)
    }


}


extension TakeAPictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
