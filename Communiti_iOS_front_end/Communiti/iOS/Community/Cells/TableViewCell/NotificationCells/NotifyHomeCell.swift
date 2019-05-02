//
//  NotifyHomeCell.swift
//  Community
//
//  Created by Hatshit on 26/02/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class NotifyHomeCell: UITableViewCell {

    @IBOutlet weak var noti_ImgVw: UIImageView!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_Mess: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpOfCellMethod(countryList : CountryList){
        
        self.lbl_time.text = convertDateInUTCFormate(timeInterval: countryList.ntfy_createdate!)
        self.noti_ImgVw.image = UIImage(named: countryList.ntfy_type!)
        
        self.setUpOfMess(countryList: countryList)
        
        if(countryList.ntfy_isRead == "0"){
            self.backgroundColor = UIColor(red: 235/255, green: 248/255, blue: 248/255, alpha: 1)
        }else{
            self.backgroundColor =  UIColor.white
        }
    }
    
    func setUpOfMess(countryList : CountryList){
        
         if(countryList.ntfy_type == "HIVE_COMMENT"){
            if(countryList.pst_crtr_id == getUserData()["usr_id"] as? String ){
                let strNumber = String(format: "Your post: %@ received a comment.",countryList.pst_ans_dscptn!) as NSString
                let range = (strNumber).range(of: countryList.pst_ans_dscptn!)
                let attribute = NSMutableAttributedString.init(string: strNumber as String)
                attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                self.lbl_Mess.attributedText = attribute
            }else{
                
                self.noti_ImgVw.image = UIImage(named: "CommentForOther")
                let strNumber = String(format: "%@ also commented on their own post.",countryList.usr_usrname!) as NSString
                let range1 = (strNumber).range(of: countryList.usr_usrname!)
                
                let range2 = (strNumber).range(of: countryList.pst_crtr_name!)
                
                let attribute = NSMutableAttributedString.init(string: strNumber as String)
                attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 15) , range: range1)
                attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 15) , range: range2)
                
                self.lbl_Mess.attributedText = attribute
                
                
            }
            
            
        }else if(countryList.ntfy_type == "HIVE_UPVOTE"){
            
            let strNumber = String(format: "Your post: %@ got an upvote.",countryList.pst_ans_dscptn!) as NSString
            let range = (strNumber).range(of: countryList.pst_ans_dscptn!)
            let attribute = NSMutableAttributedString.init(string: strNumber as String)
            attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
            self.lbl_Mess.attributedText = attribute
            
        }else if(countryList.ntfy_type == "COMMENT_UPVOTE"){
            
            let strNumber = String(format: "Your comment: %@ got an upvote.",countryList.pst_ans_dscptn!) as NSString
            let range = (strNumber).range(of: countryList.pst_ans_dscptn!)
            let attribute = NSMutableAttributedString.init(string: strNumber as String)
            attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
            self.lbl_Mess.attributedText = attribute
            
        }else if(countryList.ntfy_type == "COMMENT_GREAT"){
            
           // let strNumber = String(format: "%@ just marked your comment as a Great Answer! You earned 15 Communiti Karma Points.",countryList.usr_usrname!) as NSString

            let typeWithImg =  KudosTypeAndImageAtNoti(kudosTyp: KudosType(rawValue: Int(countryList.gta_kd_id!)!)! , isSmall: false)
            let strNumber : NSString?
            if(countryList.kd_note == "YES"){
                 strNumber = String(format: "%@ has awarded you the %@ badge and a Thank you note for your answer to their post %@. See your new badge and note here.",countryList.usr_usrname! ,typeWithImg.0, countryList.pst_ans_dscptn!) as NSString
            }else{
                     strNumber = String(format: "%@ has awarded you the %@ badge for your answer to their post %@. See your new badge here.",countryList.usr_usrname! ,typeWithImg.0, countryList.pst_ans_dscptn!) as NSString
            }
        
            
            let range1 = (strNumber)?.range(of: countryList.usr_usrname!)
            let range2 = (strNumber)?.range(of: "Great Answer!")
            let attribute = NSMutableAttributedString.init(string: strNumber! as String)
            attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16) , range: range1!)
            attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16) , range: range2!)
            self.lbl_Mess.attributedText = attribute
            self.noti_ImgVw.image = typeWithImg.1

            
        } else if(countryList.ntfy_type == "HELP_REQUEST"){
            
            let strNumber = String(format: "%@ wants to help you for your request:%@ Start chatting and let me know more about your request now.",countryList.usr_usrname!,countryList.pst_ans_dscptn!) as NSString
            
            let range1 = (strNumber).range(of: countryList.usr_usrname!)
            let range2 = (strNumber).range(of: countryList.pst_ans_dscptn!)
            
            let attribute = NSMutableAttributedString.init(string: strNumber as String)
            attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16) , range: range1)
            attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16) , range: range2)
            self.lbl_Mess.attributedText = attribute
            
        }else if(countryList.ntfy_type == "HELP_END"){
            
            let myString: NSString = countryList.usr_usrname! as NSString
            var myStringArr = myString.components(separatedBy: ",")
            let strNumber = String(format: "%@ just said you helped them with:%@ You earned 50 Karma Points!",countryList.usr_usrname!,countryList.pst_ans_dscptn!) as NSString
            
            let range1 = (strNumber).range(of: countryList.usr_usrname!)
            let range2 = (strNumber).range(of: countryList.pst_ans_dscptn!)
            let attribute = NSMutableAttributedString.init(string: strNumber as String)
            attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16) , range: range1)
            attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16) , range: range2)
            self.lbl_Mess.attributedText = attribute
         }else if(countryList.ntfy_type == "HELP_RXPIRE"){
            
            let strNumber = String(format: "Your help request: %@ is about to end today. If you found the help you need, end the request now so your helpers get some karma points. ",countryList.pst_ans_dscptn!) as NSString
            let range = (strNumber).range(of: countryList.pst_ans_dscptn!)
            let attribute = NSMutableAttributedString.init(string: strNumber as String)
            attribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
            self.lbl_Mess.attributedText = attribute
         }else{
            
     
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
