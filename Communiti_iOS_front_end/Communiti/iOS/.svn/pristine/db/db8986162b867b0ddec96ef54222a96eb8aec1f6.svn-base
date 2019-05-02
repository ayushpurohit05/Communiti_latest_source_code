//
//  NotificationCentre.swift
//  Community
//
//  Created by Hatshit on 15/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit

class NotificationCentreClass: NSObject {

    
    
    //=============
    //GetPost
    //=============
    class func registerPostRegisterNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "GetPost"), object: nil)
      }
    
    
    class func firePostNotifier(dict:[String: Any]) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetPost"), object: nil, userInfo: dict)
    }
    
    
    class func removePostNotifier(vc : Any) -> Void {
       NotificationCenter.default.removeObserver(vc, name: Notification.Name("GetPost"), object: nil)
    }
    
    //=============
    //GetPost
    //=============
    class func registerHelpRegisterNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "GetHelpReqPost"), object: nil)
    }
    
    
    class func fireHelpNotifier() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetHelpReqPost"), object: nil, userInfo: nil)
    }
    
    
    class func removeHelpNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("GetHelpReqPost"), object: nil)
    }
    
    
    
    
    //=============
    //GetCategor
    //=============
    class func registerCategoryRegisterNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "GetCategory"), object: nil)
    }
    
    
    class func fireCategoryNotifier() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetCategory"), object: nil)
    }
    
    
    class func removeCategoryNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("GetCategory"), object: nil)
    }
    
    
    
    //============================
    //Get HelpedUserListfor chat
    //============================
    class func registerHelpedUserlistAtChatRegisterNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "GetHelpUsrAtChat"), object: nil)
    }
    
    
    class func fireHelpedUserlistAtChatNotifier() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetHelpUsrAtChat"), object: nil)
    }
    
    
    class func removeHelpedUserlistAtChatNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("GetHelpUsrAtChat"), object: nil)
    }
    
    
    
    //==================
    //Signout Notifier
    //==================
   
    class func registerSignoutNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "Signout"), object: nil)
    }
    
    class func fireSignoutNotifier() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Signout"), object: nil)
    }
    
    class func removeSignoutNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("Signout"), object: nil)
    }
    
    //============================
    //OpenUserProfile Notifier
    //============================
    
    class func registerOpenUserProfileNotifire(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "OpenUserProfile"), object: nil)
    }
    
    class func fireOpenUserProfileNotifire() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenUserProfile"), object: nil)
    }
    
    class func removeOpenUserProfileNotifire(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("OpenUserProfile"), object: nil)
    }
    
    //==============================================================
    // Notifier getHivePostDetailsUsingNotificationCenter Notifier
    //==============================================================
    
    class func registerGetHivePostDetailsNotifire(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "getHivePostDetailsUsingNotificationCenter"), object: nil)
    }
    
    class func fireGetHivePostDetailsNotifire() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getHivePostDetailsUsingNotificationCenter"), object: nil)
    }
    
    class func removeGetHivePostDetailsNotifire(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("getHivePostDetailsUsingNotificationCenter"), object: nil)
    }
    
    //==============================================================
    // Notifier getHelpReqDetailsUsingNotificationCenter Notifier
    //==============================================================
    
    class func registerGetHelpReqDetailsNotifire(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "getHelpPostDetailsUsingNotificationCenter"), object: nil)
    }
    
    class func fireGetHelpReqDetailsNotifire() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getHelpPostDetailsUsingNotificationCenter"), object: nil)
    }
    
    class func removeGetHelpReqDetailsNotifire(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("getHelpPostDetailsUsingNotificationCenter"), object: nil)
    }
    
    //==============================================================
    // Notifier GetTotalKrmPointsUsingNotificationCenter Notifier
    //==============================================================
    
    class func registerGetTotalKrmPointsUsingNotificationCenter(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "getTotalKrmPointsUsingNotificationCenter"), object: nil)
    }
    
    class func fireGetTotalKrmPointsUsingNotificationCenter() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getTotalKrmPointsUsingNotificationCenter"), object: nil)
    }
    
    class func removeGetTotalKrmPointsUsingNotificationCenter(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("getTotalKrmPointsUsingNotificationCenter"), object: nil)
    }
    
    
    
    //==============================================================
    // Notifier GetTotalKrmPointsUsingNotificationCenter Notifier
    //==============================================================
    
    class func registerRefreshNotificationScreen(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "RefreshNotificationScreen"), object: nil)
    }
    
    class func fireRefreshNotificationScreen() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshNotificationScreen"), object: nil)
    }
    
    class func removeRefreshNotificationScreen(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("RefreshNotificationScreen"), object: nil)
    }
    
    //================================================
    //Refresh Karma points Notifier
    //================================================
    
    class func registerRefreshKarmaPointsNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "RefreshKarmaPoints"), object: nil)
    }
    
    class func fireRefreshKarmaPointsNotifier() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshKarmaPoints"), object: nil)
    }
    
    class func removeRefreshKarmaPointsNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("RefreshKarmaPoints"), object: nil)
    }
    
    //================================================
    //Remove Array Of Feed VC
    //================================================
    class func registerRemoveArrayOfFeedVCNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "RemoveArrayOfFeedVC"), object: nil)
    }
    
    class func fireRemoveArrayOfFeedVCNotifier() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RemoveArrayOfFeedVC"), object: nil)
    }
    
    class func removeRemoveArrayOfFeedVCNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("RemoveArrayOfFeedVC"), object: nil)
    }
    
    
    //================================================
    //Remove Array Of ChatVC
    //================================================

    class func registerRemoveArrayOfChatVCNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "RemoveArrayOfChatVC"), object: nil)
    }
    
    class func fireRemoveArrayOfChatVCNotifier() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RemoveArrayOfChatVC"), object: nil)
    }
    
    class func removeRemoveArrayOfChatVCNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("RemoveArrayOfChatVC"), object: nil)
    }
    
    //================================================
    //Remove Array Of NotificationVC
    //================================================
    
    class func registerRemoveArrayOfNotificationVCNotifier(vc : Any, selector : Selector) -> Void {
        NotificationCenter.default.addObserver(vc, selector: selector, name: NSNotification.Name(rawValue: "RemoveArrayOfNotificationVC"), object: nil)
    }
    
    class func fireRemoveArrayOfNotificationVCNotifier() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RemoveArrayOfNotificationVC"), object: nil)
    }
    
    class func removeRemoveArrayOfNotificationVCNotifier(vc : Any) -> Void {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("RemoveArrayOfNotificationVC"), object: nil)
    }
 
  
}
