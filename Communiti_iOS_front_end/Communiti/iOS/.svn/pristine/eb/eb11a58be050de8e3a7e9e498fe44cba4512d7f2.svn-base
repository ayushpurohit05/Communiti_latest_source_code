//
//  SelectDateVC.swift
//  Community
//
//  Created by Hatshit on 22/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit

class SelectDateVC: UIViewController {

    @IBOutlet weak var date_Picker: UIDatePicker!
    @IBOutlet weak var lbl_Date: UILabel!
    
    var ctrObjOFSltDate : CountryList!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!APP_Delegate().reqType){
            let width = self.view.frame.size.width/5
            let label = UILabel(frame: CGRect(x: 0, y: 63, width: width*4, height: 5))
            label.text = ""
            label.clipsToBounds = true;
            label.backgroundColor = progressBarColor()
            self.view.addSubview(label)
        }
        
        self.setUpData()
        self.setUpOfDatePicker()
        
        let currentDate = NSDate()
        lbl_Date.text = dateFormate(date: currentDate as Date)
        setDataInUserDefalt(key: "HelpReqDate", userData: convertSystemDateIntoLocalTimeZoneWithStaticTime(date: Date()))

       // setDataInUserDefalt(key: "HelpReqDate", userData: convertDateForFirebaseInUTC(date : currentDate as Date))
        // Do any additional setup after loading the view.
    }
    
    func setUpData(){
        
        //self.navigationItem.backBarButtonItem?.title = " "
        //self.navigationItem.title = "SELECT DATE"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    func setUpOfDatePicker(){
        
        date_Picker.datePickerMode = UIDatePickerMode.date
        date_Picker.minimumDate = Date()
        date_Picker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @IBAction func btnActionMethod(_ sender: Any) {
        
        if(APP_Delegate().isEditHelpFld){
            
            let upDatePostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpDatePostVC") as! UpDatePostVC
            
         
           upDatePostVC.ctrObjOfUpdatePost = ctrObjOFSltDate
            
            if let arrayOfTags : [Tags]  = ctrObjOFSltDate.tags {
                for case let obj in arrayOfTags{
                    upDatePostVC.addedTags.append(obj.htag_text ?? "")
                    
                }
            }
                upDatePostVC.sltSubCat_Id = UserDefaults.standard.value(forKey: "UpdateHelpReqSubCatId") as! String
                upDatePostVC.sltSubCatName = UserDefaults.standard.value(forKey: "UpdateHelpReqSubCatName") as! String
                self.navigationController?.pushViewController(upDatePostVC, animated: true)
            
            
        }else{
            
            
            let newPostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
            
            // setDataInUserDefalt(key: "HelpReqDate", userData: lbl_Date.text ?? "")
            self.navigationController?.pushViewController(newPostVC, animated: true)
        }
  

    }
    func datePickerValueChanged(sender:UIDatePicker) {
       // setDataInUserDefalt(key: "HelpReqDate", userData: convertDateForFirebaseInUTC(date : sender.date))
        setDataInUserDefalt(key: "HelpReqDate", userData: convertSystemDateIntoLocalTimeZoneWithStaticTime(date: sender.date))
        lbl_Date.text = dateFormate(date: sender.date)
    }
    
    func dateFormate(date : Date ) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let strDate = dateFormatter.string(from: date as Date)
       // print("Date = " , strDate)
        
        return strDate
    }

}
