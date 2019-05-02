//
//  HelpCell.swift
//  Community
//
//  Created by Hatshit on 23/11/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import MGSwipeTableCell


class HelpCell: MGSwipeTableCell {

    @IBOutlet weak var imgVW_HelpType: UIImageView!
    @IBOutlet weak var bg_TagView_H: NSLayoutConstraint!
    @IBOutlet weak var lbl_ReqOnDate: UILabel!
    @IBOutlet weak var tag_View: ASJTagsView!
    @IBOutlet weak var lbl_HelpTypName: UILabel!
    @IBOutlet weak var lbl_CatName: UILabel!
    @IBOutlet weak var lbl_tittle: UILabel!
    @IBOutlet weak var bgViewOfImg: UIView!
    @IBOutlet weak var cell_ImgView: UIImageView!
    
    @IBOutlet weak var lbl_Hashtag1: UILabel!
    @IBOutlet weak var lbl_Hashtag2: UILabel!
    @IBOutlet weak var lbl_Hashtag3: UILabel!
    
    @IBOutlet weak var lbl_Hashtag4: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
