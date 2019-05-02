//
//  TabBarController.swift
//  Community
//
//  Created by Hatshit on 24/11/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper
import FBSDKLoginKit
import UserNotifications


class TabBarController: UITabBarController,UITabBarControllerDelegate , UNUserNotificationCenterDelegate {
    
    var sliderView = SliderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//================ first time defalt value is true===================
        APP_Delegate().reqType = true
        self.delegate = self
        UserDefaults.standard.set(true, forKey: "startApp")
//=============set color of tab bar selected item from here=============
        self.tabBar.tintColor = UIColor(red: 5.0/255.0, green: 163.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        
//=============set selected image for second selected item here=============
        self.tabBar.items![1].image = UIImage(named: "Hives")?.withRenderingMode(.alwaysOriginal)

//==================set OF Center Btn ====================
        self.setUpOfCenterBtnAndHamburger()

//================= Set BedgeCount Color of =================
        if #available(iOS 10.0, *) {
            //self.tabBar.items?[1].badgeColor = UIColor(red: 4/255, green: 163/255, blue: 163/255, alpha: 1)
        }
//================= Check User Is Login or not=========================
        if (UserDefaults.standard.bool(forKey: "isLoggedIn") == false) {
            let onBoardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnBoardVC") as! OnBoardVC
            self.navigationController?.pushViewController(onBoardVC, animated: false)
           // return
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            

            if(UserDefaults.standard.value(forKey: "TotalKMPoints") != nil){
                APP_Delegate().lbl_KMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
            }else{
                APP_Delegate().lbl_KMPoints.text = "0"
            }
            
            
            self.setInitialController()
            self.selectedIndex = 0
            self.navigationController?.navigationBar.isHidden = true // hidde bez when we come back from postvc navigation bar show
            
            if (UserDefaults.standard.bool(forKey: "isFirstTime") == true || (UserDefaults.standard.bool(forKey: "isLoggedIn") == true && UserDefaults.standard.bool(forKey: "startApp") == true)) {
                UserDefaults.standard.set(false, forKey: "isFirstTime")
                UserDefaults.standard.set(false, forKey: "startApp")
                NotificationCentreClass.fireCategoryNotifier()
            }else{
                if(APP_Delegate().reqType){
                    if(isNetwork){
                        // Fire Notification for FeedVC
                        let dict:[String: Any] = ["idx": 0]
                        NotificationCentreClass.firePostNotifier(dict: dict)
                    }
                }else{
                    NotificationCentreClass.fireHelpNotifier()
                }
            }
            
            if APP_Delegate().notiResponse != nil{ // When app is in kill mode and use tab notification banner
                let aps =  APP_Delegate().notiResponse!["aps"] as? [String : Any]
                print(aps ?? "")
                //ShowError(message: (aps!["type"] as? String)!, controller: windowController())
                if ( aps!["type"] as? String == "FIREBASE_CHAT_MSG") {
                    //self.selectedIndex = 1
                  
                }else if( aps!["type"] as? String == "ADMIN_CHAT_MSG"){
                    APP_Delegate().isAdmin = true
                    let chatScreenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatScreenVC") as! ChatScreenVC

                 
                        chatScreenVC.personNm = ""
                        chatScreenVC.otherUser_id =  ""
                        chatScreenVC.hlp_pst_id = ""
                        chatScreenVC.pstCreater_Id = ""
                        chatScreenVC.typeOfHelpReq = ""
                    let navcon = self.selectedViewController as? UINavigationController
                    navcon?.pushViewController(chatScreenVC, animated: true)
                    
                }else if (aps!["type"] as? String == "ACTION_INTERACTION"){
                    let day = String(format: "%d", ((aps!["date_day"]) as? Int)!)
                    if(day == "3"){
                        APP_Delegate().isEditHiveFld = false
                        let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
                        let navcon = self.selectedViewController as? UINavigationController
                        navcon?.pushViewController(categoryVC, animated: true)

                    }else{
                        self.selectedIndex = 0

                    }
                }else{
                    self.selectedIndex = 3
                    
                }
                APP_Delegate().notiResponse = nil
            }
        }
     }
    
//=============================================
// MARK:- SingleTon Calss Initilization Method
//=============================================
    func creatSharedStanceOfChatClass(_ notification: NSNotification){
        ChatClass.sharedInstance.getAllHelpedUserOnSelfPostAtChat(controller: self)
    }
    
//=============================================
// MARK:- InitialController Method
//=============================================

    func setInitialController(){
        NotificationCentreClass.removeSignoutNotifier(vc: self)
        if (UserDefaults.standard.bool(forKey: "isLoggedIn") == false) {
            let onBoardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnBoardVC") as! OnBoardVC
            self.navigationController?.pushViewController(onBoardVC, animated: false)
        }else{
            //================== Future Use OF Chat=============================
          // NotificationCentreClass.registerHelpedUserlistAtChatRegisterNotifier(vc: self, selector: #selector(self.creatSharedStanceOfChatClass(_:)))
            //=================================================================

            APP_Delegate().myOnlineStatus()
            APP_Delegate().getMyUnreadCountAtSupports()
        }
    }
    
//=============================================
// MARK:- setUpOfCenterBtnAndHamburger Method
//=============================================

    func setUpOfCenterBtnAndHamburger (){
        // Center Button Button
        let btnCenter = UIButton(frame: CGRect(x: self.view.frame.size.width/2 - 29, y:  self.view.frame.size.height-50, width: 58, height: 50))
        btnCenter.addTarget(self, action: #selector(moveToAddRequestVC(sender:)), for: UIControlEvents.touchUpInside)
        btnCenter.setBackgroundImage(UIImage(named:"logo_icon_1x"), for: .normal)
        btnCenter.imageView?.contentMode = .scaleToFill
        
        
        // For Hamburger Button
        let btnHamburger = UIButton(frame: CGRect(x: self.view.frame.size.width - 80, y:  self.view.frame.size.height-50, width: 80, height: 50))
        btnHamburger.addTarget(self, action: #selector(OpneSideView(sender:)), for: UIControlEvents.touchUpInside)
        btnHamburger.imageView?.contentMode = .scaleToFill
        
        self.view.addSubview(btnHamburger)
        self.view.addSubview(btnCenter)
    }
    
    
    @objc func moveToAddRequestVC (sender: AnyObject){
        let naviVC = self.viewControllers?.first as? UINavigationController
        let feedVC = naviVC?.viewControllers[0] as? FeedVC
        
     let isjoin  =   UserDefaults.standard.value(forKey: "isJoinedGrp") as? Bool
        if(isjoin)!{
                     APP_Delegate().reqType = true
                     APP_Delegate().isEditHiveFld = false
                    self.navigationController?.navigationBar.isHidden = false
                    self.navigationController?.navigationItem.backBarButtonItem?.title = "   "
                    let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
                    self.navigationController?.pushViewController(categoryVC, animated: true)
        }else{
                    let addReqVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddRequestVC") as? AddRequestVC)!
                    addReqVC.view.tag = 1000
                    addChildViewController(addReqVC)
                    self.view.addSubview((addReqVC.view)!)
        }

//      if(feedVC?.arrOFShowData.count == 0){
//        let addReqVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddRequestVC") as? AddRequestVC)!
//        addReqVC.view.tag = 1000
//        addChildViewController(addReqVC)
//        self.view.addSubview((addReqVC.view)!)
//      }else{
//         APP_Delegate().reqType = true
//         APP_Delegate().isEditHiveFld = false
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationItem.backBarButtonItem?.title = "   "
//        let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
//        self.navigationController?.pushViewController(categoryVC, animated: true)
//      }
    }

    
    @objc func OpneSideView (sender: AnyObject){
        
        NotificationCentreClass.registerSignoutNotifier(vc: self, selector: #selector(self.signoutNotifire(_:)))
        
        NotificationCentreClass.registerOpenUserProfileNotifire(vc: self, selector: #selector(self.OpenUserProfileNotifire(_:)))
        
        DispatchQueue.main.async {
            showSlideView(callBack: { (resultStr) in
                self.handleSideViewClickAction(callBackStr: resultStr)
            })
        }
    }
    
    
    func handleSideViewClickAction(callBackStr : String){
        if(callBackStr == "Support"){
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationItem.backBarButtonItem?.title = "   "
            APP_Delegate().isAdmin = true;
            let chatScreenVC = storyboard?.instantiateViewController(withIdentifier: "ChatScreenVC") as! ChatScreenVC
            
            chatScreenVC.personNm = ""
            chatScreenVC.otherUser_id =  ""
            chatScreenVC.hlp_pst_id = ""
            chatScreenVC.pstCreater_Id = ""
            chatScreenVC.typeOfHelpReq = ""
            self.navigationController?.pushViewController(chatScreenVC, animated: true)
            
            //if(callBackStr == "ManageHR"){
//            self.navigationController?.navigationBar.isHidden = false
//            self.navigationController?.navigationItem.backBarButtonItem?.title = "   "
//             let manageHRVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManageHRVC") as! ManageHRVC
//             self.navigationController?.pushViewController(manageHRVC, animated: true)
        }
    }

//=============================================
// MARK:- Tab  Bar Did Select  Method
//=============================================
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        let tabBarItem = tabBarController.tabBar.items
        for item in tabBarItem!{
         item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
            switch (item.tag) {
            case 0:
                item.imageInsets = UIEdgeInsetsMake(7, 1, -4, 3)
                break;
            case 1:
                 item.imageInsets = UIEdgeInsetsMake(7, 1, -4, 2)
                break;
            case 2:
                break;
            case 3:
                item.imageInsets = UIEdgeInsetsMake(8, 2, -5, 2)
                break;
            case 4:
                item.imageInsets = UIEdgeInsetsMake(8, 5, -5, 0);
                break;
                
            default:
                break;
           }
        }
    
    }

    
//====================================================
//MARK:- Signout Notifire Method
//====================================================
    func signoutNotifire(_ notification: NSNotification){
        NotificationCentreClass.fireRemoveArrayOfFeedVCNotifier()
        NotificationCentreClass.fireRemoveArrayOfChatVCNotifier()
        NotificationCentreClass.fireRemoveArrayOfNotificationVCNotifier()
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
         loginManager.logOut()
         UserDefaults.standard.set(false, forKey: "isLoggedIn")
         APP_Delegate().reqType =  true // after login always show hive post
         self.setInitialController()
        
    }
    
//====================================================
//MARK:- OpenUser Profile Notifire Method
//====================================================
    func OpenUserProfileNotifire(_ notification: NSNotification){
      
        let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "USERPROFILEVC") as! UserProfileVC
        userProfileVC.otherUserId = getUserData()["usr_id"] as! String

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationItem.backBarButtonItem?.title = "   "
        DispatchQueue.main.async {
              self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
        NotificationCentreClass.removeOpenUserProfileNotifire(vc: self)
    }
    
    


}// END
