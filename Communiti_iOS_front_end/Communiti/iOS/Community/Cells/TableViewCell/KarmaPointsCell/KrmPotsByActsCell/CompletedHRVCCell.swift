//
//  CompletedHRVCCell.swift
//  Community
//
//  Created by Hatshit on 10/02/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class CompletedHRVCCell: UITableViewCell {

    @IBOutlet weak var img_ViewArrow: UIImageView!
    
    @IBOutlet weak var lbl_tittle: UILabel!
    
    @IBOutlet weak var lbl_KPCount: UILabel!
    @IBOutlet weak var lbl_CatNm: UILabel!
    
    @IBOutlet weak var lbl_Date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func SetUpCellMethod(actTyp : String , countryListObj : CountryList){
        if(actTyp == "COMPLETED_HELP"){
              self.setUpForPosts(countryListObj: countryListObj)
              self.img_ViewArrow.isHidden = true
        }else{ // For Created and HiveContribution
   
            self.setUpForPosts(countryListObj: countryListObj)
        }
    
    }
    
    func setUpForPosts(countryListObj : CountryList){
        self.img_ViewArrow.isHidden = false
        if(countryListObj.pst_isDeleted == "1"){
            self.img_ViewArrow.isHidden = true

        }
        
        
        self.lbl_tittle.text = countryListObj.pst_title?.capitalizingFirstLetter()
        self.lbl_CatNm.text =  String(format: "#%@     ",countryListObj.scat_title ?? "")
        self.lbl_KPCount.text = countryListObj.points
        let diffOfDate = datedifference(timeInterval: countryListObj.pst_createdate ?? "", timeZone: countryListObj.pext_timeZone ?? "")
        
        if(diffOfDate == "Same"){
            self.lbl_Date.text = "Completed on today"
        }else {
            self.lbl_Date.text = String(format: "Completed on %@     ",dateFormateWithoutTime(timeInterval: countryListObj.pst_createdate!))
        }
        
    }


}
