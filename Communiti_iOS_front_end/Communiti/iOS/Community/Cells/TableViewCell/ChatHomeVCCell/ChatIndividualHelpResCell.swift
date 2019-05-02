//
//  ChatIndividualHelpResCell.swift
//  Community
//
//  Created by Hatshit on 16/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class ChatIndividualHelpResCell: UITableViewCell {
    
    
    @IBOutlet weak var bgViewOfImg: UIView!
    
    @IBOutlet weak var imgViewSend_W: NSLayoutConstraint!
    @IBOutlet weak var img_View: UIImageView!
    
    @IBOutlet weak var imgView_Send: UIImageView!
    @IBOutlet weak var mess_ImgVw: UIImageView!
    @IBOutlet weak var lbl_Mess: UILabel!
    @IBOutlet weak var lbl_Nm: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
