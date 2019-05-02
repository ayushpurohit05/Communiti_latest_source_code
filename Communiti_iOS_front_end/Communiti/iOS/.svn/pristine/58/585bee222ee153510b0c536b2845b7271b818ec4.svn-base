//
//  ChatScreenVC.swift
//  Community
//
//  Created by Hatshit on 16/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import Firebase
import Darwin
import UserNotifications



class ChatScreenVC: UIViewController , UITextViewDelegate , UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate{
    
    @IBOutlet weak var ChatView_H: NSLayoutConstraint!
    @IBOutlet weak var bgVwOFMess_H: NSLayoutConstraint!
    @IBOutlet weak var lbl_mess_H: NSLayoutConstraint!
    @IBOutlet weak var chat_txtView: UITextView!
    @IBOutlet weak var lbl_CatNm: UILabel!
    @IBOutlet weak var lbl_Msg: UILabel!
    @IBOutlet weak var chat_view: UIView!
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var containerVw_H: NSLayoutConstraint!
    
    var pst_title : String!
    var pst_completed : String!
    var typeOfHelpReq : String!
    var cellIdxPath : IndexPath!
    var currentDate : String!
    var dictOfData = [String : [ChatScreenDM]]()
    var arryChat = [[String : [ChatScreenDM]]]()
    
    //Chat Instance 
    var chatNode : String?
    
    var firBaseMsgRefresh : DatabaseReference?
    var meStatus : DatabaseReference?
    var postUnreadCount : DatabaseReference?
    var myUnReadMessPath : DatabaseReference?

   
    var meStatusHandler : DatabaseHandle?
    var msgAddedHandler : DatabaseHandle?
    var postUnreadCountHandler : DatabaseHandle?

    var arrOfShowData = [ChatScreenDM]()
   // var arrOfShowData = [String]()
    var personNm : String!
    var otherUser_id : String!
    var hlp_pst_id : String!
    var pstCreater_Id : String!
    var countryListObj: CountryList?
    
    var chatHomeDataModel : ChatHomeDM!
    var MYchatHomeDataModel : MYChatHomeDM!
    var endReqAlert = EndReqAlert()
    var helpedUsrLstVw = HelpedUserListView()

    
    var otherUnreadCount  = 0
    var postUnreadMsgCount  = 0
    var muUnreadMsgCount  = 0

    
//    var BubbleHeightOffset : CGFloat = 100.0;
//    var BubbleWidthOffset : CGFloat = 20.0;
//    var AvatarImageOffset : CGFloat = 55.0;
//    var padding : CGFloat = 120.0;
//
//    var widthPaging : CGFloat = 20.0
//    var heightPaging : CGFloat = 10.0

    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    var isLoading = false
    var isMoreData = true


    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        DispatchQueue.main.async {
             APP_Delegate().currentChatUser = self.otherUser_id
          self.initilizeFirebase()
           // self.setUpForAdminChart()
        }
        
        self.addRefreshController()
        self.setUpdata()
        
        if(APP_Delegate().isAdmin){
            
            // To hide the tab bar and tab bar center button
            self.navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = true
            if let arrOfviews = tabBarController?.view.subviews{
                for view in arrOfviews{
                    if view.isKind(of: UIButton.self) {
                        view.isHidden = true
                    }
                }
            }
            
            self.navigationItem.rightBarButtonItem = nil;

        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
         APP_Delegate().currentChatUser = ""
        firBaseMsgRefresh?.removeObserver(withHandle: msgAddedHandler!)
        meStatus?.removeObserver(withHandle: meStatusHandler!)
      //  myUnReadMessPath?.removeAllObservers()
        postUnreadCount?.removeObserver(withHandle: postUnreadCountHandler!)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
 
    func setUpdata(){
        
        if(APP_Delegate().isAdmin){

            bgVwOFMess_H.constant = 0
            self.containerVw_H.constant = (UIApplication.shared.keyWindow?.bounds.size.height)! - 20 - (navigationController?.navigationBar.bounds.size.height)! // 134 = 114 + 20
            
        }else{
            

           // self.ChatView_H.constant = typeOfHelpReq == "MY_CHAT" ? (self.MYchatHomeDataModel.pst_completed == "Yes" ? 0 : 50) : (self.chatHomeDataModel.pst_completed == "Yes" ? 0 : 50)
            //self.ChatView_H.constant = pst_completed == "Yes" ? 0 : 50
            self.ChatView_H.constant = 50
            self.lbl_CatNm.text = String(format: "For: %@", (pst_title?.capitalizingFirstLetter())!)
            self.lbl_Msg.text = typeOfHelpReq == "MY_CHAT" ? "Chat with the user, and see if they can help you. once you've been helped, or you no longer required help, end the request." : "This is where you chat with the user, learn more about how best to help them, and provide a helping hand!."
                self.containerVw_H.constant = (UIApplication.shared.keyWindow?.bounds.size.height)! - 134 - (navigationController?.navigationBar.bounds.size.height)! // 134 = 114 + 20
        }
        
        
        self.navigationItem.title = personNm.capitalizingFirstLetter()
        self.registorKeyboardNotification()
    }
    

    
    @IBAction func openDropDownBtnAction(_ sender: Any) {
        openDropDownMenu()
    }
    
    
    //========================================================
    //MARK:- Open DropDownMenu Of User Post
    //========================================================
    
    func openDropDownMenu(){
        
        //let userId = getUserData()["usr_id"] as! String
       // let responseid = countryListObj?.usr_id!
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
 
        
        let post_Id  = self.countryListObj != nil ? self.countryListObj?.usr_id : (self.typeOfHelpReq == "MY_CHAT" ? self.MYchatHomeDataModel.pst_usr_id : self.chatHomeDataModel.pst_usr_id)

        
        
        if post_Id != getUserData()["usr_id"] as? String{
          
            alert.addAction(UIAlertAction(title: "Report", style: .destructive) { action in
                
                let repostStatus  = self.countryListObj != nil ? self.countryListObj?.usr_report : (self.typeOfHelpReq == "MY_CHAT" ? self.MYchatHomeDataModel.usr_report : self.chatHomeDataModel.usr_report)
                
                if(repostStatus == "YES"){
                    ShowAlert(title: "", message: "You have already reported this post.", controller: self, cancelButton: "Ok", okButton: nil, style: .alert, callback: { (isOk, isCancel) in})
                    return
                }
                
                let reportView = UINib(nibName: "ReportView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ReportView
                reportView.frame = UIScreen.main.bounds
                
                 reportView.isChatScreen = true
                
                if (self.countryListObj != nil){
                    
                    reportView.getReportList(controller: self, countryList: self.countryListObj! )
                }else{
                    reportView.getReportListAtChat(controller: self, nsObj: (self.typeOfHelpReq == "MY_CHAT" ? self.MYchatHomeDataModel : self.chatHomeDataModel) , type: self.typeOfHelpReq)
                    
                }
                
                reportView.type = "CHAT"
                reportView.id = self.countryListObj != nil ? self.countryListObj?.pst_id :  self.typeOfHelpReq == "MY_CHAT" ? self.MYchatHomeDataModel.pst_id : self.chatHomeDataModel.pst_id
                self.tabBarController?.view.addSubview(reportView)
                reportView.containerVw.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                reportView.bgView.alpha = 0.0 ;
                UIView.animate(withDuration: 0.1,
                               delay: 0.0,
                               options: UIViewAnimationOptions.curveEaseIn,
                               animations: { () -> Void in
                                reportView.bgView.alpha = 0.4
                                reportView.containerVw.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { (finished) -> Void in
                })
            })

        }
        



    if(post_Id == getUserData()["usr_id"] as? String && self.MYchatHomeDataModel.pst_completed != "Yes"){
        
        alert.addAction(UIAlertAction(title: "End Request", style: .default) { action in
              self.endHelpReqAction()
           })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
        })
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    func endHelpReqAction (){
        
        
        DispatchQueue.main.async {
            self.helpedUsrLstVw = HelpedUserListView.instanceFromNib() as! HelpedUserListView;
            self.helpedUsrLstVw.frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width), height: UIScreen.main.bounds.height)
            self.showHelpedUserListViewWithAnimation(view: self.helpedUsrLstVw )
           
            self.helpedUsrLstVw.getAllHelpRequestedUser(controller: self, pst_Id:
                self.countryListObj != nil ? (self.countryListObj?.pst_id)! : (self.typeOfHelpReq == "MY_CHAT" ? self.MYchatHomeDataModel.pst_id! : self.chatHomeDataModel.pst_id!), callBack: {[weak self]  (isSuccess:Bool , message : String)  in
                
                guard let weekSelf = self else { return }
                
                if(isSuccess){ // is Success at user is in user list
                    windowController().view.addSubview(weekSelf.helpedUsrLstVw)
                    weekSelf.helpedUsrLstVw.layoutIfNeeded()
                }else{
                    
                    if(message == "Oops! There is no data to display."){
                        
                        weekSelf.endHelpRequest(pst_Id: weekSelf.countryListObj != nil ? (weekSelf.countryListObj?.pst_id)! : (weekSelf.MYchatHomeDataModel.pst_id!), postTtl: self?.countryListObj != nil ? (weekSelf.countryListObj?.pst_title)! : weekSelf.MYchatHomeDataModel.pst_title!, arrOfID: ["NO_ID"]  )
                        
                        
                    }else{
                        //sender.isUserInteractionEnabled = true
                        ShowError(message: message  , controller: self!)
                    }
                    
                }
            })
            
            
            self.helpedUsrLstVw.onHideComplete = {(isSuccess : Bool , arrOfSltId : [Any]) -> Void in
                if(isSuccess){ // isSuccess End Req Btn Clicked
                    
                    self.endHelpRequest(pst_Id: self.countryListObj != nil ? (self.countryListObj?.pst_id)! : (self.MYchatHomeDataModel.pst_id!), postTtl: self.countryListObj != nil ? (self.countryListObj?.pst_title)! : self.MYchatHomeDataModel.pst_title!, arrOfID: arrOfSltId  )


                    
                  //  self.endHelpRequest(pst_Id: self.MYchatHomeDataModel.pst_id!, postTtl: self.MYchatHomeDataModel.pst_title! , arrOfID: arrOfSltId )
                }else{
                    
                   // sender.isUserInteractionEnabled = true
                    
                }
            }
        }
    }
    
    func showHelpedUserListViewWithAnimation(view : HelpedUserListView){
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
    
    func showAlertForHelpReqComplete(){
        DispatchQueue.main.async {
            
            self.endReqAlert = EndReqAlert.instanceFromNib() as! EndReqAlert;
            self.endReqAlert.HowKMPointsWorksCallBack = {(isSuccess : Bool) -> Void in
                if(isSuccess){
                    let whatsKMVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WHATSKMVC") as! WhatsKMVC
                    
                    self.navigationController?.pushViewController(whatsKMVC, animated: true)
                }
            }
            
            self.endReqAlert.frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width), height: UIScreen.main.bounds.height)
            self.showEndReqViewWithAnimation(view: self.endReqAlert )
            windowController().view.addSubview(self.endReqAlert)
            self.endReqAlert.layoutIfNeeded()
            
        }
    }
    
    func showEndReqViewWithAnimation(view : EndReqAlert){
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
    //========================================================
    // MARK:- Call SerVice For End Help REq
    //========================================================
    /*
     1.usrToken->user token
     2.usrIdFrm->array(1,2)
     3.pstId->Post Id
     4.pstTtl->Post title
     */
    func endHelpRequest(pst_Id: String , postTtl : String, arrOfID: [Any]){
        showLoader(view: self.view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "usrIdFrm" :  arrOfID,
                                 "pstId" : pst_Id,
                                 "pstTtl" : postTtl]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.endHelpRequest , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
               // btn.isUserInteractionEnabled = true
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                
                return
            }
            
            DispatchQueue.main.async {
                btnClickEvent(caregoryNm: "Help Request", action: "End Help Request", label: "")
                killLoader()
                weakSelf.showAlertForHelpReqComplete()
                weakSelf.MYchatHomeDataModel.pst_completed = "Yes"
                weakSelf.countryListObj?.pst_completed = "Yes"
               // weakSelf.btnEnd_H.constant = 0
            }
            
        })
        
    }
    
    
    func initilizeFirebase(){
        
        if(APP_Delegate().isAdmin){
            
           chatNode =  String(format: "admin/admin_userId_%@", getUserData()["usr_id"] as! String)
            
        }else{
            if(pstCreater_Id == getUserData()["usr_id"] as! String){
                chatNode = String(format: "user-help-request-chat/%@_%@_%@", getUserData()["usr_id"] as! String,otherUser_id!,hlp_pst_id!)
            }else{
                chatNode = String(format: "user-help-request-chat/%@_%@_%@",otherUser_id!, getUserData()["usr_id"] as! String,hlp_pst_id!)
            }
        }
    
        firBaseMsgRefresh = Database.database().reference(withPath:String(format: "/%@/message",chatNode!))
        
    //MARK:- -------add mess By Me ------
        msgAddedHandler = firBaseMsgRefresh?.queryOrderedByKey().queryLimited(toLast: 15).observe(.childAdded, with: { (snapshot : DataSnapshot) in
            
            if(snapshot.value != nil){
                
               // print(snapshot)
               // print(snapshot.value ?? "")
               // print(snapshot.children)
                let chatScreenDM = ChatScreenDM.init(snapshot: snapshot)
                let strDate = dayDifference(dateString: chatScreenDM.timestamp!)
                
                if(self.arryChat.count > 0){
                    
                    
                    if let index = (self.arryChat.index { (dict) -> Bool in dict[strDate] != nil }){
                        print("Key Found at = \(index) ")
                        self.arrOfShowData.append(ChatScreenDM.init(snapshot: snapshot))
                        var dictObj = self.arryChat[index]
                        dictObj[strDate] = self.arrOfShowData
                        self.arryChat.remove(at: index) //["barbecue", "pancake", "frog"]
                        self.arryChat.append(dictObj)
                    } else {
                        print("the key 'someKey' is NOT in the dictionary")
                        self.arrOfShowData.removeAll()
                        self.dictOfData.removeAll()
                        self.arrOfShowData.append(ChatScreenDM.init(snapshot: snapshot))
                        self.dictOfData[strDate] = self.arrOfShowData
                        self.arryChat.append(self.dictOfData)
                    }
                    
                }else{
                    
                    self.arrOfShowData.append(ChatScreenDM.init(snapshot: snapshot))
                    
                    self.dictOfData[strDate] = self.arrOfShowData
                    self.arryChat.append(self.dictOfData)
                    // print(self.arryChat)
                }
                
                
                // notify table view to reload
                DispatchQueue.main.async {
                    self.table_View.reloadData()
                    self.moveToLastIndex()
                }
            }
        })
//MARK:- -------Get other Unread count (total unread Mess of other send by me) ------
        
        
        meStatus = Database.database().reference(withPath: String(format: "/%@/status/user_id_%@/",chatNode!, getUserData()["usr_id"] as! String))
        meStatusHandler = meStatus?.observe(.childChanged, with: { (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            if(snapshot.key == "unread"){
                self.otherUnreadCount = snapshot.value as! Int
            }
        })
    
        meStatus?.observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            let snapValue = snapshot.value as? [String : Any]

            if(snapValue?["unread"] != nil){
                self.otherUnreadCount = snapValue?["unread"]as! Int
                DispatchQueue.main.async {
                    //self.table_View.reloadData()
                }
            }
        })
        
        
//MARK:--------------------My Unread Count(mess send by other)-------------------

        if(APP_Delegate().isAdmin){
                  myUnReadMessPath = Database.database().reference(withPath: String(format: "/%@/status/admin/",chatNode!))
        } else{
                  myUnReadMessPath = Database.database().reference(withPath: String(format: "/%@/status/user_id_%@/",chatNode!, otherUser_id))
        }
   
         myUnReadMessPath?.observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            let snapValue = snapshot.value as? [String : Any]
            
            if(snapValue?["unread"] != nil){
                self.muUnreadMsgCount = snapValue?["unread"]as! Int
            }
        })
        

        if(APP_Delegate().isAdmin){
            print("if admin")
        }else{
        //MARK:- ------------------Post unread count -----------------
        
        postUnreadCount = Database.database().reference(withPath: String(format: "/PostUnReadCount/postUnread_%@/",hlp_pst_id!))
        
        postUnreadCountHandler = postUnreadCount?.observe(.childChanged, with: { (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            if(snapshot.key == "postunread"){
                //print(snapshot.value as! Int)
                self.postUnreadMsgCount = snapshot.value as! Int
            }
            
        })
        
        postUnreadCount?.observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            let snapValue = snapshot.value as? [String : Any]
            
            if(snapValue?["postunread"] != nil){
                self.postUnreadMsgCount = snapValue?["postunread"]as! Int

                DispatchQueue.main.async {
                    self.table_View.reloadData()
                }
            }
        })
      }
   
    }
    
    
    
   func loadMoreMessages(){
    
    let loadMore = Database.database().reference(withPath:String(format: "/%@/message",chatNode!))
    let dict = self.arryChat[0]
    print(dict)
    let firstKey = Array(dict.keys)[0] // or .first
     print(firstKey)
    let arr = dict[firstKey]
    print(arr ?? [])
    let chatscreenDM = arr?.last
    
    loadMore.queryOrderedByKey().queryEnding(atValue: chatscreenDM?.snapShotKey).queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in

              print(snapshot)
              print(snapshot.value ?? "")
              print(snapshot.children)


                if(snapshot.value != nil){
                    var arry  = [Any]()
                    for  snap  in snapshot.children{
                            arry.append(snap)
                    }
                  
                    self.isMoreData = arry.count < 20 ? false : true
                    
                    let arr =  arry.reversed()
                    for snap in arr{
                        
                        let chatScreenDM = ChatScreenDM.init(snapshot: snap as! DataSnapshot)
                        let strDate = dayDifference(dateString: chatScreenDM.timestamp!)
                        
                        if(self.arryChat.count > 0){
                            
                            
                            if let index = (self.arryChat.index { (dict) -> Bool in dict[strDate] != nil }){
                                print("Key Found at = \(index) ")
                                self.arrOfShowData.insert(ChatScreenDM.init(snapshot: snap as! DataSnapshot), at: 0)
                                
                                print(self.arrOfShowData)
                                var dictObj = self.arryChat[index]
                                print(dictObj)
                                print( dictObj[strDate] ?? "")
                                dictObj[strDate] = self.arrOfShowData
                                print( dictObj[strDate] ?? "")

                                self.arryChat.remove(at: index) //["barbecue", "pancake", "frog"]
                                self.arryChat.insert(dictObj, at: 0)

                            } else {
                                print("the key 'someKey' is NOT in the dictionary")
                                self.arrOfShowData.removeAll()
                                self.dictOfData.removeAll()
                                self.arrOfShowData.append(ChatScreenDM.init(snapshot: snap as! DataSnapshot))
                                self.dictOfData[strDate] = self.arrOfShowData
                                self.arryChat.insert(self.dictOfData, at: 0)
                            }
                            
                        }else{
                            self.arrOfShowData.append(ChatScreenDM.init(snapshot: snapshot))
                            
                            self.dictOfData[strDate] = self.arrOfShowData
                            self.arryChat.append(self.dictOfData)
                        }
                    }
                  
                    // notify table view to reload
                    DispatchQueue.main.async {
                        self.isLoading = false;
                        self.removeRefreshLoader()
                        self.table_View.reloadData()
                    }
                }
            })
    }
    
//================================
//MARK:-  Add Refresh Controller
//================================
    
    func addRefreshController(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(pullToDownRefresh), for: UIControlEvents.valueChanged)
        self.table_View.addSubview(refreshControl)
    }
  
    func pullToDownRefresh() -> Void {
        self.arrOfShowData.removeAll()
        self.dictOfData.removeAll()
        if(!isLoading && isMoreData && self.arryChat.count > 0 ){
            isLoading=true;
            self.loadMoreMessages()
        }else{
            self.showToastForMoreData(message: "No more data", width: 150)
            removeRefreshLoader()
        }
    }
    
    func removeRefreshLoader(){
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }

//=====================================
//MARK:- Registor Keyboard Notification
//=====================================
    func registorKeyboardNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    }
    
    //========================================================
    //MARK:- Text View Delegate Methods
    //========================================================
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //scroll_View.isScrollEnabled = true
        textView.returnKeyType = UIReturnKeyType.next
     
        return true;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(chat_txtView.text == "Write a message..." || textView.textColor == UIColor.lightGray){
            
            chat_txtView.text = ""
            chat_txtView.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            chat_txtView.resignFirstResponder()
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "" || textView.textColor == UIColor.lightGray){
            
            chat_txtView.textColor = UIColor.lightGray
            chat_txtView.text = "Write a message..."
        }else{
            
            chat_txtView.textColor = UIColor.black

        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        if(chat_txtView.text.characters.count == 0){
            
            chat_txtView.textColor = UIColor.lightGray
            chat_txtView.text = "Write a message..."
            chat_txtView.resignFirstResponder()
        }
    }
    
    
//========================================
//MARK:-  Key Board notification method
//========================================
    func keyboardWillShow(notification: NSNotification) {
        
        self.moveView(userInfo: notification.userInfo as! [String : Any], up: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {

        self.moveView(userInfo: notification.userInfo as! [String : Any], up: false)
    }
    
    func moveView(userInfo : [String : Any] , up : Bool){
        
        if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            let y = (-keyboardSize.height * (up ? -1 : 1))
            
            var containerFrame = self.view.frame;
            containerFrame.size.height -= ((APP_Delegate().isAdmin ? 20 : 134) + (navigationController?.navigationBar.bounds.size.height)!);
            
            if(up){
               containerFrame.size.height = containerFrame.size.height - y
            
            
            var tableFrame = self.table_View.frame
            var chatViewFrame = self.chat_view.frame
            
            tableFrame.size.height = containerFrame.size.height-chatViewFrame.size.height;
            chatViewFrame.origin.y = containerFrame.size.height-chatViewFrame.size.height;
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 0.1,
                               delay: 0.0,
                               options: UIViewAnimationOptions.curveEaseIn,
                               animations: { () -> Void in
                                
                                self.containerVw_H.constant = containerFrame.size.height
                            
                }, completion: { (finished) -> Void in
                  
                    DispatchQueue.main.async {
                        if(up){
                            
                           
                            self.moveToLastIndex()
                           
                        }
                    }
                })
             }
            }else{
                
                self.containerVw_H.constant = (UIApplication.shared.keyWindow?.bounds.size.height)! - (APP_Delegate().isAdmin ? 20 : 134) - (navigationController?.navigationBar.bounds.size.height)! // 134 = 114 + 20

                
            }
        
        }
    }
    
    func moveToLastIndex(){
        
        if arryChat.count == 0 {
            return
        }
        if(self.table_View!.numberOfSections > 0){
        // First figure out how many sections there are
        let lastSectionIndex = self.table_View!.numberOfSections - 1
        
        // Then grab the number of rows in the last section
        let lastRowIndex = self.table_View!.numberOfRows(inSection: lastSectionIndex) - 1
        
        // Now just construct the index path
        let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        // Make the last row visible
        self.table_View?.scrollToRow(at: pathToLastRow, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    
    
//=====================================
//MARK:-  Table View Delegate Method
//=====================================

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arryChat.count
    }
    
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
         headerView.frame = CGRect(x: 0, y: 0, width: Int(self.table_View.frame.size.width), height: 20)

        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width:
            headerView.bounds.size.width, height: headerView.bounds.size.height))
        headerLabel.font = UIFont(name: "LucidaSans", size: 10)
        headerLabel.textColor = UIColor.darkGray
        
        let dict = self.arryChat[section]
        //print(dict)
        let firstKey = Array(dict.keys)[0]
        headerLabel.text = firstKey;
    
        
        headerLabel.textAlignment = .center;
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        if(self.arryChat.count != 0){
            
            let dict = self.arryChat[section]
            //print(dict)
            let firstKey = Array(dict.keys)[0] // or .first
            //print(firstKey)
            let arr = dict[firstKey]
            //print(arr ?? [])
            return arr!.count
            
        }else{
            return arryChat.count

        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ChatScreenCell"
        var cell: ChatScreenCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatScreenCell
        if cell == nil {
            tableView.register(UINib(nibName: "ChatScreenCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatScreenCell
        }
        
        
        let dict = self.arryChat[indexPath.section]
        //print(dict)
        let firstKey = Array(dict.keys)[0] // or .first
       // print(firstKey)
        let arr = dict[firstKey]
        //print(arr ?? [])
        
        
         let chatscreenDM = arr?[indexPath.row]
        
    // ------------- Unread Count Of other user mess---------------
        if(APP_Delegate().isAdmin){
            myUnReadMessPath?.updateChildValues(["unread" : 0 ])
            self.muUnreadMsgCount = 0;
            self.postUnreadMsgCount = 0;
        }else{
            
            if(pstCreater_Id != getUserData()["usr_id"] as? String){
                
                //if(self.muUnreadMsgCount != 0){
                myUnReadMessPath?.updateChildValues(["unread" : 0 ])
                self.muUnreadMsgCount = 0;
                //}
                
            }else {
                
                if(self.muUnreadMsgCount != 0 && self.postUnreadMsgCount != 0){
                    //set My Undera mess count 0 after see the mess
                    self.postUnreadCount?.updateChildValues(["postunread" : (self.postUnreadMsgCount - self.muUnreadMsgCount)])
                    myUnReadMessPath?.updateChildValues(["unread" : 0 ])
                    self.muUnreadMsgCount = 0;
                    self.postUnreadMsgCount = 0;
                    
                }else{// both user on same chat screen then unread count is 0
                    if(self.muUnreadMsgCount == 0 && self.postUnreadMsgCount == 0){
                        self.postUnreadCount?.updateChildValues(["postunread" : 0])
                        myUnReadMessPath?.updateChildValues(["unread" : 0 ])
                        self.muUnreadMsgCount = 0;
                        self.postUnreadMsgCount = 0;
                        
                    }
                }
            }
        }
    
        
  
           cell.lbl_Mess.text = (chatscreenDM as AnyObject).message
           cell.lbl_Date.text  = dateWithComparisonDate(strDate: ((chatscreenDM as AnyObject).timestamp as? String)!)
           let messageSize = (cell.lbl_Mess.text?.boundingRect(with: CGSize(width: cell.frame.size.width , height: cell.frame.size.height), options: [.usesLineFragmentOrigin , .usesFontLeading], attributes: [NSFontAttributeName: Font.LucidaSans(fontSize: 16.0) as Any], context: nil).size)!
        
        let lbl_W = cell.lbl_Mess.intrinsicContentSize.width

        
        if(chatscreenDM?.sender == getUserData()["usr_id"] as? String){
            
            cell.lbl_Date.textAlignment = NSTextAlignment.right
            cell.bg_VwOfMess.backgroundColor = theamColor(red: 54, green: 181, blue: 185)
            cell.lbl_Mess.textColor = UIColor.white

            let x = cell.bounds.size.width  - (10 + messageSize.width + 20 ) // 10 is leading dis of bg_VwOfMess
            
                if(170 < x){
                     cell.bg_VwOfMess_T.constant = 10
                     cell.bgView_W.constant = messageSize.width + 20
                     cell.lbl_Mess.textAlignment = NSTextAlignment.center

                }else{
                      cell.bgView_W.constant = 170
                      cell.bg_VwOfMess_T.constant = 10
                      cell.lbl_Mess.textAlignment = NSTextAlignment.left
                }
          
        }else{

            cell.lbl_Date.textAlignment = NSTextAlignment.left
            cell.bg_VwOfMess.backgroundColor = theamColor(red: 234, green: 234, blue: 234)
            cell.lbl_Mess.textColor =  UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)

            let t = cell.bounds.size.width  - (10 + messageSize.width + 20) // 10 is leading dis of bg_VwOfMess
            if(170 < t){
                cell.bgView_W.constant = messageSize.width + 20
                cell.bg_VwOfMess_T.constant = UIScreen.main.bounds.width - 10 - messageSize.width - 20
                cell.bg_VwOfMess_X.constant = 10
                cell.lbl_Mess.textAlignment = NSTextAlignment.center
            }else{
                
                cell.bgView_W.constant = 170
                cell.bg_VwOfMess_T.constant = UIScreen.main.bounds.width - (cell.bgView_W.constant + 10)//10 is leading dis  & 20 is a top and bouttom dis of bg_VwOfMess
                
                cell.bg_VwOfMess_X.constant = 10

                cell.lbl_Mess.textAlignment = NSTextAlignment.left
            }
        }
        cell.lbl_Mess.layoutIfNeeded()
        cell.lbl_Mess.setNeedsDisplay()
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 3000
    }
    
    
    func getTimeFromMessageDate(date : String) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yourDate = formatter.date(from: date)
        
        let date = yourDate
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date!)
        let hour = components.hour
        let minute = components.minute
       
        
        let today_string =   String(hour!) + String(minute!)
        return today_string
 
        
    }
 
    @IBAction func sendMessageAction(_ sender: Any) {
        
        
        let trimmedString = chat_txtView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(trimmedString! == "" || trimmedString == "Write a message..."){
            
            return
        }

        
        btnClickEvent(caregoryNm: "Chat", action: "Send message", label: "")

       // self.arryChat.removeAll()

        
        let dict : [String : Any] = ["receipt" : 0 ,"sender" : getUserData()["usr_id"] as! String ,"message" : chat_txtView.text ,"timestamp" : convertDateForFirebaseInUTC(date : Date()) ,"firstname" : getUserData()["usr_fname"] as! String ,"lastname" : getUserData()["usr_lname"] as! String ]
        
        
        
        firBaseMsgRefresh?.childByAutoId().setValue(dict)
    
        otherUnreadCount = otherUnreadCount+1
        meStatus?.updateChildValues(["unread" : (otherUnreadCount)])
    
        if(pstCreater_Id != getUserData()["usr_id"] as? String){
            postUnreadMsgCount = postUnreadMsgCount + 1
            postUnreadCount?.updateChildValues(["postunread" : postUnreadMsgCount])
        }
       
        chat_txtView.text = ""
        
        DispatchQueue.main.async {
           self.moveToLastIndex()
        }
        
    }

    
    
    
}//END
