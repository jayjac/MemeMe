//
//  MemeEditor+ImagePickerDelegate.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 21/07/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//
import UIKit


extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = traitCollection.userInterfaceIdiom == .pad ? info[UIImagePickerControllerOriginalImage] as? UIImage : info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        imageView.image = image
        initializeTextFields()
        topTextField.isEnabled = true
        bottomTextField.isEnabled = true
        shareButton.isEnabled = true
        cancelButton.isEnabled = true
        emptyView.isHidden = true
        changeFontButton.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
}
