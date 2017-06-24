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
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButtonItem: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UIFont.familyNames)
        cameraButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.white, NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: -5.0, NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSParagraphStyleAttributeName: paragraphStyle]
        
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: attributes)
        
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: attributes)
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.isEnabled = false
        bottomTextField.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        guard let image = imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            let userInfo = notification.userInfo!
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let initialFrame = view.frame
            let offsetFrame = initialFrame.offsetBy(dx: 0.0, dy: -frameEnd.height)
            UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                self.view.frame = offsetFrame
            }, completion: nil)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            let userInfo = notification.userInfo!
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                self.view.frame.origin = CGPoint.zero
            }, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func takeAPictureThruDevice(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func choosePictureFromPhotoLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    

}


extension TakeAPictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        topTextField.isEnabled = true
        bottomTextField.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
}


extension TakeAPictureViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.white, NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: -5.0, NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSParagraphStyleAttributeName: paragraphStyle]
        let text = textField.text! as NSString
        let newText = text.replacingCharacters(in: range, with: string)
        textField.attributedText = NSAttributedString(string: newText, attributes: attributes)
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}

