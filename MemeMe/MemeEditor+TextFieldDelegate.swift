//
//  MemeEditor+TextFieldDelegate.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 21/07/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit



extension MemeEditorViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.white, NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: -5.0, NSFontAttributeName: UIFont(name: "Impact", size: initialFontSize)!, NSParagraphStyleAttributeName: paragraphStyle]
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
