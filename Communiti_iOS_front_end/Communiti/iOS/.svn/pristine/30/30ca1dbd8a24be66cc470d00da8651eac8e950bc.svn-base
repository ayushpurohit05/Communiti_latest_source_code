//
//  ChatHomeVC.swift
//  Community
//
//  Created by Hatshit on 15/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import Firebase



class ChatHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate{
    
    @IBOutlet weak var lbl_Alert: UILabel!
    @IBOutlet weak var bgVwOfMyReq: UIView!
    @IBOutlet weak var bgVwOfOthrReq: UIView!
    @IBOutlet weak var bggVwOfSupports: UIView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var btn_Myreq: UIButton!
    @IBOutlet weak var btn_Supports: UIButton!
    
    @IBOutlet weak var lblSuptCount: UILabel!
    @IBOutlet weak var lblMyHelpCount: UILabel!
    @IBOutlet weak var lblOthrHelpCount: UILabel!
    
    var endReqAlert = EndReqAlert()
    var helpedUsrLstVw = HelpedUserListView()
    var isRefresh = false
    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    var arrOfShowData = [ChatHomeDM]()
    var arrOfMyPostData = [MYChatHomeDM]()
    //var pageCountOfMyReq = 1
    //var pageCountOfOthrReq = 1
    
    var isRemove = false
    
    
    var totalNOOfPst : String!
    var sltBtn : UIButton!
    var isMyPost: Bool = true
    let cellReuseIdentifier = "ChatSupportsCell"
    
    
    var chatNode : String?
    var firBaseMsgRefresh : DatabaseReference?
    var gerLastMessHandler : DatabaseHandle?
    var userUnreadCount : DatabaseReference?
    var userUnreadCountHandler : DatabaseHandle?
    var isUnreadMess : Bool = false
    var userMess : String?

    var adminNm : String!
    var adminImg : String!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //============add Right Navi Btn===============
       self.addButtonsOnRightSideOfNavigationBar()
        
        NotificationCentreClass.registerRemoveArrayOfFeedVCNotifier(vc: self, selector: #selector(self.removeChatArrAtLogOut(_:)))

        lbl_Alert.isHidden = true
        //showLoader(view: self.view)// show loader
        self.addRefreshController()
        
        //================= Suport UnreadCount ==================
        if(APP_Delegate().supportsUnreadCount > 0){
            self.lblSuptCount.isHidden = false
            self.lblSuptCount.text =  String(format: "%d", APP_Delegate().supportsUnreadCount)
         
        }else{
            self.lblSuptCount.text = "0"
            self.lblSuptCount.isHidden = true
        }
     
        
        APP_Delegate().callForChatVCToSowUnreadCount = {(isSuccess : Bool , result : Int) -> Void in
           // print(result)
            if(result > 0){
                self.lblSuptCount.isHidden = false
                self.lblSuptCount.text =  String(format: "%d", result)
                self.tableView.reloadData()
            }else{
                self.lblSuptCount.text = "0"
                self.lblSuptCount.isHidden = true
                self.tableView.reloadData()
            }
        }
        
    // =============================================================
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        DispatchQueue.main.async {
            if(APP_Delegate().isPopForLogin){
                DispatchQueue.main.async {
                    APP_Delegate().tokenExpired(controller: (self.tabBarController as? TabBarController)!)
                }
            }
    
            
            if( APP_Delegate().isAdmin ){
                self.showLastMessForSupports()
                self.sltBtn = self.btn_Supports
                self.changeColorOfSelectedBtn(view: self.bggVwOfSupports)
                self.resetColorOfUnSltBtn(view: self.bgVwOfOthrReq)
                self.resetColorOfUnSltBtn(view: self.bgVwOfMyReq)
               // self.getAdminDetail()
                //self.getMyHelpReqPost()
            }else{
                if(self.isMyPost){
                    self.setUpData()
                }
            }
//=========== Show Unread Message On View===================

            self.showUnreadmessageOnview()
            
//=========== Set TextColor Of Count Label==================
            self.changeColorOfCountLbl()
            
//===========Set Bedge Count And Unhide Tab Bar=============
            
            self.tabBarController?.tabBar.isHidden = false
            self.manageTabbarItemsize() // When we  edit post tabbar item srink  so we use this method to resolve srink problem
            let arrOfviews = self.tabBarController?.view.subviews
            for view in arrOfviews!{
                if view.isKind(of: UIButton.self) {
                    view.isHidden = false
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    
///=========================================
//MARK:- Show Unread Message On View
//==========================================
    
    func addButtonsOnRightSideOfNavigationBar() -> Void {
        //create a new button
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "karmaPoint"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(KrmapointsBtnAction(btn:)), for: .touchUpInside)
        button.frame = CGRect(x: 50, y: 0, width: 50, height: 50)
        let barButton = UIBarButtonItem(customView: button)
        
        
       let lbl_ShowKMPoints = UILabel()
        lbl_ShowKMPoints.frame = CGRect(x: 0, y: 1, width: 50, height: 48)
        lbl_ShowKMPoints.backgroundColor = UIColor.clear
        lbl_ShowKMPoints.textColor = UIColor.white
        lbl_ShowKMPoints.textAlignment = .center
        lbl_ShowKMPoints.alignmentRect(forFrame: button.frame)
        
        //lbl.font = lbl.font.withSize(12)
        lbl_ShowKMPoints.font = UIFont(name: "LucidaSans", size: 12.0)
        
        if(UserDefaults.standard.value(forKey: "TotalKMPoints") != nil){
            lbl_ShowKMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
        }else{
            lbl_ShowKMPoints.text = "0"
        }
        
        APP_Delegate().lbl_KMPoints = lbl_ShowKMPoints
        button.addSubview(lbl_ShowKMPoints)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
//================================
//MARK:- Karma Points Btn Action Method
//================================
    @objc func KrmapointsBtnAction(btn: UIButton){//Perform actions here
        
        btnClickEvent(caregoryNm: "Karma Points", action: "Clicked Karma Points", label: "")
        
        let karmaPointsVC = storyboard?.instantiateViewController(withIdentifier: "KARMAPOINTSVC") as! KarmaPointsVC
        
        navigationController?.pushViewController(karmaPointsVC, animated: true)
        
    }
    
///=========================================
//MARK:- Show Unread Message On View
//==========================================
    func showUnreadmessageOnview(){
        
  //===============Update Count Of Tabbar Item================
        if(ChatClass.sharedInstance.getTotelcount() != 0 ){
            let totalUnreadCountOfBothPost  =  ChatClass.sharedInstance.getTotelcount()
            let totalUnreadCountOfSuports =  APP_Delegate().supportsUnreadCount
            self.tabBarController?.tabBar.items?[1].badgeValue =  String(format: "%d", (totalUnreadCountOfBothPost + totalUnreadCountOfSuports!))

        }else{
            if(APP_Delegate().supportsUnreadCount == 0){
                self.tabBarController?.tabBar.items?[1].badgeValue = nil

            }
        }

 //============== Update Count Of My and other Req Lbl==============
        if ChatClass.sharedInstance.getOtherPostCount() == 0 {
            self.lblOthrHelpCount.isHidden  = true
        }else {
            self.lblOthrHelpCount.isHidden = false
            self.lblOthrHelpCount.text =  String(format: "%d", ChatClass.sharedInstance.getOtherPostCount() )
        }
        
        if ChatClass.sharedInstance.getMyPostCount() == 0 {
            self.lblMyHelpCount.isHidden = true
        }else {
            self.lblMyHelpCount.isHidden = false
            self.lblMyHelpCount.text =  String(format: "%d", ChatClass.sharedInstance.getMyPostCount() )
        }
        
        
//=== get callback for Update Count Of My and other Req Lbl==========
        ChatClass.sharedInstance.unreadCallbackOnView {
            
            if ChatClass.sharedInstance.getOtherPostCount() == 0 {
                self.lblOthrHelpCount.isHidden  = true
            }else {
              self.lblOthrHelpCount.isHidden = false
                self.lblOthrHelpCount.text =  String(format: "%d", ChatClass.sharedInstance.getOtherPostCount() )
            }
            
            if ChatClass.sharedInstance.getMyPostCount() == 0 {
                self.lblMyHelpCount.isHidden = true
            }else {
                self.lblMyHelpCount.isHidden = false
                self.lblMyHelpCount.text =  String(format: "%d", ChatClass.sharedInstance.getMyPostCount() )
            }
        }
    }
    
///================================
//MARK:- Set Up Data Method Action
//=================================
    func setUpData(){
        APP_Delegate().isAdmin = false
        sltBtn = btn_Myreq
        self.changeColorOfSelectedBtn(view: bgVwOfMyReq)
        self.resetColorOfUnSltBtn(view: bgVwOfOthrReq)
        self.resetColorOfUnSltBtn(view: bggVwOfSupports)
        
        // Remove Other Array
        for (_, obj) in self.arrOfShowData.enumerated(){
            obj.removeObservernotyOfChatHomeDm()
        }
         self.isRemove = true
         self.getMyHelpReqPost()

    }
    
    ////==================================================================
    
    func showLastMessForSupports(){
        chatNode = String(format: "admin/admin_userId_%@", getUserData()["usr_id"] as! String)
        userUnreadCount = Database.database().reference(withPath: String(format: "/%@/status/admin/",chatNode!))
        userUnreadCountHandler = userUnreadCount?.observe(.childChanged, with: { (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            if(snapshot.key == "unread"){
                //self.userUnreadCount = snapshot.value as! Int
            }
        })
        
        userUnreadCount?.observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            let snapValue = snapshot.value as? [String : Any]
            
            if(snapValue?["unread"] != nil){
                let urreadCount = snapValue?["unread"]as! Int
                if(urreadCount > 0){
                    self.isUnreadMess = true
                }else{
                    self.isUnreadMess = false
                }
            }
        })

    
    firBaseMsgRefresh = Database.database().reference(withPath:String(format: "/%@/message",chatNode!))
    
    //MARK:- -------add mess By Me ------
    gerLastMessHandler = firBaseMsgRefresh?.queryOrderedByKey().queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot : DataSnapshot) in
    
    if(snapshot.value != nil){
    
    let dictOfData =  snapshot.value as! [String : Any]
    self.userMess = dictOfData["message"] as? String
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        }
      })
    }
    
///================================
//MARK:- Remove Chat Array At logout
//================================
    func removeChatArrAtLogOut(_ notification: Any ){
        
        self.arrOfMyPostData.removeAll()
        self.arrOfShowData.removeAll()
    }
    
///================================
//MARK:- Manage TabbarItem Size
//================================
    
    func manageTabbarItemsize(){
        let tabBarItem = tabBarController?.tabBar.items
        
        for item in tabBarItem!{
            item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
            switch (item.tag) {
            case 0:
                
                item.imageInsets = UIEdgeInsetsMake(7, 1, -4, 3)
                break;
            case 1:
                item.imageInsets = UIEdgeInsetsMake(8, 0, -6, 2)
                break;
            case 2:
                
                
                break;
            case 3:
                item.imageInsets = UIEdgeInsetsMake(8, 2, -5, 2)
                break;
            case 4:
                item.imageInsets = UIEdgeInsetsMake(8, 5, -5, 0);                 break;
                
            default:
                break;
            }
        }
        
    }
    
    
//======================================
// MARK:- Btns Method
//===================================
    @IBAction func myReqBtnAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            showLoader(view: self.view)// show loader

             APP_Delegate().isAdmin = false
             self.isMyPost = true
             self.sltBtn = sender

    // ===========Change Color OFSlt Btn OR UnSlt Btn==============
            self.changeColorOfSelectedBtn(view: self.bgVwOfMyReq)
            self.resetColorOfUnSltBtn(view: self.bgVwOfOthrReq)
            self.resetColorOfUnSltBtn(view: self.bggVwOfSupports)
            
    // ===========set TextColor of count label==============
            self.changeColorOfCountLbl()
            
    //============== Remove Other Array=====================
            for (_, obj) in self.arrOfShowData.enumerated(){
                      obj.removeObservernotyOfChatHomeDm()
            }
            self.arrOfShowData.removeAll()
            self.tableView.reloadData()
        
            showLoader(view: self.view)
            self.isRemove = true
            self.getMyHelpReqPost()
        }
    }

   
    @IBAction func otherReqBtnAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            showLoader(view: self.view)// show loader

            APP_Delegate().isAdmin = false
            //self.lbl_Alert.isHidden = true
            self.isMyPost = false
            self.sltBtn = sender


            self.changeColorOfSelectedBtn(view: self.bgVwOfOthrReq)
            self.resetColorOfUnSltBtn(view: self.bgVwOfMyReq)
            self.resetColorOfUnSltBtn(view: self.bggVwOfSupports)
            
            //Remove my array data
            for (_, obj) in self.arrOfMyPostData.enumerated(){
                obj.removeObservernotyOfMyChatHomeDm()
            }
             self.arrOfMyPostData.removeAll()
             self.tableView.reloadData()

            self.isRemove = true
            // set TextColor of count label
            self.changeColorOfCountLbl()
           // self.pageCountOfOthrReq = 1
            
            self.getOtherHelpReqPost()
        }
    }
 
  
    @IBAction func btnSupportsAction(_ sender: Any) {
        DispatchQueue.main.async {
            showLoader(view: self.view)// show loader

            APP_Delegate().isAdmin = true
            //self.lbl_Alert.isHidden = true

            self.showLastMessForSupports()
            self.changeColorOfSelectedBtn(view: self.bggVwOfSupports)
            self.resetColorOfUnSltBtn(view: self.bgVwOfMyReq)
            self.resetColorOfUnSltBtn(view: self.bgVwOfOthrReq)
            
            //Remove my array data
            for (_, obj) in self.arrOfMyPostData.enumerated(){
                obj.removeObservernotyOfMyChatHomeDm()
            }
            self.arrOfMyPostData.removeAll()
            
            // Remove Other Array
            for (_, obj) in self.arrOfShowData.enumerated(){
                obj.removeObservernotyOfChatHomeDm()
            }
            self.arrOfShowData.removeAll()
            self.tableView.reloadData()

            
            self.isRemove = true
            
            // set TextColor of count label
            self.changeColorOfCountLbl()
            self.getAdminDetail()
        //self.tableView.reloadData()
        }

    }
    
    func changeColorOfCountLbl(){
        // set Text color of count label
        self.lblMyHelpCount.textColor = UIColor.white
        self.lblOthrHelpCount.textColor = UIColor.white
        self.lblSuptCount.textColor = UIColor.white
    }

    
//======================================
// MARK:-Change Slt Btn Color  Method
//======================================
    func changeColorOfSelectedBtn(view : UIView){
        for  subview in view.subviews{
            if let lbl = subview as? UILabel {
                lbl.textColor = theamColor(red: 54, green: 181, blue: 185)
            }
        }
    }
    
   func resetColorOfUnSltBtn(view : UIView){
    for  subview in view.subviews{
      if let lbl = subview as? UILabel {
        lbl.textColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
        }
      }
    }
    
    
//================================
//MARK:-  Add Refresh Controller
//================================
    
    func addRefreshController(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(pullToDownRefresh), for: UIControlEvents.valueChanged)
        
        
        pullUpRefeshControl.triggerVerticalOffset = 100;
        pullUpRefeshControl.addTarget(self, action: #selector(pullUpRefreshMethod), for: UIControlEvents.valueChanged)
        self.tableView.bottomRefreshControl = pullUpRefeshControl;
        self.tableView.addSubview(refreshControl)
    }
    
    func pullToDownRefresh() -> Void {

        self.isRemove = true
        sltBtn == btn_Myreq ? self.getMyHelpReqPost() : self.getOtherHelpReqPost()
    }
    
    func pullUpRefreshMethod(){
      
        if(sltBtn == btn_Myreq){
            isMyPost  = true
            self.getMyHelpReqPost()
        }else{
            isMyPost  = false
            self.getOtherHelpReqPost()
        }
    }
    
    func removeRefreshLoader(){
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            if self.pullUpRefeshControl.isRefreshing {
                self.pullUpRefeshControl.endRefreshing()
            }
        }
    }
    
//=====================================
//MARK:-  Table View Delegate Method
//=====================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return APP_Delegate().isAdmin ? 1 : (isMyPost ? arrOfMyPostData.count : arrOfShowData.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     if(APP_Delegate().isAdmin){ // Admin
            
            let identifier = "ChatSupportsCell"
            var cell: ChatSupportsCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatSupportsCell
            if cell == nil {
                tableView.register(UINib(nibName: "ChatSupportsCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = self.tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatSupportsCell

            }
            cell.bgViewOfImg.layer.borderColor = UIColor.lightGray.cgColor
            cell.lbl_Mess.text = self.userMess ?? ""
            cell.lbl_Nm.text = self.adminNm ?? "Admin"
            
            if(self.adminImg != nil && self.adminImg  != ""){
                saveImgIntoCach(strImg: self.adminImg!, imageView: cell.adminImg)
            }else{
                cell.adminImg.image =  UIImage(named: "helpPost_Defalt")
            }
            
            if(Int(lblSuptCount.text! == "" ? "0" : lblSuptCount.text! )! > 0){
                
                cell.backgroundColor = UIColor(red: 235/255, green: 248/255, blue: 248/255, alpha: 1)
                cell.bgViewOfImg.backgroundColor =  UIColor(red: 235/255, green: 248/255, blue: 248/255, alpha: 1)
                lblSuptCount.isHidden = false
            }else{
                 lblSuptCount.isHidden = true
                cell.backgroundColor = UIColor.white
                cell.bgViewOfImg.backgroundColor = UIColor.white
            }
            
            
            
            return cell
        }else{
            
            let identifier = "ChatHomeVCCell"
            var cell: ChatHomeVCCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatHomeVCCell
            if cell == nil {
                tableView.register(UINib(nibName: "ChatHomeVCCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatHomeVCCell
            }
            
            if isMyPost { //MY Help Req
                if(arrOfMyPostData.count == 0){
                    return cell
                }
                let chatHomeDataModel = arrOfMyPostData[indexPath.row]
                cell.lbl_PostNm.text = chatHomeDataModel.pst_title?.capitalizingFirstLetter()
                cell.lbl_CatNm.text = String(format: "#%@     ",chatHomeDataModel.scat_title!)
            
                if chatHomeDataModel.total_PostCount == 0 {
                    cell.lbl_Total_PostCount.isHidden = true
                }else {
                    if chatHomeDataModel.total_PostCount != nil {
                        cell.lbl_Total_PostCount.isHidden  = false
                        cell.lbl_Total_PostCount.text = String(format: "%d", chatHomeDataModel.total_PostCount!)
                    }else{
                        cell.lbl_Total_PostCount.isHidden = true
                    }
                    
                }
                
//===================Date Calculation=========================
                let timexone = chatHomeDataModel.pext_timeZone!
                let diffOfDate = datedifference(timeInterval: chatHomeDataModel.pext_date!, timeZone: chatHomeDataModel.pext_timeZone!)

                if(chatHomeDataModel.pext_date! != ""){
                    if(diffOfDate == "Small" || chatHomeDataModel.pst_completed == "Expired"){
                        cell.lbl_Date.text = "Expired"
                    }else if(chatHomeDataModel.pst_completed == "Yes"){
                        cell.lbl_Date.text = "Ended"}
                    else{
                        if(diffOfDate == "Same"){
                            cell.lbl_Date.text = "Ending on today"
                        }else{
                            cell.lbl_Date.text = String(format:  "Ending on %@" ,  dateFormateWithMonthandDay(timeInterval: chatHomeDataModel.pext_date!))
                        }
                    }
                }
                
     //=========== Hide and Show End Req Btn====================
                if( diffOfDate == "Small" || chatHomeDataModel.pst_completed == "Yes" || chatHomeDataModel.pst_completed == "Expired"){
                    cell.btnEndReq.isHidden = true

                }else{
                    
                    cell.btnEndReq.isHidden = false
                    cell.btnEndReq.addTarget(self, action: #selector(endHelpReqAction(sender:)), for: UIControlEvents.touchUpInside)
                    cell.btnEndReq.tag = indexPath.row
                }
                
                return cell
            }else { //Other Help Req
                
                let chatHomeDataModel = arrOfShowData[indexPath.row]
                cell.lbl_PostNm.text = chatHomeDataModel.pst_title?.capitalizingFirstLetter()
                cell.lbl_CatNm.text = String(format: "#%@     ",chatHomeDataModel.scat_title!)
                
                cell.btnEndReq.isHidden = true

//                if( sltBtn == btn_Myreq && chatHomeDataModel.pst_completed == "No"){
//                    cell.btnEndReq.isHidden = false
//                    
//                    cell.btnEndReq.addTarget(self, action: #selector(endHelpReqAction(sender:)), for: UIControlEvents.touchUpInside)
//                    cell.btnEndReq.tag = indexPath.row
//                    
//                }else{
//                    cell.btnEndReq.isHidden = true
//                    
//                }
                
                // cell.lbl_Total_PostCount.isHidden = true
                if chatHomeDataModel.total_PostCount == 0 {
                    cell.lbl_Total_PostCount.isHidden = true
                }else {
                    
                    if chatHomeDataModel.total_PostCount != nil {
                        cell.lbl_Total_PostCount.isHidden  = false
                        cell.lbl_Total_PostCount.text = String(format: "%d", chatHomeDataModel.total_PostCount!)
                    }else{
                        cell.lbl_Total_PostCount.isHidden = true
                    }
                    
                }
                
//                if(chatHomeDataModel.pext_date! != ""){
//                    let diffOfDate = datedifference(timeInterval: chatHomeDataModel.pext_date!)
//                    if(diffOfDate == "Small"){
//                        cell.btnEndReq.isHidden = true
//                        cell.lbl_Date.text = "Expired"
//                    }else{
//                        cell.lbl_Date.text = String(format:  "Ending on %@" ,  dateFormateWithMonthandDay(timeInterval: chatHomeDataModel.pext_date!))
//                    }
//                }
                
                
                let diffOfDate = chatHomeDataModel.pext_date == nil ? "Same" :   datedifference(timeInterval: chatHomeDataModel.pext_date!, timeZone: chatHomeDataModel.pext_timeZone!)
                
                if diffOfDate == "Small" || chatHomeDataModel.pst_completed == "Expired"{
                    cell.lbl_Date.text = "Request Expired"
                     cell.btnEndReq.isHidden = true
                }else if (chatHomeDataModel.pst_completed == "Yes"){
                    cell.lbl_Date.text = "Request Ended"
                     cell.btnEndReq.isHidden = true
                }else if(diffOfDate == "Same"){
                    cell.lbl_Date.text = "Request help by today"
                }else{
                    cell.lbl_Date.text = String(format: "Needs help by %@  ",  dateFormateWithMonthandDay(timeInterval: chatHomeDataModel.pext_date!))
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(APP_Delegate().isAdmin){
            let chatScreenVC = storyboard?.instantiateViewController(withIdentifier: "ChatScreenVC") as! ChatScreenVC
            
            chatScreenVC.personNm =  UserDefaults.standard.value(forKey: "ADMIN_NM") as? String != "" ? UserDefaults.standard.value(forKey: "ADMIN_NM") as! String : ""
            chatScreenVC.otherUser_id =  ""
            chatScreenVC.hlp_pst_id = ""
            chatScreenVC.pstCreater_Id = ""
            chatScreenVC.typeOfHelpReq = ""
            navigationController?.pushViewController(chatScreenVC, animated: true)
         }else{
            if isMyPost {
                
                let chatHomeDataModel = arrOfMyPostData[indexPath.row]
                let chatMyAndOthrHelpReqVC = storyboard?.instantiateViewController(withIdentifier: "ChatMyAndOthrHelpReqVC") as! ChatMyAndOthrHelpReqVC
                
                chatMyAndOthrHelpReqVC.MYchatHomeDataModel = chatHomeDataModel
                
                if(sltBtn == btn_Myreq){
                    
                    chatMyAndOthrHelpReqVC.typeOfHelpReq = "MY_CHAT"
                }else{
                    
                    chatMyAndOthrHelpReqVC.typeOfHelpReq = "OTHER_CHAT"
                }
             navigationController?.pushViewController(chatMyAndOthrHelpReqVC, animated: true)
            }else {
                let chatHomeDataModel = arrOfShowData[indexPath.row]
                let chatMyAndOthrHelpReqVC = storyboard?.instantiateViewController(withIdentifier: "ChatMyAndOthrHelpReqVC") as! ChatMyAndOthrHelpReqVC
                
                chatMyAndOthrHelpReqVC.chatHomeDataModel = chatHomeDataModel
                
                if(sltBtn == btn_Myreq){
                    
                    chatMyAndOthrHelpReqVC.typeOfHelpReq = "MY_CHAT"
                }else{
                    
                    chatMyAndOthrHelpReqVC.typeOfHelpReq = "OTHER_CHAT"
                }
                navigationController?.pushViewController(chatMyAndOthrHelpReqVC, animated: true)
            } 
        }
       
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 3000
    }

//========================================================
// MARK:- Call SerVice For Get myHelp Req List
//========================================================
    
    /*
     1.usrToken->user token
     2.usrId->user id(only for my record)
     3.catId->category id
     4.completed->(Yes or No))
     5.limit->limit
     6.page->page
     7.locId->location id
     */
    
    func getMyHelpReqPost(){
    
        
        //showLoader(view: self.view)// show loader
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "usrId" : getUserData()["usr_id"],
                                 "catId" : UserDefaults.standard.value(forKey: "HelpReq_Id") as! String,
                                 "limit" : "10",
                                 "page" : isRemove ? 0 : self.arrOfMyPostData.count,
                                  ]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.manageMyOrOtherHelpRequest , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {

                DispatchQueue.main.async {
                    killLoader()
                    weakSelf.removeRefreshLoader()
                    
                     if(!isError){
                        
                        
                        if((response as! [String : Any])["success"] as! Bool == false){
                            if((response as! [String : Any])["message"] as! String == "Deactive" ){
                                DispatchQueue.main.async {
                                    APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                                }
                                return
                            }
                        }
                        
                        
                        if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                            DispatchQueue.main.async {
                                APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                              ShowError(message: (response as! [String : Any])["message"] as! String, controller: weakSelf)
                            }
                            
                        }else{
                     
//                            if(weakSelf.arrOfMyPostData.count == 0){
//                                for (_, obj) in weakSelf.arrOfMyPostData.enumerated(){
//                                    obj.removeObservernotyOfMyChatHomeDm()
//                                }
//                               // weakSelf.arrOfMyPostData.removeAll()
//                               // weakSelf.tableView.reloadData()
//                            }
//
                            if (weakSelf.isRemove == true){
                                weakSelf.isRemove = false
                                for (_, obj) in weakSelf.arrOfMyPostData.enumerated(){
                                    obj.removeObservernotyOfMyChatHomeDm()
                                }
                                weakSelf.arrOfMyPostData.removeAll()
                                weakSelf.tableView.reloadData()
                            }
                            
                            weakSelf.tableView.isHidden  = weakSelf.arrOfMyPostData.count == 0 ? true :  false
                            weakSelf.lbl_Alert.isHidden  = weakSelf.arrOfMyPostData.count == 0 ? false :  true
                            weakSelf.lbl_Alert.text = "This is where you’ll find chats  for the Help requests you've created.\n\nCurrently you don’t have any Help Requests.\n\nIF you want to create a Help Request, Simply click the Communiti Bee icon on the bottom of your screen."
                             killLoader()
                        }
                    }else{
                        weakSelf.lbl_Alert.isHidden = true
                         killLoader()
                      }
                    }
                     killLoader()
                return
            }
            DispatchQueue.main.async {
               // print(response)

                // Remove Refresh Controller
                weakSelf.removeRefreshLoader()
                weakSelf.lbl_Alert.isHidden = true

//                if(weakSelf.arrOfMyPostData.count == 0){
//
//                    for (_, obj) in weakSelf.arrOfMyPostData.enumerated(){
//                        obj.removeObservernotyOfMyChatHomeDm()
//                    }
//                   // weakSelf.arrOfMyPostData.removeAll()
//                }
//
                
                if (weakSelf.isRemove == true){
                    weakSelf.isRemove = false
                    for (_, obj) in weakSelf.arrOfMyPostData.enumerated(){
                        obj.removeObservernotyOfMyChatHomeDm()
                    }
                    weakSelf.arrOfMyPostData.removeAll()
                    weakSelf.tableView.reloadData()
                }
                
                
                let array  = (response as! [String : Any])["data"] as! [[String : Any]]
                
                for (idx, obj) in array.enumerated(){
                    
                    weakSelf.arrOfMyPostData.append(MYChatHomeDM.init(dic: obj))
                       weakSelf.arrOfMyPostData[idx].callbackFromChatHomeDM = {(isSuccess : Bool) -> Void in
                        
                        DispatchQueue.main.async {
                          weakSelf.tableView.reloadData()
                        }
                    }
                }
                
                 weakSelf.tableView.isHidden  = weakSelf.arrOfMyPostData.count == 0 ? true :  false
                 weakSelf.lbl_Alert.isHidden  = weakSelf.arrOfMyPostData.count == 0 ? false :  true
                weakSelf.lbl_Alert.text = "This is where you’ll find chats  for the Help requests you've created.\n\nCurrently you don’t have any Help Requests.\n\nIF you want to create a Help Request, Simply click the Communiti Bee icon on the bottom of your screen."
                 weakSelf.tableView.reloadData()
                 killLoader() 

            }
        })
        
    }
    
    
    
//========================================================
// MARK:- Call SerVice For Get OtherHelp Req List
//========================================================
    
    /*
     
     1.usrToken->user token
     2.usrId->user id(only for my record)
     3.catId->category id
     4.completed->(Yes or No))
     5.limit->limit
     6.page->page
     7.locId->location id
  
     */
    func getOtherHelpReqPost(){
        //showLoader(view: self.view)// show loader
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"] ?? "",
                                 "usrId" : "",

                                 "catId" : UserDefaults.standard.value(forKey: "HelpReq_Id") as! String,
                                 "limit" : "10",
                                 "page" : isRemove ? 0 : self.arrOfShowData.count,
                                 ]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.manageMyOrOtherHelpRequest , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                weakSelf.removeRefreshLoader()
                
                if(!isError){
                    
                    if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                        }
                        return
                    }
                    
                    
                    
                    
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                        DispatchQueue.main.async {
                            APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                            ShowError(message: (response as! [String : Any])["message"] as! String, controller: weakSelf)
                        }
                    }else{
                    DispatchQueue.main.async {
//                        if(weakSelf.arrOfShowData.count == 0){
//                            for (_, obj) in weakSelf.arrOfShowData.enumerated(){
//                                obj.removeObservernotyOfChatHomeDm()
//                            }
//                        }
//                            weakSelf.arrOfShowData.removeAll()
//                            weakSelf.tableView.reloadData()
                            
                            if (weakSelf.isRemove == true){
                                weakSelf.isRemove = false
                                for (_, obj) in weakSelf.arrOfShowData.enumerated(){
                                    obj.removeObservernotyOfChatHomeDm()
                                }
                                weakSelf.arrOfShowData.removeAll()
                                weakSelf.tableView.reloadData()
                            }
                            
                        weakSelf.tableView.isHidden  = weakSelf.arrOfShowData.count == 0 ? true :  false
                        weakSelf.lbl_Alert.isHidden  = weakSelf.arrOfShowData.count == 0 ? false :  true
                            
                            weakSelf.lbl_Alert.text = "This is where you’ll find chats with the people YOU want to help.\n\nCurrently you haven’t volunteered to help anyone on Communiti.\n\nJust go to the Help and start looking for people who need assistance."
                            
                             killLoader()
                        }
                      
                    }
                }else{
                   // ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                     killLoader()
                }
              return
            }
            DispatchQueue.main.async {
                killLoader()
               // print(response)
                // Remove Refresh Controller
                weakSelf.removeRefreshLoader()
//                if(weakSelf.arrOfShowData.count == 0){
//                    for (_, obj) in weakSelf.arrOfShowData.enumerated(){
//                        obj.removeObservernotyOfChatHomeDm()
//                    }
//    
//                   // weakSelf.arrOfShowData.removeAll()
//                    
//                }
                
                if (weakSelf.isRemove == true){
                    weakSelf.isRemove = false
                    for (_, obj) in weakSelf.arrOfShowData.enumerated(){
                        obj.removeObservernotyOfChatHomeDm()
                    }
                    weakSelf.arrOfShowData.removeAll()
                    weakSelf.tableView.reloadData()
                }
                
                let array  = (response as! [String : Any])["data"] as! [[String : Any]]
                
                for (idx, obj) in array.enumerated(){
                    
                    weakSelf.arrOfShowData.append(ChatHomeDM.init(dic: obj))
                    weakSelf.arrOfShowData[idx].callbackFromChatHomeDM = {(isSuccess : Bool) -> Void in
                        
                        DispatchQueue.main.async {
                            weakSelf.tableView.reloadData()
                        }
                   }
                }
        
                weakSelf.tableView.isHidden  = weakSelf.arrOfShowData.count == 0 ? true :  false
                 weakSelf.lbl_Alert.isHidden  = weakSelf.arrOfShowData.count == 0 ? false :  true
                
                weakSelf.lbl_Alert.text = "This is where you’ll find chats with the people YOU want to help.\n\nCurrently you haven’t volunteered to help anyone on Communiti.\n\nJust go to the Help and start looking for people who need assistance."
                
                 weakSelf.tableView.reloadData()
            }
            
        })
        
    }
    
    
    
//========================================================
//MARK:- Table view cell button action method(End Req)
//========================================================
    @objc func endHelpReqAction (sender: UIButton){
        
        let chatHomeDataModel = arrOfMyPostData[sender.tag]
        
        DispatchQueue.main.async {
            self.helpedUsrLstVw = HelpedUserListView.instanceFromNib() as! HelpedUserListView;
            self.helpedUsrLstVw.frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width), height: UIScreen.main.bounds.height)
            self.showHelpedUserListViewWithAnimation(view: self.helpedUsrLstVw )
            self.helpedUsrLstVw.getAllHelpRequestedUser(controller: self, pst_Id: chatHomeDataModel.pst_id!, callBack: {[weak self]  (isSuccess:Bool , message : String)  in
                
                guard let weekSelf = self else { return }
                
                if(isSuccess){ // is Success at user is in user list
                    windowController().view.addSubview(weekSelf.helpedUsrLstVw)
                    weekSelf.helpedUsrLstVw.layoutIfNeeded()
                }else{
                    
                    if(message == "Oops! There is no data to display."){
                        
                        weekSelf.endHelpRequest(pst_Id: chatHomeDataModel.pst_id!, postTtl: chatHomeDataModel.pst_title!, arrOfID: ["NO_ID"] , idx : sender.tag)
                    }else{
                        
                        ShowError(message: message  , controller: self!)
                    }
                    
                }
            })
            
            
            self.helpedUsrLstVw.onHideComplete = {(isSuccess : Bool , arrOfSltId : [Any]) -> Void in
                if(isSuccess){ // isSuccess End Req Btn Clicked
                    
                    self.endHelpRequest(pst_Id: chatHomeDataModel.pst_id!, postTtl: chatHomeDataModel.pst_title! , arrOfID: arrOfSltId , idx : sender.tag)
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
     
     1.usrToken->user token
     2.usrIdFrm->array(1,2)
     3.pstId->Post Id
     4.pstTtl->Post title
     */
    func endHelpRequest(pst_Id: String, postTtl : String , arrOfID: [Any] , idx : Int){
        showLoader(view: self.view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "usrIdFrm" :  arrOfID,
                                 "pstId" : pst_Id,
                                 "pstTtl" : postTtl]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.endHelpRequest , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                if( !isError ){
                    
                    if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                        }
                        return
                    }
                    
                    
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                        DispatchQueue.main.async {
                            APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                            ShowError(message: (response as! [String : Any])["message"] as! String, controller: weakSelf)
                        }
                        
                    }
            }else{
                    ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                    }
                
                return
            }
            
            DispatchQueue.main.async {
                // For Google Analitics
                btnClickEvent(caregoryNm: "Help Request", action: "End Help Request", label: "")
                
                killLoader()
                weakSelf.showAlertForHelpReqComplete()
                 let chatHomeDataModel = weakSelf.arrOfMyPostData[idx]
                chatHomeDataModel.pst_completed = "Yes"
                //weakSelf.arrOfShowData.remove(at: idx)
                weakSelf.tableView.reloadData()
                
                NotificationCentreClass.fireGetTotalKrmPointsUsingNotificationCenter()
                
                
            }
            
        })
        
    }
    
    
//========================================================
// MARK:- Call SerVice For Get Admin Details
//========================================================
    /*
     1.usrToken->user token
     */
    func getAdminDetail(){
        //showLoader(view: self.view)
        
        lbl_Alert.isHidden = true
        
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"]]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.getAdminDetail , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                if( !isError ){
                    
                    if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                        }
                        return
                    }
                    
                    
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                        DispatchQueue.main.async {
                            APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                            ShowError(message: (response as! [String : Any])["message"] as! String, controller: weakSelf)
                        }
                        
                    }else{
                        // ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                    }
                }else{
                    ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                }
                
                return
            }
            
            DispatchQueue.main.async {
                // For Google Analitics
               // print(response)
                killLoader()
                //weakSelf.arrOfShowData.remove(at: idx)
                weakSelf.tableView.isHidden  = false
                
                let name = ((response as! [String : Any])["data"]  as! [String : Any])["adm_name"] as! String
                weakSelf.adminNm = name.capitalizingFirstLetter()
                weakSelf.adminImg = ((response as! [String : Any])["data"]  as! [String : Any])["admin_image"] as! String
                weakSelf.tableView.reloadData()
//weakSelf.lbl_Alert.isHidden  = weakSelf.arrOfMyPostData.count == 0 ? false :  true
                
            }
            
        })
        
    }
    
}
