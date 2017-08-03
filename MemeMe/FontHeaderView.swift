//
//  FontHeaderView.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 21/07/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit


// Floating header view in the font chooser table view
class FontHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        label.textColor = UIColor.white
        label.layer.cornerRadius = 10.5
        label.layer.masksToBounds = true
        label.backgroundColor =  UIColor(red: 240.0/255.0, green: 146.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    }
    

}
