//
//  MemeModel.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 16/07/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

// This struct is only used for saving the meme on disk after it has been shared
struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    let fontName: String
    let activityType: UIActivityType?
    
    static func generateMeme(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let memeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memeImage!
    }
    
}
