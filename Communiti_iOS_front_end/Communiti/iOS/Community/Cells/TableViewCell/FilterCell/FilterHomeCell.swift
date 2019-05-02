//
//  FilterHomeCell.swift
//  Community
//
//  Created by Hatshit on 29/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class FilterHomeCell: UITableViewCell {
    
    @IBOutlet weak var lbl_FilterTyp: UILabel!

    @IBOutlet weak var bgViewOfLblDes: UIView!
    @IBOutlet weak var lbl_Des1: UILabel!
    
    @IBOutlet weak var lbl_Des1_W: NSLayoutConstraint!
    @IBOutlet weak var lbl_Des2: UILabel!
    
    @IBOutlet weak var lbl_Des3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
