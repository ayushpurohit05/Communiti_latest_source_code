//
//  ChatClass.swift
//  Community
//
//  Created by Hatshit on 16/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class ChatClass: NSObject {
    
    //    -(void)unreadCallback:(void(^)(void))unreadCallback;
    //    -(void)unreadCallbackOnView:(void(^)(void))unreadCallback;
    //    -(void)tableReloadCallback:(void(^)(void))reloadCallback;
    //    -(int)getTotelcount;
    
    
    var unreadViewCallback: (() -> Void)?
    var unreadVCCallback: (() -> Void)?
    var reloadCallback: (() -> Void)?
    //var unreadViewCallback: ()?

   // @property(copy,nonatomic) void(^unreadViewCallback)(void);
   // @property(copy,nonatomic) void(^unreadVCCallback)(void);
   // @property(copy,nonatomic) void(^reloadCallback)(void);
    
    
   public var arrOfData = [ChatClassDataModel]()
    
     class var sharedInstance: ChatClass {
        struct Static {
            static let instance = ChatClass()
        }
        return Static.instance
    }
    
    //Remove Singleton object with all refresh
    func removeAllobject() {
        
        if self.arrOfData.count != 0 {
            for (_, obj) in self.arrOfData.enumerated(){
                obj.removeObservernotification()
            }
        }
    }
    
    
    
    //========================================================
    // MARK:- Call SerVice For Get OtherHelp Req List
    //========================================================
    
    /*
     1.usrToken->user token
     2.locId->location id
     */
    func getAllHelpedUserOnSelfPostAtChat(controller : UIViewController){
      
        
        if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {

        
        showLoader(view: controller.view)// show loader
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"]]
              
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.getAllHelpedUserOnSelfPostAtChat , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                
                if(isError){
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: controller, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
                }
                
                return
            }
            DispatchQueue.main.async {
                killLoader()
              //  NotificationCentreClass.removeHelpedUserlistAtChatNotifier(vc: weakSelf)
               
                
                if weakSelf.arrOfData.count != 0 {
                    for (_, obj) in weakSelf.arrOfData.enumerated(){
                        obj.removeObservernotification()
                    }
                }
                
               
                if weakSelf.arrOfData.count != 0 {
                    weakSelf.arrOfData.removeAll()
                }
                
                
                let array  = (response as! [String : Any])["data"] as! [[String : Any]]
               
                for (_, obj) in array.enumerated(){
                  weakSelf.arrOfData.append( ChatClassDataModel.init(dic: obj))
                }
                    weakSelf.showAlertNewMessage()
            }
         })
        }
    }
  
    
    func unreadCallback(callBack : @escaping () -> Void ) { //Feed
        
        if((unreadViewCallback) != nil){
           unreadViewCallback=nil;
        }
        unreadViewCallback = callBack
        showAlertNewMessage()
    }
    
    func unreadCallbackOnView(callBack : @escaping () -> Void ) { //Chat
       
        if((unreadVCCallback) != nil){
            unreadVCCallback=nil;
        }
        unreadVCCallback = callBack
        showAlertNewMessage()
    }
   
    func tableReloadCallback(callBack : @escaping () -> Void ) {
       
        if((reloadCallback) != nil){
            reloadCallback=nil;
        }
        reloadCallback = callBack
    }

    
    func showAlertNewMessage(){
        
        for (_, obj) in arrOfData.enumerated(){
           
            obj.unreadMessageCallback(callBack: { (count : Int) in
                if(self.reloadCallback != nil){
                    self.reloadCallback!()
                }
               
                if(count > 0){
                    if(self.unreadViewCallback != nil){
                        self.unreadViewCallback!()
                        if(self.unreadVCCallback != nil){
                            self.unreadVCCallback!();
                        }
                    }else {
                        if(self.unreadVCCallback != nil){
                            self.unreadVCCallback!();
                        }
                    }
                }
            })
        }
    }
    
    
//-------------------Show All Unread Message----------------
    func getTotelcount() -> (Int){
        
        var totelCount = 0
        for obj: ChatClassDataModel in arrOfData{
            totelCount = totelCount + obj.myUnreadCount
        }
     
        return totelCount
    }
   
    func getMyPostCount() -> (Int){
        
        var totelCount = 0
       
        for obj: ChatClassDataModel in arrOfData{
            
            if (obj.pst_usr_id! == getUserData()["usr_id"] as! String) {
                totelCount = totelCount + obj.myUnreadCount
            }
        }
        return totelCount
    }
    
    
    func getOtherPostCount() -> (Int){
        
        var totelCount = 0
        
        for obj: ChatClassDataModel in arrOfData{
            
            if (obj.pst_usr_id! != getUserData()["usr_id"] as! String) {
                totelCount = totelCount + obj.myUnreadCount
            }
        }
        return totelCount
    }
    

    
    //getTotalCountOf

    
}//end


