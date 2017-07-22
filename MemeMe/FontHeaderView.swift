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
        label.backgroundColor =  UIColor.blue
    }
    

}
