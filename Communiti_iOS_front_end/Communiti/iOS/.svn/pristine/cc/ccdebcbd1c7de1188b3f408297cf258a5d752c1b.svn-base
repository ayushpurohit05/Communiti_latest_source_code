//
//  HiveHomeCell.swift
//  Communiti
//
//  Created by mac on 23/05/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class HiveHomeCell: UITableViewCell {

    @IBOutlet var joinBtn: UIButton!
    @IBOutlet var ImgView_Group: UIImageView!
    
    @IBOutlet var lbl_groupNm: UILabel!
    @IBOutlet var lbl_PostCount: UILabel!
    
    @IBOutlet var lbl_UserCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpOfCellMethod(countryList : CountryList){
        
        self.lbl_PostCount.text = countryList.pst_count
        self.lbl_UserCount.text = countryList.usr_count
        self.lbl_groupNm.text = String(format: "#%@", countryList.grp_title!)
        
        DispatchQueue.main.async {
            if(countryList.grp_image != nil && countryList.grp_image != ""){
                saveImgIntoCach(strImg: countryList.grp_image!, imageView:  self.ImgView_Group)
            }else{
                self.ImgView_Group.image =  UIImage(named: "helpPost_Defalt")
            }
        }

        if(countryList.usr_join == "NO"){
            self.joinBtn.isHidden = false
        }else{
            UserDefaults.standard.set(true, forKey: "isJoinedGrp")
            self.joinBtn.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
