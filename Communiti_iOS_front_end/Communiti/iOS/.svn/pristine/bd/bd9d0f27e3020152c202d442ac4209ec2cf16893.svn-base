//
//  AppDelegate.swift
//  Community
//
//  Created by Hatshit on 23/11/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GooglePlaces
import GoogleMaps
import CoreTelephony
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate{
    var window: UIWindow?
    var reqType : Bool!  //( Hive = True , Help = false)
   // var isPopFromHive : Bool! //( Hive = True , Help = false)
  //  var isFltEnable = false
    var isPopForLogin = false
    var isAdmin = false
    
    var isEditHiveFld : Bool!
    var isEditHelpFld : Bool!
    var currentCountry:String?
    var notiResponse : [String : Any]?
    var refreshKmPoints : String!
    var isNotification = false
    var currentChatUser : String!
    var lbl_KMPoints : UILabel!
     var listOfReport : [CountryList]!
    var cities = [CountryList]()
    var launchedURL : URL?
    var isRefreshFeedVClist = false // when some one join new group
    
    var firBaseStatusRefreshOfAdmin : DatabaseReference?
    var firNewStatusHandlerOfAdmin  : DatabaseHandle?
    var supportsUnreadCount : Int!
    var callForFeedVCToSowUnreadCount: ((Bool , Int) -> Void)?
    var callForChatVCToSowUnreadCount: ((Bool , Int) -> Void)?
    var callForSliderVWToSowUnreadCount: ((Bool , Int) -> Void)?
    var firBaseMsgRefreshOfAdmin : DatabaseReference?
    var firNewMsgHandlerOfAdmin  : DatabaseHandle?
    var initiallyAdd = false
    var chatNodeOfAdmin : String?
    var blockView = BlockView()
    var meOnline : DatabaseReference?  //Chat User Online offline  status
    var userDeviceToken : String!
   // var adminNm : String?
   
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
//----------------------Check Network--------------------------------------

      StartNetworkMonitoring()
      UIApplication.shared.applicationIconBadgeNumber = 0
        self.window!.rootViewController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if let url = launchOptions?[.url] as? URL {
            self.launchedURL = url
        }
        
//------For Local Notification For Chat (Admin Mess Cones in background stat)----------------------
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            let options: UNAuthorizationOptions = [.alert, .sound];
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    print("Something went wrong")
                }
                
                if(!(error != nil)){
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                let userNotificationTypes  =  UIUserNotificationType([.alert, .sound ,.badge])
                let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
            }
         
        }
     
        
    //------------for get country ISO country code----------------------
        let networkInformation = CTTelephonyNetworkInfo()
        if let carrier = networkInformation.subscriberCellularProvider {
            currentCountry = carrier.isoCountryCode?.uppercased()
        }
      
      //  StartNetworkMonitoring()
    //--------------- GMS Place Key to search place---------------------
        GMSPlacesClient.provideAPIKey(KgooglePlaceAPIKey)
        
    //--------------- Google Key For Map---------------------------------
        GMSServices.provideAPIKey(KgoogleMapAPIKey)

        
        
    //---------------------Launch app first time-----------------------
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            
            UserDefaults.standard.set(true, forKey: "IsShowGreatAnsAlert")
            UserDefaults.standard.set(true, forKey: "FirstLocation")
        }
    // ----------------registerForRemoteNotifications-----------------
        
           registerForPushNotifications(application: application)
      
        
    // ----------------------For FireBase-----------------------------
          FirebaseApp.configure()
        
    //================  GoogLe Analytics  ===============================

        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
             return true
        }
        gai.tracker(withTrackingId: "UA-115363538-1")
        gai.trackUncaughtExceptions = true
        // Remove before app release.
        gai.logger.logLevel = .verbose;

        
         return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    //===============================================================================
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {

        let arr = url.description.components(separatedBy:"//")
        
        if arr[0] == "fb295840220874090:" {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }else {
            
            return self.openLink(url: url)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
            //StopNetowrkMonitoring()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
          UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        StartNetworkMonitoring()
        if(self.launchedURL != nil){
            self.openLink(url: self.launchedURL!)
            self.launchedURL = nil
        }
    }
    
    func openLink(url:URL) -> Bool{
        let arr = url.description.components(separatedBy:"//")

        let urlComponents = arr[1].description.components(separatedBy:"&")
        var dict = Dictionary<String, Any>()
        for keyValue in urlComponents {
            let pairComponents = keyValue.description.components(separatedBy:"=")
            let key = pairComponents.first
            let value = pairComponents.last
            dict[(key?.description)!] = (value?.description)!
        }
        
        if (self.window!.rootViewController as! UINavigationController).viewControllers.count == 0{
            //                isNotification = true
            //                notiResponse = dict
            return true;
        }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        /// for Hive navigation
        if ((dict["type"] as? String) == "hive"){
            let postVC = mainStoryboard.instantiateViewController(withIdentifier: "PostVC") as! PostVC
            //postVC.isCameFrmCompletedHRVC = false
            postVC.isCameFrmNotiVC = false
            let countryList = Mapper<CountryList>().map(JSONObject: dict)
            postVC.ctyListObjFrmFeedVC = countryList
            
            
            for viewCon in (self.window!.rootViewController as! UINavigationController).viewControllers.reversed(){
                
                if ((self.window!.rootViewController as! UINavigationController).viewControllers.count == 1){
                    let navcon = (viewCon as? TabBarController)?.selectedViewController as? UINavigationController
                    if (viewCon.isKind(of: TabBarController.self) ){
                        for view in (navcon?.viewControllers)!.reversed(){
                            view.navigationController?.popViewController(animated: false)
                        }
                        navcon?.pushViewController(postVC, animated: true)
                        return true;
                    }
                    break
                }
                viewCon.navigationController?.popViewController(animated: false)
            }
            
            /// for Help navigation
        }else if((dict["type"] as? String) == "help"){
            let helpReqDetaliVC = mainStoryboard.instantiateViewController(withIdentifier: "HelpReqDetaliVC") as! HelpReqDetaliVC
            
            let countryList = Mapper<CountryList>().map(JSONObject: dict)
            helpReqDetaliVC.ctylstObjFrmHelpVC = countryList
            helpReqDetaliVC.postId = countryList?.pst_id
            for viewCon in (self.window!.rootViewController as! UINavigationController).viewControllers{
                if (viewCon.isKind(of: TabBarController.self) ){
                    let navcon = (viewCon as? TabBarController)?.selectedViewController as? UINavigationController
                    navcon?.pushViewController(helpReqDetaliVC, animated: true)
                    return true;
                }
            }
        }else if ((dict["type"] as? String) == "KarmaPoints"){
            
            let karmaPointsVC = mainStoryboard.instantiateViewController(withIdentifier: "KARMAPOINTSVC") as! KarmaPointsVC

            for viewCon in (self.window!.rootViewController as! UINavigationController).viewControllers{
                if (viewCon.isKind(of: TabBarController.self) ){
                    let navcon = (viewCon as? TabBarController)?.selectedViewController as? UINavigationController
                    navcon?.pushViewController(karmaPointsVC, animated: true)

                    return true;
                }
            }
            
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        StopNetowrkMonitoring()
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

    
    func tokenExpired(controller : UIViewController){
        
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        DispatchQueue.main.async {
            if(controller.isKind(of: TabBarController.self)){
                 (controller as? TabBarController)?.setInitialController();
                  ShowError(message: "Your session has timed out, please login again.", controller: windowController())
            }
        }
    }
    
    
    func showBlockPopup( title : String?, controller : UIViewController) -> Void {
        
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
       
        DispatchQueue.main.async {
                (controller as? TabBarController)?.setInitialController();
                self.blockView = BlockView.instanceFromNib() as! BlockView;
                self.blockView.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.width), height: UIScreen.main.bounds.height)
                self.blockView.setText(title: title)
                windowController().view.addSubview(self.blockView)
                self.blockView.layoutIfNeeded()
                self.showBlockViewWithAnimation(view: self.blockView )
           
        }
    }
    
    
    func showBlockViewWithAnimation(view : BlockView){
        view.isHidden=false;
        view.alert_View.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        view.bg_View.alpha = 0.0 ;
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        view.bg_View.alpha = 0.7
                        view.alert_View.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (finished) -> Void in
        })
    }
    
    
//============================================
//MARK:- My Online Status For Firebase
//============================================
    func myOnlineStatus() {
    
        meOnline = Database.database().reference(withPath:  String(format: "/useronlinestaus/user_id_%@/status", getUserData()["usr_id"] as! String))
        
        meOnline?.updateChildValues(["online" : 1])
        meOnline?.onDisconnectSetValue(["online" : 0])
    }
    
//============================================
//MARK:- Registor Push Notifications
//============================================
    
    func registerForPushNotifications(application: UIApplication) {
        

        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    DispatchQueue.main.async {
                          UIApplication.shared.registerForRemoteNotifications()
                    }
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }else{ //If user is not on iOS 10 use the old methods we've been using
            let notificationSettings = UIUserNotificationSettings(types:  [.badge, .sound, .alert], categories: nil)
             application.registerUserNotificationSettings(notificationSettings)
        }
    }
    
//============================================
//MARK:- Push Notifications Delegate Methods
//============================================
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        userDeviceToken = deviceTokenString
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       // print("APNs registration failed: \(error)")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       // print("APNs registration Response: \(response.notification.request.content.userInfo)" )
        
        let aps = response.notification.request.content.userInfo["aps"] as? [String : Any]
        notiResponse = response.notification.request.content.userInfo as? [String : Any]
        
        if !isNotification  {
            return
        }
        
        
        for viewCon in (self.window!.rootViewController as! UINavigationController).viewControllers.reversed(){
          
            if ((self.window!.rootViewController as! UINavigationController).viewControllers.count == 1){
              
                let navcon = (viewCon as? TabBarController)?.selectedViewController as? UINavigationController
                let viewControllers = navcon?.viewControllers
                if(viewControllers?.count != 0){
                    viewControllers?.last?.navigationController?.popToRootViewController(animated: true)
                }
                if (viewCon.isKind(of: TabBarController.self) ){

                    if ( aps!["type"] as? String == "FIREBASE_CHAT_MSG") {
                       // (viewCon as? TabBarController)?.selectedIndex = 1
                    }else if( aps!["type"] as? String == "ADMIN_CHAT_MSG"){

                        self.moveAdminChatRoom()
                       // (viewCon as? TabBarController)?.selectedIndex = 1
                    }else if(aps!["type"] as? String == "ACTION_INTERACTION"){
                      
                         let day = String(format: "%d", ((aps!["date_day"]) as? Int)!)
                        if(day == "3"){
                           // self.openCategoryVCOfHiveWhenNotiCome(tabBarVC: (viewCon as? TabBarController)!);
                        }else{
                            (viewCon as? TabBarController)?.selectedIndex = 0

                        }
                        
                    }else if (aps!["type"] as? String == "LOGIN_INTERACTION"){
                        let day = String(format: "%d", ((aps!["date_day"]) as? Int)!)
                        
                    if(day == "3"){
                        APP_Delegate().reqType = true
                        let dict:[String: Any] = ["idx": 0]
                        NotificationCentreClass.firePostNotifier(dict: dict)
                            
                    }else{
                        APP_Delegate().reqType = false
                       // NotificationCentreClass.fireHelpNotifier()
                    }

                       
                    (viewCon as? TabBarController)?.selectedIndex = 0
                        
                }else{ // All Type
                        
                    (viewCon as? TabBarController)?.selectedIndex = 3
                    }
                }
                break
            }
        }
        
        // Print notification payload data
       // print("Push notification received: \(userInfo)")
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        isNotification = true
        
        completionHandler([.badge, .alert, .sound])
        print("APNs registration Response: \(notification.request.content.userInfo["aps"])" )
        let aps = notification.request.content.userInfo["aps"] as? [String : Any]
          print("APNs registration Response: \(aps)" )

        
        UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber + 1
        
        if let type = aps!["type"] as? String {

        if (type != "FIREBASE_CHAT_MSG" && type != "ADMIN_CHAT_MSG" && type != "ACTION_INTERACTION" && type != "LOGIN_INTERACTION"){
            
            UserDefaults.standard.set("YES", forKey: "ShowNotificationCount")
            
          NotificationCentreClass.fireRemoveArrayOfNotificationVCNotifier()
          NotificationCentreClass.fireRefreshNotificationScreen()
          NotificationCentreClass.fireGetTotalKrmPointsUsingNotificationCenter()
            
        }
            
        if(type == "HIVE"){

             NotificationCentreClass.fireGetHivePostDetailsNotifire()

        }else if(type == "HELP"){
            // NotificationCentreClass.fireGetHelpReqDetailsNotifire()

        }else if(type == "KPOINT"){
            // NotificationCentreClass.fireGetTotalKrmPointsUsingNotificationCenter()
            
        }else if(type == "ACTION_INTERACTION"){ // When user not creat any hive post
 
            let dict:[String: Any] = ["idx": 0]
            NotificationCentreClass.firePostNotifier(dict: dict)
            
        }else if(type == "LOGIN_INTERACTION"){
            let day = String(format: "%d", ((aps!["date_day"]) as? Int)!)

            
        }else if(type == "CHAT"){
            
            let dict = ["pst_usr_id": aps!["pst_usr_id"],
                        "usr_fname": aps!["usr_fname"],
                        "usr_id": aps!["hlp_usr_id_frm"],
                        "hlp_pst_id": aps!["hlp_pst_id"]]
            
            ChatClass.sharedInstance.arrOfData.append( ChatClassDataModel.init(dic: (dict as? [String:Any])! ))
            
                ChatClass.sharedInstance.showAlertNewMessage()
            }
       }
    }
    
    func moveAdminChatRoom(){
        APP_Delegate().isAdmin = true

        for viewCon in (self.window!.rootViewController as! UINavigationController).viewControllers.reversed(){
        if (viewCon.isKind(of: TabBarController.self) ){
            let chatScreenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatScreenVC") as! ChatScreenVC
           
            chatScreenVC.personNm = ""
            chatScreenVC.otherUser_id =  ""
            chatScreenVC.hlp_pst_id = ""
            chatScreenVC.pstCreater_Id = ""
            chatScreenVC.typeOfHelpReq = ""
            let navcon = (viewCon as? UITabBarController)?.selectedViewController as? UINavigationController
            navcon?.pushViewController(chatScreenVC, animated: true)
            
            }
        }
        
 
      //  navigationController?.pushViewController(chatScreenVC, animated: true)
    }
    
    
    func openCategoryVCOfHiveWhenNotiCome(tabBarVC : UITabBarController){
        
        APP_Delegate().isEditHiveFld = false
        let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        let navcon = tabBarVC.selectedViewController as? UINavigationController
        navcon?.pushViewController(categoryVC, animated: true)
    }

    
    func getMyUnreadCountAtSupports(){
        
        self.firBaseStatusRefreshOfAdmin = Database.database().reference(withPath:  String(format: "/admin/admin_userId_%@/status/admin/", getUserData()["usr_id"] as! String))
        
        firBaseStatusRefreshOfAdmin?.observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
           // print(snapshot)
            
            //Checking this Node Exists or not in FIREBASE DATABASE
            if(!snapshot.exists()){
                
                let mess = " Welcome to Communiti, the app that brings you closer to people around you to provide and seek help and advise from them! Go to the Hive to start a discussion or ask a question. Check out the Help to help or ask for help from folks nearby! \n\n We're super pumped to see you here, feel free to ping me in case you need anything!"
                
                if #available(iOS 10.0, *) {
                    let content = UNMutableNotificationContent()
                 
                    content.title = ""
                    content.body = mess
                    content.sound = UNNotificationSound.default()
                    content.userInfo = ["aps":["type":"ADMIN_CHAT_MSG"]]
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "adminNotification", content: content, trigger: trigger)
                    let center = UNUserNotificationCenter.current()
                    center.add(request, withCompletionHandler: { (error) in
                        if error != nil {
                            // Something went wrong
                        }
                    })
                } else {
                    let notification = UILocalNotification()
                    notification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date
                    notification.alertBody = mess
                    notification.userInfo = ["aps":["type":"ADMIN_CHAT_MSG"]]
                    notification.soundName =  UILocalNotificationDefaultSoundName
                    notification.timeZone = NSTimeZone.default
                    UIApplication.shared.scheduleLocalNotification(notification)
                }
                
                let dict : [String : Any] = ["receipt" : 0 ,"sender" : "admin" ,"message" : mess ,"timestamp" : convertDateForFirebaseInUTC(date : Date()) ,"firstname" : "admin","lastname" : "" ]
                self.chatNodeOfAdmin =  String(format: "admin/admin_userId_%@", getUserData()["usr_id"] as! String)
                self.firBaseMsgRefreshOfAdmin = Database.database().reference(withPath:  String(format: "/%@/message", self.chatNodeOfAdmin!))
                self.firBaseMsgRefreshOfAdmin?.childByAutoId().setValue(dict)
                self.firBaseStatusRefreshOfAdmin?.updateChildValues(["unread" : 1])
            }
            
            
            self.firNewStatusHandlerOfAdmin = self.firBaseStatusRefreshOfAdmin?.observe(.value, with: { [unowned self] (snapshot : DataSnapshot) in
                guard snapshot.exists() else{ return  }
                let snapValue1 = snapshot.value as? [String : Any]
                
                print("userid %@",snapValue1!)
                let snapValue = snapshot.value as? [String : Any]
                if(snapValue?["unread"] != nil){
                    self.supportsUnreadCount = snapValue?["unread"] as! Int
                    print(self.supportsUnreadCount ?? 0)
                    
                    if self.callForFeedVCToSowUnreadCount != nil {
                        self.callForFeedVCToSowUnreadCount!(true , self.supportsUnreadCount!)
                    }
                    if self.callForChatVCToSowUnreadCount != nil {
                        self.callForChatVCToSowUnreadCount!(true , self.supportsUnreadCount!)
                    }
                    if self.callForSliderVWToSowUnreadCount != nil {
                        self.callForSliderVWToSowUnreadCount!(true , self.supportsUnreadCount!)
                    }
                    
                    
                   
                }
            })
            
            
            self.setUpForAdminChart()
        })
    }
    
    
    
    
    func setUpForAdminChart(){
        
        chatNodeOfAdmin =  String(format: "admin/admin_userId_%@", getUserData()["usr_id"] as! String)
          
        firBaseMsgRefreshOfAdmin = Database.database().reference(withPath:  String(format: "/%@/message", chatNodeOfAdmin!))
        
        self.initiallyAdd = true
        
        firNewMsgHandlerOfAdmin = firBaseMsgRefreshOfAdmin?.queryOrderedByKey().queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot : DataSnapshot) in
            
            //print("call number of time %@",snapshot);
            if( APP_Delegate().currentChatUser != (snapshot.value as! [String : Any])["sender"] as? String){
            
            if(snapshot.value != nil){
                if(!self.initiallyAdd){
                    if((snapshot.value as! [String : Any])["sender"] as? String == "admin"){
                        if #available(iOS 10.0, *) {
                            let content = UNMutableNotificationContent()
                           //content.title = "Admin"
                         
                            content.title = ((snapshot.value as! [String : Any])             ["firstname"] as? String)!
                            content.body = ((snapshot.value as! [String : Any])             ["message"] as? String)!
                            content.sound = UNNotificationSound.default()
                            content.userInfo = ["aps":["type":"ADMIN_CHAT_MSG"]]
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                            let request = UNNotificationRequest(identifier: "adminNotification", content: content, trigger: trigger)
                            let center = UNUserNotificationCenter.current()
                            center.add(request, withCompletionHandler: { (error) in
                                if error != nil {
                                    // Something went wrong
                                }
                            })
                        } else {
                            let notification = UILocalNotification()
                            notification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date
                            notification.alertBody = ((snapshot.value as! [String : Any])["message"] as? String)!
                            notification.userInfo = ["aps":["type":"ADMIN_CHAT_MSG"]]
                            notification.soundName =  UILocalNotificationDefaultSoundName
                            notification.timeZone = NSTimeZone.default
                            UIApplication.shared.scheduleLocalNotification(notification)
                        }
                    }
                }
            }
                
         }
            
        })
        
        firBaseMsgRefreshOfAdmin?.queryOrderedByKey().queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
            self.initiallyAdd = false
        })
        
    }
    
    
    

}//END

