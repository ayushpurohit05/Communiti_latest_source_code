
//
//  ChatMyAndOthrHelpReqVC.swift
//  Community
//
//  Created by Hatshit on 15/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import Firebase


class ChatMyAndOthrHelpReqVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate{
    
    @IBOutlet weak var lbl_Alert: UILabel!
    @IBOutlet weak var lbl_CatNm: UILabel!
    @IBOutlet weak var lbl_Mess: UILabel!
    @IBOutlet weak var btnEnd_H: NSLayoutConstraint!
    @IBOutlet weak var table_View: UITableView!
    var typeOfHelpReq : String!
   // var pst_Id : String!
    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    var arrOfShowData = [ChatMyAndOthrHelpReqDM]()
     var selectedModel : ChatMyAndOthrHelpReqDM!
    var pageCount = 1
   // var chatUserCount : String!
    var endReqAlert = EndReqAlert()
    var helpedUsrLstVw = HelpedUserListView()
    var chatHomeDataModel : ChatHomeDM!
    var MYchatHomeDataModel : MYChatHomeDM!
    
    var chatNode : String?
    var firBaseMsgRefresh : DatabaseReference?
    var gerLastMessHandler : DatabaseHandle?
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
          self.setUpData()
        }
         self.getHelpReqUserList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            self.getHelpReqUserList()
//        }
        
        if(typeOfHelpReq == "MY_CHAT"  && MYchatHomeDataModel.pst_completed == "No"){
           
            let diffOfDate = MYchatHomeDataModel.pext_date == nil ? "Same" :   datedifference(timeInterval: MYchatHomeDataModel.pext_date!, timeZone: "")
            
            if diffOfDate == "Small" || self.MYchatHomeDataModel.pst_completed == "Expired"{
                 self.btnEnd_H.constant = 0
            }else if (MYchatHomeDataModel.pst_completed == "Yes"){
                 self.btnEnd_H.constant = 0
            }else if(diffOfDate == "Same"){
                self.btnEnd_H.constant = 30
            }else{
                self.btnEnd_H.constant = 30
            }
         }else{
            self.btnEnd_H.constant = 0
        }
        
        
        if selectedModel != nil{
            if (MYchatHomeDataModel != nil){
                selectedModel.chat_report = MYchatHomeDataModel.chat_report
            }else if(chatHomeDataModel != nil){
                selectedModel.chat_report = chatHomeDataModel.chat_report
            }
        }
        
        table_View.reloadData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        
       /* for (_, obj) in self.arrOfShowData.enumerated(){
            obj.removeObservernotyOfChatIndividualPostDM()
        }
        
        self.arrOfShowData.removeAll()*/
        
    }
    
//================================
//MARK:-  Set Up Btn Action
//================================
    func setUpData(){
        
        // to hide the tab bar and tab bar center button and show navigation bar
        self.navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        let arrOfviews = tabBarController?.view.subviews
        for view in arrOfviews!{
            if view.isKind(of: UIButton.self) {
                view.isHidden = true
            }
        }
        
        self.lbl_Alert.isHidden = true
        self.lbl_Alert.text = typeOfHelpReq == "MY_CHAT" ? "This is where you’ll find chats with the people who want to help you. \n\n Currently you don’t have anyone who wants to help you with your request. \n\n Give it some time, else you can always create a new request again." : "This is where you’ll find chats with the people YOU want to help. \n\n Currently you haven’t volunteered to help anyone on Communiti. \n\n Just go to the Help and start looking for people who need assistance."
        let strPstTittle = typeOfHelpReq == "MY_CHAT" ? MYchatHomeDataModel.pst_title : chatHomeDataModel.pst_title
        self.lbl_CatNm.text = String(format: "For: %@", (strPstTittle?.capitalizingFirstLetter())!)
        self.lbl_Mess.text = typeOfHelpReq == "MY_CHAT" ? "Chat with these users, and see if they can help you. once you've been helped, or you no longer required help, end the request." : "Chat with these users, learn more about how best to help them, and provide a helping hand."
        
        self.navigationItem.title = typeOfHelpReq == "MY_CHAT" ? "MY HELP REQUEST" : "OTHER HELP REQUEST"
        
//        if(typeOfHelpReq == "MY_CHAT"  && MYchatHomeDataModel.pst_completed == "No"){
//             self.btnEnd_H.constant = 30
//        }else{
//             self.btnEnd_H.constant = 0
//        }
        
        
       // self.getHelpReqUserList()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func endBtnActionMethod(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        self.endHelpReqAction(sender: sender)
    }
    
//================================
//MARK:-  Add Refresh Controller
//================================
    
    func addRefreshController(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(pullToDownRefresh), for: UIControlEvents.valueChanged)
        
        
//        pullUpRefeshControl.triggerVerticalOffset = 100;
//        pullUpRefeshControl.addTarget(self, action: #selector(pullUpRefreshMethod), for: UIControlEvents.valueChanged)
//        self.table_View.bottomRefreshControl = pullUpRefeshControl;
//        self.table_View.addSubview(refreshControl)
        // not required when using UITableViewController
    }
    
    func pullToDownRefresh() -> Void {
        self.pageCount = 1
        self.getHelpReqUserList()
    
    }
    
    func pullUpRefreshMethod(){
        pageCount = pageCount + 1
        if( self.arrOfShowData.count <= Int(typeOfHelpReq == "MY_CHAT" ?MYchatHomeDataModel.chat_count! : chatHomeDataModel.chat_count!)!){
                self.getHelpReqUserList()
        }
    }
    
    func removeRefreshLoader(){
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
//            if self.pullUpRefeshControl.isRefreshing {
//                self.pullUpRefeshControl.endRefreshing()
//            }
        }
      
    }

//=====================================
//MARK:-  Table View Delegate Method
//=====================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOfShowData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ChatIndividualHelpResCell"
        var cell: ChatIndividualHelpResCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatIndividualHelpResCell
        if cell == nil {
            tableView.register(UINib(nibName: "ChatIndividualHelpResCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatIndividualHelpResCell
        }
        cell.bgViewOfImg.layer.borderColor = UIColor.lightGray.cgColor

        
        let chatIndividualHelpResDM = arrOfShowData[indexPath.row]
        cell.lbl_Nm.text = chatIndividualHelpResDM.usr_fname
       // cell.lbl_Mess.text = chatIndividualHelpResDM.usr_fname
        
        if(chatIndividualHelpResDM.profile_image != ""){
            saveImgIntoCach(strImg: chatIndividualHelpResDM.profile_image!, imageView: cell.img_View)
        }else{
            cell.img_View.image =  UIImage(named: "user")
            
        }
        
        if(chatIndividualHelpResDM.senderId == getUserData()["usr_id"] as? String){
            cell.imgViewSend_W.constant = 9

        }else{
            cell.imgViewSend_W.constant = 0
        }
     
        if(chatIndividualHelpResDM.isUnreadMess){
           
            cell.backgroundColor = UIColor(red: 235/255, green: 248/255, blue: 248/255, alpha: 1)
            cell.bgViewOfImg.backgroundColor =  UIColor(red: 235/255, green: 248/255, blue: 248/255, alpha: 1)


        }else{
            
            cell.backgroundColor = UIColor.white
            cell.bgViewOfImg.backgroundColor = UIColor.white
        }
        
        cell.lbl_Mess.text = chatIndividualHelpResDM.userMess

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let chatScreenVC = storyboard?.instantiateViewController(withIdentifier: "ChatScreenVC") as! ChatScreenVC
        
        let chatModel = arrOfShowData[indexPath.row]
         selectedModel = chatModel
        chatModel.isUnreadMess = false
        
        chatScreenVC.personNm =  chatModel.usr_fname!
        chatScreenVC.otherUser_id =  chatModel.usr_id!
        chatScreenVC.hlp_pst_id = typeOfHelpReq == "MY_CHAT" ? MYchatHomeDataModel.pst_id :chatHomeDataModel.pst_id
        chatScreenVC.pstCreater_Id = typeOfHelpReq == "MY_CHAT" ? MYchatHomeDataModel.pst_usr_id :chatHomeDataModel.pst_usr_id
        chatScreenVC.pst_completed = typeOfHelpReq == "MY_CHAT" ? MYchatHomeDataModel.pst_completed :chatHomeDataModel.pst_completed
        chatScreenVC.pst_title = typeOfHelpReq == "MY_CHAT" ? MYchatHomeDataModel.pst_title :chatHomeDataModel.pst_title
        chatScreenVC.typeOfHelpReq = typeOfHelpReq
        chatScreenVC.chatHomeDataModel = chatHomeDataModel
        chatScreenVC.MYchatHomeDataModel = MYchatHomeDataModel
        
        if chatHomeDataModel != nil {
             chatScreenVC.chatHomeDataModel.chat_report = chatModel.chat_report != nil ? chatModel.chat_report! : ""
        }else{
             chatScreenVC.MYchatHomeDataModel.chat_report = chatModel.chat_report != nil ? chatModel.chat_report! : ""
        }
        navigationController?.pushViewController(chatScreenVC, animated: true)
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 3000
    }
    

    
//========================================================
// MARK:- Call SerVice For Get OtherHelp Req List
//========================================================
    
    /*
     1.usrToken->user token
     2.pstId->Post id
     3.filter->filter
     4.limit->limit
     5.page->page
     */
    func getHelpReqUserList(){
        
        showLoader(view: self.view)// show loader
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"]!,
                                 "pstId" : typeOfHelpReq == "MY_CHAT" ? MYchatHomeDataModel.pst_id : chatHomeDataModel.pst_id,
                                 "filter" : typeOfHelpReq,
                                 "limit" : "100",
                                 "page" : self.arrOfShowData.count]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.getHelpReqUserListAtChat , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                    if(isError){
                        
                        if((response as! [String : Any])["success"] as! Bool == false){
                            if((response as! [String : Any])["message"] as! String == "Deactive" ){
                                DispatchQueue.main.async {
                                    APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as! String,controller: self!)
                                   
                                }
                                 return
                            }
                        }
                        
                        
                        
                        weakSelf.lbl_Alert.isHidden = true
                        ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                    }else{
                        if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                            DispatchQueue.main.async {
                                moveforLoginWhenSeccionExpire(controller: self!)
                            }
                        }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                            DispatchQueue.main.async {
                                APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                                
                            }
                            return
                        }else{
                            DispatchQueue.main.async {
                                
                                if self?.arrOfShowData.count == 0{
                                     weakSelf.lbl_Alert.isHidden = false
                                }
                            
                            }
                        }
                     }
                return
            }
            DispatchQueue.main.async {
                killLoader()
                // Remove Refresh Controller
                weakSelf.removeRefreshLoader()
                weakSelf.lbl_Alert.isHidden = true
                
               // print(response)
                
                if(weakSelf.pageCount == 1){
                    weakSelf.arrOfShowData.removeAll()
                }

               let array  = (response as! [String : Any])["data"] as! [[String : Any]]
               let creater_Id = weakSelf.typeOfHelpReq == "MY_CHAT" ? weakSelf.MYchatHomeDataModel.pst_usr_id: weakSelf.chatHomeDataModel.pst_usr_id!
               let post_id = weakSelf.typeOfHelpReq == "MY_CHAT" ? weakSelf.MYchatHomeDataModel.pst_id: weakSelf.chatHomeDataModel.pst_id
                
                for (idx, obj) in array.enumerated(){
                    
                    weakSelf.arrOfShowData.append(ChatMyAndOthrHelpReqDM.init(dic: obj, pstCreater_Id: creater_Id!, hlp_pst_id: post_id!))
                    weakSelf.arrOfShowData[idx].callbackFromChatIndiVidualDM = {(isSuccess : Bool) -> Void in
            
                        DispatchQueue.main.async {
                            weakSelf.table_View.reloadData()
                        }
                    }
                }
                   weakSelf.table_View.reloadData()
            }
            
        })
        
    }
    
//========================================================
//MARK:- Table view cell button action method(End Req)
//========================================================
     func endHelpReqAction (sender: UIButton){
        
        
        DispatchQueue.main.async {
            self.helpedUsrLstVw = HelpedUserListView.instanceFromNib() as! HelpedUserListView;
            self.helpedUsrLstVw.frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width), height: UIScreen.main.bounds.height)
            self.showHelpedUserListViewWithAnimation(view: self.helpedUsrLstVw )
            self.helpedUsrLstVw.getAllHelpRequestedUser(controller: self, pst_Id: self.typeOfHelpReq == "MY_CHAT" ? self.MYchatHomeDataModel.pst_id! : self.chatHomeDataModel.pst_id!, callBack: {[weak self]  (isSuccess:Bool , message : String)  in
                
                guard let weekSelf = self else { return }
                
                if(isSuccess){ // is Success at user is in user list
                    windowController().view.addSubview(weekSelf.helpedUsrLstVw)
                    weekSelf.helpedUsrLstVw.layoutIfNeeded()
                }else{
                    
                    if(message == "Oops! There is no data to display."){
                        
                        weekSelf.endHelpRequest(pst_Id: weekSelf.MYchatHomeDataModel.pst_id!, postTtl: weekSelf.MYchatHomeDataModel.pst_title!, arrOfID: ["NO_ID"] , btn : sender )
                        
                        
                    }else{
                        sender.isUserInteractionEnabled = true
                        ShowError(message: message  , controller: self!)
                    }
                    
                }
            })
            
            
            self.helpedUsrLstVw.onHideComplete = {(isSuccess : Bool , arrOfSltId : [Any]) -> Void in
                if(isSuccess){ // isSuccess End Req Btn Clicked
                    
                    self.endHelpRequest(pst_Id: self.MYchatHomeDataModel.pst_id!, postTtl: self.MYchatHomeDataModel.pst_title! , arrOfID: arrOfSltId , btn : sender)
                }else{
                    
                    sender.isUserInteractionEnabled = true

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
    func endHelpRequest(pst_Id: String , postTtl : String, arrOfID: [Any] , btn : UIButton){
        showLoader(view: self.view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "usrIdFrm" :  arrOfID,
                                 "pstId" : pst_Id,
                                 "pstTtl" : postTtl]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.endHelpRequest , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                btn.isUserInteractionEnabled = true
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                
                return
            }
            
            DispatchQueue.main.async {
                btnClickEvent(caregoryNm: "Help Request", action: "End Help Request", label: "")
                killLoader()
                weakSelf.showAlertForHelpReqComplete()
                weakSelf.MYchatHomeDataModel.pst_completed = "Yes"
                weakSelf.btnEnd_H.constant = 0
            }
            
            NotificationCentreClass.fireGetTotalKrmPointsUsingNotificationCenter()
            
        })
        
    }

}
