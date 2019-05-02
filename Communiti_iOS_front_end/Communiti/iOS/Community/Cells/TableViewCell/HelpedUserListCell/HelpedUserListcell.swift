//
//  HelpedUserListcell.swift
//  Community
//
//  Created by Hatshit on 12/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class HelpedUserListcell: UITableViewCell {

    @IBOutlet weak var bgViewOfCell: UIView!
    @IBOutlet weak var bgViewOfImg: UIView!
    @IBOutlet weak var checkMark_ImgView: UIImageView!
    @IBOutlet weak var userImg_View: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
