//
//  FeedCell.swift
//  Community
//
//  Created by Hatshit on 23/11/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class FeedCell : MGSwipeTableCell {

    @IBOutlet weak var txtView_Tittle: UITextView!
    @IBOutlet weak var txtView_Des: UITextView!


    @IBOutlet weak var bg_TagView_H: NSLayoutConstraint!
    @IBOutlet weak var lbl_VotesCount: UILabel!
    
    @IBOutlet weak var imgViewOfVotes: UIImageView!
    @IBOutlet weak var btn_UpDownVote: UIButton!
    @IBOutlet weak var lbl_Date: UILabel!
   
    @IBOutlet weak var lbl_Replies: UILabel!
    @IBOutlet weak var bg_TagView: ASJTagsView!
    @IBOutlet weak var lbl_CatName: UILabel!
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var lbl_Tittle: UILabel!
    @IBOutlet weak var cell_ImgView: UIImageView!
    @IBOutlet weak var BgViewOfImg: UIView!
    
    @IBOutlet weak var bgView_tag_2: UIView!
    @IBOutlet weak var bgView_tag_1: UIView!
    @IBOutlet weak var lbl_Feed_2: UILabel!
    @IBOutlet weak var lbl_Feed_1: UILabel!
    
    @IBOutlet weak var lbl_Hashtag4: UILabel!
    
    @IBOutlet weak var lbl_Hashtag1: UILabel!
    @IBOutlet weak var lbl_Hashtag2: UILabel!
    @IBOutlet weak var lbl_Hashtag3: UILabel!

    @IBOutlet weak var lbl_Hashtag3_X: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_Hastag3_Y: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
