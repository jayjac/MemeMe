//
//  TakeAPictureViewController.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 12/06/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButtonItem: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var emptyView: UIView! // View that is displayed when no image is there
    @IBOutlet weak var tapToChooseAnImageLabel: UILabel!
    private let flickerLayer = CALayer()
    fileprivate var hasTopTextBeenModified = false
    fileprivate var hasBottomTextBeenModified = false
    private var font = "Impact"

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* tapGR toggles the keyboard on/off depending on what half of the main view is being tapped */
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnTheView(gesture:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        
        let chooseAnImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedToChooseAnImage(gesture:)))
        emptyView.addGestureRecognizer(chooseAnImageGestureRecognizer)
        
        cameraButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        resetUserInterface()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        swipeAnimationOnLabelText()
    }
    
    //MARK: Adds a little "swipe to open"-like animation on the initial text
    private func swipeAnimationOnLabelText() {
        let width = emptyView.frame.width
        let height = emptyView.frame.height
        flickerLayer.backgroundColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        flickerLayer.frame = CGRect(x: 0, y: 0, width: 40.0, height: height)
        emptyView.layer.addSublayer(flickerLayer)
        
        let animationGroup = CAAnimationGroup()
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = -45.0
        animation.toValue = width + 45.0
        animation.duration = 1.0
        animation.fillMode = kCAFillModeBoth

        animationGroup.duration = 2.5
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false
        flickerLayer.add(animationGroup, forKey: nil)
    }

    //MARK:- Gesture Recognizer's selector
    @objc private func tappedOnTheView(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        let height = view.frame.height
        if point.y < height / 2 {
            if !topTextField.isFirstResponder {
                topTextField.becomeFirstResponder()
            } else {
                topTextField.resignFirstResponder()
            }
            return
        }
        if point.y >= height / 2 {
            if !bottomTextField.isFirstResponder {
                bottomTextField.becomeFirstResponder()
            } else {
                bottomTextField.resignFirstResponder()
            }
        }
    }
    
    // Selector for the GR on the initial empty view
    @objc private func tappedToChooseAnImage(gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
                self.showCameraScreen()
            }
            alert.addAction(cameraAction)
        }
        let photoAlbum = UIAlertAction(title: "Photo Album", style: .default) { (action: UIAlertAction) in
            self.showImagePicker()
        }
        alert.addAction(photoAlbum)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func resetUserInterface() {
        setupTextFields()
        imageView.image = nil
        shareButton.isEnabled = false
        cancelButton.isEnabled = false
        emptyView.isHidden = false
    }
    
    private func setupTextFields() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.white, NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: -5.0, NSFontAttributeName: UIFont(name: "Impact", size: 30)!, NSParagraphStyleAttributeName: paragraphStyle]
        
        topTextField.attributedText = NSAttributedString(string: "TOP", attributes: attributes)
        bottomTextField.attributedText = NSAttributedString(string: "BOTTOM", attributes: attributes)
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        hasTopTextBeenModified = false
        hasBottomTextBeenModified = false
    }
    
    @IBAction func shareMemeButtonWasTapped(_ sender: Any) {
        guard imageView.image != nil else { return }
        let image = Meme.generateMeme(from: containerView)
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (type: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            print("completed the activity")
            print(completed)
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonWasTapped(_ sender: Any) {
        resetUserInterface()
    }
    
    //MARK:- Keyboard show/hide notification handlers
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            let userInfo = notification.userInfo!
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let newOrigin = CGPoint(x: 0, y: -frameEnd.height)
            UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                self.view.frame.origin = newOrigin
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
    //MARK:-
    



    @IBAction func takeAPictureThruDevice(_ sender: Any) {
        showCameraScreen()
    }
    
    private func showCameraScreen() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func choosePictureFromPhotoLibrary(_ sender: Any) {
        showImagePicker()
    }
    
    private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

}

//MARK:-

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        imageView.image = image
        topTextField.isEnabled = true
        bottomTextField.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
        cancelButton.isEnabled = true
        emptyView.isHidden = true
    }
}


extension MemeEditorViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.white, NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: -5.0, NSFontAttributeName: UIFont(name: "Impact", size: 40)!, NSParagraphStyleAttributeName: paragraphStyle]
        let text = textField.text! as NSString
        let newText = text.replacingCharacters(in: range, with: string)
        textField.attributedText = NSAttributedString(string: newText, attributes: attributes)
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField && !hasTopTextBeenModified {
            textField.text = ""
            hasTopTextBeenModified = true
            return
        }
        if textField == bottomTextField && !hasBottomTextBeenModified {
            textField.text = ""
            hasBottomTextBeenModified = true
            return
        }
        
    }
    
    
    
}

