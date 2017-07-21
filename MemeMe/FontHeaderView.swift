//
//  FontHeaderView.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 21/07/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class FontHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        label.textColor = UIColor.white
        label.layer.cornerRadius = 10.5
        label.layer.masksToBounds = true
        label.backgroundColor =  UIColor.blue
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
