//
//  KudosDetailsCell.swift
//  Communiti
//
//  Created by mac on 27/07/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class KudosDetailsCell: UITableViewCell {
    @IBOutlet var lbl_Tittle: UILabel!
    @IBOutlet var bgVw_BtnShare: UIView!
    @IBOutlet var bgVw_BtnShare_H: NSLayoutConstraint!
    @IBOutlet var btnShare: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
