//
//  TypeOfHelpVC.swift
//  Community
//
//  Created by Hatshit on 18/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit

class TypeOfHelpVC: UIViewController  {
    @IBOutlet weak var imgVw_Location: UIImageView!
    
    @IBOutlet weak var imgVw_Virtual: UIImageView!
    @IBOutlet weak var view_OfYesTtl: UIView!
    @IBOutlet weak var view_NoTtl: UIView!
    var ctrObjOFTypOfHelp : CountryList!
    var cameFmFilterVC : Bool!
    var callBackFmTypOfHelpVC: ((Bool , [Any]) -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!APP_Delegate().reqType){
            let width = self.view.frame.size.width/5
            let label = UILabel(frame: CGRect(x: 0, y: 63, width: width*2, height: 5))
            label.text = ""
            label.clipsToBounds = true;
            label.backgroundColor = progressBarColor()
            self.view.addSubview(label)
            
        }
        self.setUpData()
    
        
        // Do any additional setup after loading the view.
    }
    
    func setUpData(){
        //self.navigationItem.backBarButtonItem?.title = " "
        //self.navigationItem.title = "TYPE OF HELP"
        
        if(cameFmFilterVC){
              self.imgVw_Location.image = UIImage(named: "")
               self.imgVw_Virtual.image = UIImage(named: "")

        }
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @IBAction func btn_ActionMethod(_ sender: UIButton) {

        if(cameFmFilterVC){
               if(sender.tag == 0){
                  self.imgVw_Location.image = UIImage(named: "Checkmark_Green")
                  self.imgVw_Location.isHidden = false
                  self.imgVw_Virtual.isHidden = true
                
                var frame = imgVw_Location.frame
                frame.size.width = 19
                frame.size.height = 15
                imgVw_Location.frame = frame
                if self.callBackFmTypOfHelpVC != nil {
                    self.callBackFmTypOfHelpVC!(true , ["Location"])
                }
                
               }else{
                 self.imgVw_Location.isHidden = true
                 self.imgVw_Virtual.isHidden = false
                 self.imgVw_Virtual.image = UIImage(named: "Checkmark_Green")
                var frame = imgVw_Virtual.frame
                frame.size.width = 19
                frame.size.height = 15
                imgVw_Virtual.frame = frame
                self.callBackFmTypOfHelpVC!(true , ["Virtual"])

            }
            
        }else{
            if(sender.tag == 0){
                
                self.view_OfYesTtl.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
                self.view_NoTtl.backgroundColor = UIColor.clear
                let locationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LOCATIONVC") as! LocationVC
                
                locationVC.ctrObjOFLocation = ctrObjOFTypOfHelp
                setDataInUserDefalt(key: "TypeOfReq", userData: "Location" )
                
                self.navigationController?.pushViewController(locationVC, animated: true)
            }else{
                
                self.view_NoTtl.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
                self.view_OfYesTtl.backgroundColor = UIColor.clear
                
                
                let selectDateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SELECTEDDATE") as! SelectDateVC
                
                selectDateVC.ctrObjOFSltDate = ctrObjOFTypOfHelp
                setDataInUserDefalt(key: "TypeOfReq", userData: "Virtual" )
                setDataInUserDefalt(key: "Location_Lat",  userData: "")
                setDataInUserDefalt(key: "Location_Long",  userData: "")
                setDataInUserDefalt(key: "Location_Addrs",  userData: "")
                
                self.navigationController?.pushViewController(selectDateVC, animated: true)
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Handle the user's selection.
    
   
 
}
