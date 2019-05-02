
//
//  SliderView.swift
//  Swift_FB_Demo
//
//  Created by Hatshit on 21/11/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

protocol SliderViewLogoutDelegate: class{
    func sliderViewDissmissCallback( isLogout: Bool)
}

class SliderView: UIView,UITableViewDelegate,UITableViewDataSource {
    

    weak var delegate:SliderViewLogoutDelegate?

    @IBOutlet weak var kmPointsCount: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var user_Imageview: UIImageView!
    @IBOutlet weak var tbl_View: UITableView!
    @IBOutlet weak var bg_View: UIView!
    var arrOfTableItem = [String]()
    var onHideComplete: ((String) -> Void)!
 

    class func instanceFromNib() -> UIView {
       return UINib(nibName: "SliderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    @IBAction func profileBtnAction(_ sender: UIButton) {
        
        Communiti.removeSideView()
        if self.onHideComplete != nil {
            self.onHideComplete("UserProfileVC")
        }
    }

    
    func setUpOfTableview(){

        NotificationCentreClass.registerCategoryRegisterNotifier(vc: self, selector: #selector(self.refreshKarmaPointsByNotifier))

      arrOfTableItem = ["Support","Invite Friends","Give Feedback","Contact Us"]
        
        let userData = getUserData()
        lbl_Name.text = (userData["usr_fname"] as? String)?.capitalizingFirstLetter()

        let strImg = userData["profile_image"] as! String
        user_Imageview.image =  UIImage(named: "user")
        let imgUrl = URL(string:strImg)
        
        DispatchQueue.main.async {
            if(UserDefaults.standard.value(forKey: "TotalKMPoints") != nil){
                self.kmPointsCount.text =  String(format: "%@ Karma Points",(UserDefaults.standard.value(forKey: "TotalKMPoints") as? String)! )
            }else{
                self.kmPointsCount.text =  "0 Karma Points"
            }
        }
        
        self.user_Imageview.image = UIImage(named: "user");
        let img = ImageCaching.sharedInterface().getImage(imgUrl?.absoluteString)
        if((img) != nil){
            DispatchQueue.main.async {
                self.user_Imageview.image = img
            }
        }else{
            
            DispatchQueue.global(qos: .background).async {
                if (imgUrl != nil){
                    // print(imgUrl!)
                    if  let data = try? Data(contentsOf: imgUrl!){//make sure your
                        
                        let image = UIImage(data: data)
                        
                        
                        DispatchQueue.main.async {
                            if((image) != nil){
                                self.user_Imageview.image = image
                                ImageCaching.sharedInterface().setImage(image, withID: imgUrl?.absoluteString)
                            }
                        }
                    }else{
                        self.user_Imageview.image = UIImage(named: "user");
                        
                    }
                }
            }
        }
}
    
//======================================
//MARK:- Refresh Karma points
//======================================
    func refreshKarmaPointsByNotifier() {
        DispatchQueue.main.async {
            self.kmPointsCount.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
        }
        
    }
    
//======================================
//MARK:- Tabel view delegate methods
//======================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOfTableItem.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SliderCell"
        var cell: SliderViewCellTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SliderViewCellTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "SliderViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SliderViewCellTableViewCell
        }
        cell.lbl_SupportCount.isHidden = true
        if(indexPath.row == 0){
            // To Show Unread Count For Suppor
            APP_Delegate().callForSliderVWToSowUnreadCount = {(isSuccess : Bool , result : Int) -> Void in
                if(isSuccess){
                    cell.lbl_SupportCount.isHidden = false
                    cell.lbl_SupportCount.text = String(format: "%d",APP_Delegate().supportsUnreadCount)
                }
            }
       
            cell.lbl_SupportCount.text = String(format: "%d",APP_Delegate().supportsUnreadCount == nil ? 0 : APP_Delegate().supportsUnreadCount)
            if(cell.lbl_SupportCount.text == "0"){
                cell.lbl_SupportCount.isHidden = true
            }else{
               cell.lbl_SupportCount.isHidden = false
            }
        }
       
        cell.lbl_ContantName.text = arrOfTableItem[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){ // Manage HR
           Communiti.removeSideView()
            if self.onHideComplete != nil {
               // self.onHideComplete("ManageHR")
                self.self.onHideComplete("Support")
            }
        }else if(indexPath.row == 1){ // Invite Frds
            self.shareBtnACtion()
            
        }else if(indexPath.row == 2){ // FeedBack
            
            UIApplication.shared.openURL(NSURL(string: "http://www.communiti.io/app-feedback/")! as URL)

        }else if(indexPath.row == 3){ // Contact Us
            
            UIApplication.shared.openURL(NSURL(string: "http://www.communiti.io/contact-us/")! as URL)

        }
    }
    
   
    
    @IBAction func btn_Action(_ sender: UIButton) {
        if(sender.tag == 5){ //Privacy policy
            
            UIApplication.shared.openURL(NSURL(string: "http://communiti.io/privacy-policy/")! as URL)

        }else if(sender.tag == 6){ // Turm of use
            
            UIApplication.shared.openURL(NSURL(string: "http://www.communiti.io/terms-of-use/")! as URL)

        }else if(sender.tag == 7){ //for Logout button
            self.userLogoutAction()
       
        }else if(sender.tag == 8){ // For UserProfile Btn
            
            Communiti.removeSideView()
            NotificationCentreClass.fireOpenUserProfileNotifire()

        }else if(sender.tag == 9){ // Btn Remove Slider
            
            Communiti.removeSideView()

        }
    }
    

    //====================================================
    //MARK:- Call Service For LogOut
    //====================================================
    /*
     1.usrToken->user token
     2.count->send some value if you want to get total count else blank
     3.helpId->help cat id
     
     */
    func userLogoutAction() {
        
        //showLoader(view: windowController().view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"]]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.userLogout , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                let loginManager = FBSDKLoginManager()
                loginManager.loginBehavior = FBSDKLoginBehavior.browser
                //loginManager.loginBehavior = FBSDKLoginBehavior.a
                loginManager.logOut() // this is an instance function
                Communiti.removeSideView()
                NotificationCentreClass.fireSignoutNotifier()
                UserDefaults.standard.removeObject(forKey: "TotalKMPoints")
                //ShowError(message: (response as! [String : Any])["message"]  as! String , controller: windowController())
            }
        })
    }
    
//====================================
//MARK:- Share Btn Action Method
//====================================
    func shareBtnACtion(){
        
        let text = String(format: "Join me on Communiti, the free app for helping and engaging in meaningful discussions with people around you! \n\nhttps://itunes.apple.com/us/app/communiti/id1234138195?ls=1&mt=8")
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = (self)// so that iPads won't crash
        
       /* activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if(success){
               btnClickEvent(caregoryNm: "Hive Request", action: "Share Hive Post", label:"")
            }
        }*/
        
        // present the view controller
         windowController().present(activityViewController, animated: true, completion: nil)
    }
    
}//END
