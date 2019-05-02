//
//  HelpReqDetaliVC.swift
//  Community
//
//  Created by Hatshit on 27/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import GoogleMaps



class HelpReqDetaliVC: UIViewController, UITextViewDelegate , GMSMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var ctylstObjFrmHelpVC: CountryList? // not use
    var countryListObj: CountryList?
    var endReqAlert = EndReqAlert()
    var helpedUsrLstVw = HelpedUserListView()
    var startChatVw = StartChatView()
    var pstDeleteCallback: ((Bool) -> Void)?
    var endReqCallbackOFHRdetails: ((Bool) -> Void)?
    //var isCameFrmCompletedHRVC : Bool!
    @IBOutlet weak var mapView_H: NSLayoutConstraint!

    let reuseIdentifier = "Collection_Cell" // also enter this string as the cell identifier in the storyboard
    var arrOfUserList = [UserListModel]()
    var postId: String?
    var london: GMSMarker?
    var londonView: UIImageView?

    @IBOutlet weak var scroll_View: UIScrollView!
    @IBOutlet weak var footerVw_H: NSLayoutConstraint!
    @IBOutlet weak var bgVw_UserImg: UIView!
    @IBOutlet weak var footer_View: UIView!
    @IBOutlet weak var img_ViewLocAndViru: UIImageView!
    @IBOutlet weak var vertiualDetails_View: UIView!
    @IBOutlet weak var chatBtnBGView: UIView!
    @IBOutlet weak var bgViewOFCollectionView_H: NSLayoutConstraint!
    @IBOutlet weak var iWanthelpBtn: UIButton!
    @IBOutlet weak var bgViewOfUser_H: NSLayoutConstraint!
    @IBOutlet weak var btn_endReq_H: NSLayoutConstraint!

    @IBOutlet weak var collection_View: UICollectionView!
    @IBOutlet weak var image_View: UIImageView!
    @IBOutlet weak var tag_View: UIView!
    @IBOutlet weak var map_View: GMSMapView!
 
    @IBOutlet weak var lbl_HelpTypName: UILabel!
    @IBOutlet weak var txt_View: UITextView!
    @IBOutlet weak var lbl_tittle: UILabel!
    @IBOutlet weak var lbl_CatName: UILabel!
    @IBOutlet weak var lbl_Hashtag1: UILabel!
    @IBOutlet weak var lbl_Hashtag2: UILabel!
    @IBOutlet weak var lbl_Hashtag3: UILabel!
    @IBOutlet weak var bg_TagView_H: NSLayoutConstraint!
    @IBOutlet weak var lbl_setDate: UILabel!
    @IBOutlet weak var lblpeopleHelp: UILabel!
    @IBOutlet weak var txt_View_H: NSLayoutConstraint!
    @IBOutlet weak var lblOfferedToHelp: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
         showLoader(view: self.view)
        
         self.getHelpReqDetails()
         self.hideTabBarController()
        
        //BgView Of Users
        bgViewOfUser_H.constant = 0
        footer_View.isHidden = true
        scroll_View.isHidden = true
        bgVw_UserImg.isHidden = true
        chatBtnBGView.isHidden = true
        
        //Registor GetHivePostDetails Notification
        NotificationCentreClass.registerGetHelpReqDetailsNotifire(vc: self, selector: #selector(self.getHelpPostDetailsUsingNotificationCenter(_:)))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if(countryListObj != nil && countryListObj?.usr_request == "NO"){
            lblOfferedToHelp.isHidden = true;
        }else{
            chatBtnBGView.isHidden = false
            lblOfferedToHelp.isHidden = false;
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
            NotificationCentreClass.removeGetHelpReqDetailsNotifire(vc: self)
    }
    
    //====================================
    //MARK:- SetUp Data Method
    //====================================
    
    @IBAction func userProfileBtnAction(_ sender: Any) {
        
        let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "USERPROFILEVC") as! UserProfileVC
      //  userProfileVC.isOtherUSerProfile = true
        userProfileVC.otherUserId =  countryListObj?.usr_id!
        self.navigationController?.pushViewController(userProfileVC, animated: true)
        
    }
//====================================
//MARK:- SetUp Data Method
//====================================
    func setUpData(){

        
        // -------------------For Footer-------------------------
        let userId = getUserData()["usr_id"] as! String
        let responseid = countryListObj?.usr_id!
        if(userId != responseid){
            DispatchQueue.main.async {
                self.btn_endReq_H.constant = 0
                self.bgViewOfUser_H.constant = 0
            }
            
            footerVw_H.constant = 53
            footer_View.isHidden = false
            bgVw_UserImg.isHidden = false
            bgVw_UserImg.layer.borderWidth = 1
            bgVw_UserImg.layer.borderColor = UIColor.lightGray.cgColor
            
            let radius: CGFloat = footer_View.frame.width / 2.0 //change it to .height if you need spread for height
            let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.1 * radius, height: footer_View.frame.height))
            
            footer_View.layer.cornerRadius = 2
            footer_View.layer.shadowColor = UIColor.black.cgColor
            footer_View.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
            footer_View.layer.shadowOpacity = 0.5
            footer_View.layer.shadowRadius = 3.0 //Here your control your blur
            footer_View.layer.masksToBounds =  false
            footer_View.layer.shadowPath = shadowPath.cgPath
                
          
        }else{
            if(countryListObj?.pst_completed == "Yes" || countryListObj?.pst_completed == "Expired"){
                btn_endReq_H.constant = 0
            }
            
            iWanthelpBtn.isHidden = true
            bgViewOfUser_H.constant = 180
            footer_View.isHidden = true
            footerVw_H.constant = 0
            bgVw_UserImg.isHidden = true

        }

    // -------------------For Tags-------------------------
        DispatchQueue.main.async {
             self.CreateTags()
        }
        
    // ------------For Tittle & Category Name------------------------
        lbl_tittle.text = countryListObj?.pst_title?.capitalizingFirstLetter()
        lbl_CatName.text = String(format: "#%@     ", (countryListObj?.scat_title!.capitalizingFirstLetter())!)
        
        
    // -------------------For TextView-------------------------
        DispatchQueue.main.async {

        self.txt_View.text = self.countryListObj?.pst_description

        let fixedWidth = self.txt_View.frame.size.width
        self.txt_View.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.txt_View.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.txt_View.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.txt_View.isScrollEnabled = true
        self.txt_View.frame = newFrame
        self.txt_View_H.constant = newSize.height
    }
        
    //----------------- For help Type---------------
        if(countryListObj?.pext_type == "Location"){
            self.lbl_HelpTypName.text = "needs help at a location"
            self.img_ViewLocAndViru.image = UIImage(named: "Location_white")
            self.vertiualDetails_View.isHidden = true
            self.map_View.isHidden = false
        }else{
            self.lbl_HelpTypName.text = "needs help by web and phone"
            self.img_ViewLocAndViru.image = UIImage(named: "VirtLocation_img")
            self.map_View.isHidden = true
            self.vertiualDetails_View.isHidden = false
        }
        
     //----------------- For Image---------------
        if(countryListObj?.profile_image != ""){
            
            saveImgIntoCach(strImg: (countryListObj?.profile_image!)!, imageView: image_View)
            
        }else{
            image_View.image =  UIImage(named: "user")
            
        }
        
    //----------------- For date---------------
        
        let diffOfDate = countryListObj?.pext_date == nil ? "orderedSame" :   datedifference(timeInterval: (countryListObj?.pext_date)!, timeZone: (countryListObj?.pext_timeZone)!)

         if diffOfDate == "Small" || countryListObj?.pst_completed == "Expired"{
                lblpeopleHelp.text = "People who helped you!"
                lbl_setDate.text  = "The request has expired"
                footer_View.isHidden = true
                bgVw_UserImg.isHidden = true
                self.btn_endReq_H.constant = 0

            }
            else if (countryListObj?.pst_completed == "Yes"){

                lblpeopleHelp.text = "People who helped you!"
                lbl_setDate.text = "The request has ended"
                footer_View.isHidden = true
                bgVw_UserImg.isHidden = true
                self.btn_endReq_H.constant = 0

            }
            else if(diffOfDate == "Same"){
            
                lblpeopleHelp.text = "Who wants to help you?"
                lbl_setDate.text = "Request help by today"
            }
            else{
                lblpeopleHelp.text = "Who wants to help you?"
                lbl_setDate.text = String(format: "Needs help by %@  ",  dateFormateWithMonthandDay(timeInterval: (countryListObj?.pext_date)!))
            }

   
        
    // =======For Iwant To help Btn-============
        if(countryListObj?.usr_request == "NO"){
             lblOfferedToHelp.isHidden = true;
            if(countryListObj?.pst_completed == "Yes" || diffOfDate == "Small" || countryListObj?.pst_completed == "Expired"){
                iWanthelpBtn.isHidden = true
            }
        }else{
            chatBtnBGView.isHidden = false
             lblOfferedToHelp.isHidden = false;
            iWanthelpBtn.setTitle("", for: UIControlState.normal)
            iWanthelpBtn.backgroundColor = UIColor.clear
        }
        
        scroll_View.isHidden = false
    }
    
 
//=======================================
//MARK:-Hide Tab bar action Method
//=======================================
    func hideTabBarController(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tabBarController?.tabBar.isHidden = true
        if let arrOfviews = tabBarController?.view.subviews{
        for view in arrOfviews{
            if view.isKind(of: UIButton.self) {
                view.isHidden = true
            }
         }
        }
    }
    
    
    @IBAction func helpBrnAction(_ sender: UIButton) {
        
        if(countryListObj?.usr_request == "NO"){
            sender.isUserInteractionEnabled = false
            self.doHelpForHelpPost(btn: sender)
        }else{
           self.ChatBtnClickedAction()
            
        }
    }
    
    
//=======================================
//MARK:-Open Start Chat View
//=======================================
    
    func openStartChatingView(){
        
        DispatchQueue.main.async {
            
            self.startChatVw = StartChatView.instanceFromNib() as! StartChatView;
            self.startChatVw.frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width), height: UIScreen.main.bounds.height)
            
            self.startChatVw.setUpViewMethod(othrUserImg : (self.countryListObj?.profile_image)!, userName: (self.countryListObj?.usr_fname)!)
            self.showStartViewWithAnimation(view: self.startChatVw )
            windowController().view.addSubview(self.startChatVw)
            self.startChatVw.layoutIfNeeded()
            
            self.startChatVw.callBackFromStartChatView = {(isStartChat : Bool) -> Void in
                if(isStartChat){
                    self.moveToChatScreen()
                }
            }
        }
        
    }
    
//=======================================
//MARK:- Cha Btn Click Action Methods
//=======================================
    
    func ChatBtnClickedAction(){
        self.moveToChatScreen()
    }
    
    func moveToChatScreen(){
        
        let chatScreenVC = storyboard?.instantiateViewController(withIdentifier: "ChatScreenVC") as! ChatScreenVC
        APP_Delegate().isAdmin = false
        
        //chatScreenVC.catNm = self.countryListObj?.scat_title
        chatScreenVC.personNm = self.countryListObj!.usr_fname
        chatScreenVC.otherUser_id = self.countryListObj!.usr_id
        chatScreenVC.hlp_pst_id = self.countryListObj!.pst_id
        chatScreenVC.pstCreater_Id = self.countryListObj!.usr_id
        chatScreenVC.pst_completed = self.countryListObj!.pst_completed
        chatScreenVC.pst_title = self.countryListObj!.pst_title
        chatScreenVC.countryListObj = self.countryListObj
        
        if(countryListObj?.usr_id ==  getUserData()["usr_id"] as? String){
            chatScreenVC.typeOfHelpReq = "MY_CHAT"
        }else{
            chatScreenVC.typeOfHelpReq = "OTHER_CHAT"
        }
        navigationController?.pushViewController(chatScreenVC, animated: true)

    }
    
//=======================================
//MARK:- EndReq Btn Action Methods
//=======================================
    @IBAction func endReqBtnAction(_ sender: Any) {
    
        DispatchQueue.main.async {
            self.helpedUsrLstVw = HelpedUserListView.instanceFromNib() as! HelpedUserListView;
            self.helpedUsrLstVw.frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width), height: UIScreen.main.bounds.height)
            self.showHelpedUserListViewWithAnimation(view: self.helpedUsrLstVw )
            self.helpedUsrLstVw.getAllHelpRequestedUser(controller: self, pst_Id: (self.countryListObj?.pst_id!)!, callBack: {[weak self]  (isSuccess:Bool , message : String)  in
                
                guard let weekSelf = self else { return }
                
                if(isSuccess){ // is Success at user is in user list
                    windowController().view.addSubview(weekSelf.helpedUsrLstVw)
                    weekSelf.helpedUsrLstVw.layoutIfNeeded()
                }else{
                    
                    if(message == "Oops! There is no data to display."){
                        
                        weekSelf.endHelpRequest(pst_Id: (self?.countryListObj?.pst_id!)!, postTtl: (self?.countryListObj?.pst_title!)! , arrOfID: ["NO_ID"])
                        
                        
                    }else{
                        
                        ShowError(message: message  , controller: self!)
                    }
                    
                }
            })
        
            self.helpedUsrLstVw.onHideComplete = {(isSuccess : Bool , arrOfSltId : [Any]) -> Void in
                if(isSuccess){ // isSuccess End Req Btn Clicked
                    
                    self.endHelpRequest(pst_Id: self.countryListObj!.pst_id!, postTtl: self.countryListObj!.pst_title! , arrOfID: arrOfSltId)
                }
            }
        }
    }
    
//=======================================
//MARK:- Custom Views Animation Methods
//=======================================
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
    
    
    func showStartViewWithAnimation(view : StartChatView){
        view.isHidden=false;
        view.alert_View.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        view.bg_View.alpha = 0.0 ;
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        view.bg_View.alpha = 0.9
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

//=======================================
//MARK:- Right Btn Of Navi action Method
//=======================================
    @IBAction func rightBtnOfNaviActionMethod(_ sender: Any) {

        self.openDropDownMenu()
    }
    
//======================================
//MARK:- Open DropDownMenu
//======================================    
    func openDropDownMenu(){
        
        let userId = getUserData()["usr_id"] as! String
        let responseid = countryListObj?.usr_id!
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if(userId == responseid){ //For Edit Only Self Post
            if(self.countryListObj?.pst_completed != "Yes"){

                alert.addAction(UIAlertAction(title: "Edit", style: .default) { action in
                    self.moveToCategoryVC()
                    
                })
            }
            
            
            alert.addAction(UIAlertAction(title: "Delete", style: .default) { action in
                
                showLoader(view: self.view)
                showLoader(view: self.view)
                self.detetePostOfHelp(countryList: self.countryListObj!)
                
            })
            
        }

            alert.addAction(UIAlertAction(title: "Share", style: .default) { action in
                       self.shareBtnACtion()
            })
       
        if(userId != responseid){ //Donts repost self Post
            
            let repostStatus  =  self.countryListObj?.usr_report
            if(repostStatus == "YES"){
                alert.addAction(UIAlertAction(title: "Already Reported Request", style: .destructive, handler: { (action) in
                    
                }))
            }else{
                alert.addAction(UIAlertAction(title: "Report", style: .destructive) { action in
                    self.repostBtnAction()
                })
            }
         }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
        })
        
        self.present(alert, animated: true, completion: nil)

    }
    
//====================================
//MARK:- Share Btn Action Method
//====================================
    func shareBtnACtion(){
        DispatchQueue.main.async {
            self.txt_View.resignFirstResponder()
        }
        
        let text = String(format: "I think you might like this post on Communiti, the app for helping and building meaningful connections with people around you! \n%@checkCommunityApp?pstId=%@&type=help",Service.Base_URL, (self.countryListObj?.pst_id)!)
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if(success){
                btnClickEvent(caregoryNm: "Help Request", action: "Share Help Post", label: "")
            }
        }
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
//====================================
//MARK:- Repost Btn Action Method
//====================================
    func repostBtnAction(){
        
//        if(self.countryListObj?.usr_report == "YES"){
////        ShowAlert(title: "", message: "You have already reported this post.", controller: self, cancelButton: "Ok", okButton: nil, style: .alert, callback: { (isOk, isCancel) in})
////        return
//       }
        let reportView = UINib(nibName: "ReportView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ReportView
        reportView.frame = UIScreen.main.bounds
        reportView.getReportList(controller: self, countryList: self.countryListObj!)
        reportView.type = "POST"
        reportView.id = self.countryListObj?.pst_id
        // self.view.addSubview(reportView)
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
    }
    
//====================================
//MARK:- Move To CategoryVC Method
//====================================
    func moveToCategoryVC(){
        
        let userId = getUserData()["usr_id"] as! String
        let responseid = countryListObj?.usr_id!
        
        if(userId == responseid){
            
            APP_Delegate().reqType = false
            APP_Delegate().isEditHelpFld = true
            APP_Delegate().isEditHiveFld = false
            let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
            categoryVC.ctrObjOFCatg = countryListObj
            categoryVC.sltSubCatName = countryListObj?.scat_title
           // categoryVC.sltMainCat_Id = UserDefaults.standard.value(forKey: "HiveReq_Id") as! String
            
            self.navigationController?.pushViewController(categoryVC, animated: true)

        }
    }

//====================================
//MARK:- SetUp Map Method
//====================================
    func setUpOfMap(){
   
        let camera = GMSCameraPosition.camera(withLatitude: Double((countryListObj?.pext_lat)!)!, longitude: Double((countryListObj?.pext_long)!)!, zoom: 15.0)
        map_View.camera = camera
        map_View.delegate = self
        
        let house = UIImage(named: "markers")!.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: house)
        markerView.tintColor = .red
        londonView = markerView
        
    
        let position = CLLocationCoordinate2D(latitude: Double((countryListObj?.pext_lat)!)!, longitude:  Double((countryListObj?.pext_long)!)!)
        let marker = GMSMarker(position: position)
        marker.title = countryListObj?.pext_location
        marker.iconView = markerView
        marker.tracksViewChanges = true
        marker.map = map_View

        london = marker
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        UIView.animate(withDuration: 5.0, animations: { () -> Void in
            self.londonView?.tintColor = .red
        }, completion: {(finished) in
            self.london?.tracksViewChanges = false
        })
    }
    
    
//====================================
//MARK:- Text View Delegate method
//====================================
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true;
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(  self.txt_View.frame.size.height < self.txt_View.contentSize.height){
            
            if(self.txt_View.frame.size.height <= 150){
               textView.translatesAutoresizingMaskIntoConstraints = true
               textView.sizeToFit()

            }else{

                     textView.isScrollEnabled = true
            }
        }else{
            if(self.txt_View.frame.size.height > 80){
                  self.txt_View.frame.size.height =  self.txt_View.contentSize.height
            }
        }
   
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
  
//===================================
// MARK:- Create Tags Method
//===================================
    func CreateTags(){
        
        var arrOfTags = [Tags]()
        arrOfTags = (countryListObj?.tags)!
        
        if arrOfTags.count >= 3 {
            self.lbl_Hashtag1.text = String(format: "%@  ", arrOfTags[0].htag_text!)
            self.lbl_Hashtag2.text = String(format: "%@  ", arrOfTags[1].htag_text!)
            self.lbl_Hashtag3.text = String(format: "%@  ", arrOfTags[2].htag_text!)
            self.manageDesignOftagsFeedCell()
            
        }else  if arrOfTags.count >= 2 {
            self.lbl_Hashtag1.text = String(format: "%@     ", arrOfTags[0].htag_text!)
            self.lbl_Hashtag2.text = String(format: "%@     ", arrOfTags[1].htag_text!)
            self.manageDesignOftagsFeedCell()
            
            
        }else  if arrOfTags.count >= 1 {
            self.lbl_Hashtag1.text = String(format: "%@     ", arrOfTags[0].htag_text!)
            self.manageDesignOftagsFeedCell()
        }else {
            self.lbl_Hashtag1.text = ""
            self.lbl_Hashtag2.text = ""
            self.lbl_Hashtag3.text = ""
            self.bg_TagView_H.constant = 0
        }
     
        DispatchQueue.main.async {
            self.lbl_Hashtag1.sizeToFit()
            self.lbl_Hashtag2.sizeToFit()
            self.lbl_Hashtag3.sizeToFit()
            
            var rect =  self.tag_View.frame
            rect.size.width = self.lbl_Hashtag1.frame.size.width + self.lbl_Hashtag2.frame.size.width + self.lbl_Hashtag3.frame.size.width
            rect.origin.x = (UIScreen.main.bounds.size.width/2) - (rect.size.width/2)
            self.tag_View.frame = rect
            
            
        }
    }

    func manageDesignOftagsFeedCell(){
        self.bg_TagView_H.constant = 26
        self.lbl_Hashtag1.layer.borderColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1).cgColor
        self.lbl_Hashtag2.layer.borderColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1).cgColor
        self.lbl_Hashtag3.layer.borderColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1).cgColor
        
        self.lbl_Hashtag1.textColor = UIColor(red: 140/255, green: 140/255, blue: 150/255, alpha: 1)
        self.lbl_Hashtag2.textColor = UIColor(red: 140/255, green: 140/255, blue: 150/255, alpha: 1)
        self.lbl_Hashtag3.textColor = UIColor(red: 140/255, green: 140/255, blue: 150/255, alpha: 1)
    }
    
    
//========================================================
// MARK:- Collection View Delegate Method
//========================================================
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfUserList.count
    }
    
     internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : CollectionCellOfHelpReq = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionCellOfHelpReq
        
        let userListModel = arrOfUserList[indexPath.row]
        cell.bgView_OfImg.layer.borderColor = UIColor.lightGray.cgColor
        
        if(userListModel.hlp_completed == "Yes"){
            cell.checkMark_ImgVw.isHidden = false
            cell.checkMark_ImgVw.image = UIImage(named: "Checkmark_Green")
        }else{
            cell.checkMark_ImgVw.isHidden = true
        }

        if(userListModel.profile_image != ""){
            saveImgIntoCach(strImg: userListModel.profile_image!, imageView:  cell.user_ImgVw)
        }else{
            cell.user_ImgVw.image =  UIImage(named: "user")
        }
        
        
        if(countryListObj?.pst_completed == "Yes" || countryListObj?.pst_completed == "Expired"){
            btn_endReq_H.constant = 0
            bgViewOfUser_H.constant = 140
        }
        
        return cell
    }
    

//========================================================
// MARK:- Call SerVice For Delete Post Of Hive and Help
//========================================================
    
    /*
     1.usrToken->user token
     2.pstId->post id
     
     
     */
    func detetePostOfHelp( countryList : CountryList){
        showLoader(view: self.view)// show loader
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "pstId" : countryList.pst_id]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.detetePostOfHiveOrHelp , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                if(!isError){
                    
                    
                    if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                           
                        }
                         return
                    }
                    
                    
                    
                    
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                        }
                        
                    }else{
                        
                        ShowError(message: (response as! [String : Any])["message"]  as! String, controller: self!)
                    }
                }else{
                    
                    
                    ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                    })
                }
                
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                weakSelf.navigationController?.popViewController(animated: true)
                
                if weakSelf.pstDeleteCallback != nil {
                    weakSelf.pstDeleteCallback!(true)
                }
            }
      
        })
 
    }
    
//=============================================================
// MARK:- Call SerVice For Get Help Req Detail At Notification
//=============================================================
    
    func getHelpPostDetailsUsingNotificationCenter(_ notification: NSNotification){
        self.getHelpReqDetails()
    }
    
//========================================================
// MARK:- Call SerVice For Get Help Req Details
//========================================================
    /*
     1.usrToken->user token
     2.pstId->post id
     3.locId->location id

     */
    
    func getHelpReqDetails(){
        
     
        showLoader(view: self.view)// show loader
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"] ?? "",
                                 "pstId" : self.postId ?? "",
                                 "locId" : ""]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getHelpReqDetails , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                if(!isError){
                    
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
                        
                        ShowError(message: (response as! [String : Any])["message"]  as! String, controller: self!)
                    }
                }else{
                    
                    
                    ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                    })
                }
                
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                
                  let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                  //print(countryResponseBody!)
                   print(response)

                
                // set Response In CountryListObj
                   weakSelf.countryListObj = countryResponseBody?.data?[0]
                   weakSelf.setUpData()
                
                weakSelf.arrOfUserList.removeAll()
                if let arrOfUser : [UserListModel] = countryResponseBody?.data?[0].help_usrs{
                    
                 
                    weakSelf.arrOfUserList += arrOfUser
                    weakSelf.collection_View.reloadData()
                }else{
                    
                   weakSelf.bgViewOFCollectionView_H.constant = 0
                    weakSelf.bgViewOfUser_H.constant = 80
                }
                 if(weakSelf.countryListObj?.pext_type == "Location"){
                    weakSelf.setUpOfMap()
                 }
            }
        })
    }
    
//========================================================
// MARK:- Call SerVice For Get Help Req Details
//========================================================
    /*
     1.usrToken->user token
     2.pstId->help id
     3.usrIdTo->help user id

     
     
     1.usrToken->user token
     2.pstId->help id
     3.usrIdTo->help user id
     4. pstTtl-> post title
     */
    
    func doHelpForHelpPost(btn : UIButton){
        showLoader(view: self.view)// show loader

        
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "pstId" : self.postId,
                                 "usrIdTo" : countryListObj?.usr_id,
                                 "pstTtl" : countryListObj?.pst_title]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.doHelpForHelpPost , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }

            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                btn.isHidden = false
                btn.isUserInteractionEnabled = true
                
                if(!isError){
                    
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
                        
                        ShowError(message: (response as! [String : Any])["message"]  as! String, controller: self!)
                    }
                }else{
                    
                    
                    ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                    })
                }
                
                return
            }
            
            DispatchQueue.main.async {
                killLoader()

                btnClickEvent(caregoryNm: "Help Request", action: "Apply Help Request ", label: "")
                
                let dict = ["pst_usr_id": self?.countryListObj?.usr_id,
                            "usr_fname": "Harshit",
                            "usr_id": self?.countryListObj?.usr_id,
                            "hlp_pst_id": self?.countryListObj?.pst_id]
                
                ChatClass.sharedInstance.arrOfData.append( ChatClassDataModel.init(dic: (dict as? [String:Any])! ))
                
                     ChatClass.sharedInstance.showAlertNewMessage()
              //  ChatClass.arr.append( ChatClassDataModel.init(dic: dict))
                
                
                weakSelf.openStartChatingView()

                weakSelf.countryListObj?.usr_request = "YES"
                btn.isUserInteractionEnabled = true
                weakSelf.chatBtnBGView.isHidden = false
                btn.setTitle("", for: UIControlState.normal)
                btn.backgroundColor = UIColor.clear
                                
            }
            
        })
        
    }
    
//========================================================
// MARK:- Call SerVice For End Help REq
//========================================================
    /*
     1.usrToken->user token
     2.usrIdFrm->array(1,2)
     3.pstId->Post Id
     */
    func endHelpRequest(pst_Id: String , postTtl : String , arrOfID: [Any]){
        showLoader(view: self.view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "usrIdFrm" :  arrOfID,
                                 "pstId" : pst_Id,
                                 "pstTtl" : postTtl]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.endHelpRequest , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                if(!isError){
                    
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
                        
                        ShowError(message: (response as! [String : Any])["message"]  as! String, controller: self!)
                    }
                }else{
                    
                    
                    ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                    })
                }
                
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                btnClickEvent(caregoryNm: "Help Request", action: "End Help Request", label: "")

                weakSelf.showAlertForHelpReqComplete()
                weakSelf.btn_endReq_H.constant = 0
                self?.ctylstObjFrmHelpVC?.pst_completed = "Yes"
                self?.lbl_setDate.text = "The request has ended"
          
                for obj in weakSelf.arrOfUserList{
                    
                    let predicates  = NSPredicate(format: "self MATCHES %@", String(format: "%@", obj.usr_id!))
                    let filterArray = (arrOfID as NSArray).filtered(using: predicates)
                    if(filterArray.count != 0){
                        obj.hlp_completed = "Yes"
                    }
                }
                self?.collection_View.reloadData()
                
                // ManageHRVC KA Liye Callback
                if weakSelf.endReqCallbackOFHRdetails != nil {
                    weakSelf.endReqCallbackOFHRdetails!(true)
                }
      
                
                NotificationCentreClass.fireGetTotalKrmPointsUsingNotificationCenter()
            }
            
        })
        
    }
   
}
