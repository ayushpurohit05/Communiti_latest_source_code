 //
//  FeedVC.swift
//  Community
//
//  Created by Hatshit on 23/11/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper
import MGSwipeTableCell
import CCBottomRefreshControl


//==========================================================
class FeedVC: UIViewController,UITableViewDataSource,UITableViewDelegate, MGSwipeTableCellDelegate, UIScrollViewDelegate {
    let cellReuseIdentifier = "Cell"
    let reuseIdOfHelp = "HelpCell"
    var isHive : Bool!
    var isBannerHideOFHive = false
    var isBannerHideOFHelp = false
    var arrOFShowData = [CountryList]()
    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    //var pagesCountOfHive = 1
    //var pagesCountOfHelp = 1
    var isRefresh = false
    var isNoMoreData = false
    var lbl_ShowKMPoints : UILabel!
    var totalPostCount : String!
    
    @IBOutlet weak var lbl_Feed: UILabel!
    @IBOutlet weak var lbl_Filter: UILabel!
    
//================= Future Use HR Section  =======================
    @IBOutlet var btnSegment_H: NSLayoutConstraint!
    @IBOutlet var bannerView_Y: NSLayoutConstraint!
//================================================================
    
//==========================================================
    
    //var FltArrOfActiyNm = [Any]()
    var FltArrOfAcyNmOrLoctNm = [Any]()
    var FltArrOfScatIds = [Any]()
    var FltArrOfScatNm = [Any]()
    var FltArrOfTags = [Any]()
//==========================================================
    
    @IBOutlet var imgVw_MorePost: UIImageView!
    @IBOutlet var bgViewOFMorePost_H: NSLayoutConstraint!
    @IBOutlet weak var lbl_OFBaner: UILabel!
    @IBOutlet weak var bgalertView: UIView!
    @IBOutlet weak var btn_Sagment: UISegmentedControl!
    @IBOutlet weak var btn_Cross: UIButton!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerView_H: NSLayoutConstraint!
    @IBOutlet weak var tbl_View: UITableView!
//==========================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHive = true
       
        self.removeHrSection()
        
        NotificationCentreClass.registerPostRegisterNotifier(vc: self, selector: #selector(self.getHiveReqAllPostAtPopTime(_:)))
         NotificationCentreClass.registerHelpRegisterNotifier(vc: self, selector: #selector(self.HelpReqAllPostAtPopTime(_:)))
        NotificationCentreClass.registerRemoveArrayOfFeedVCNotifier(vc: self, selector: #selector(self.removeFeedArrAtLogOut(_:)))
        //=============REgistor Total Karma Points Notification=================
        NotificationCentreClass.registerGetTotalKrmPointsUsingNotificationCenter(vc: self, selector: #selector(self.getTotalKrmPointsUsingNotificationCenter(_:)))
        
        NotificationCentreClass.registerCategoryRegisterNotifier(vc: self, selector: #selector(self.getMainCategorylistMethod))

        
        //================== Future Use OF Chat=============================
        // NotificationCentreClass.registerHelpedUserlistAtChatRegisterNotifier(vc: self, selector: #selector(self.creatSharedStanceOfChatClass(_:)))
        //=================================================================

        self.setUpView()
        self.addButtons()
        
    //==================Future User Chat CallBeck For UnreadCount ==================
       // self.showUnreadmessageOnview()
    //=================================================================
     }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.isHidden = false
            self.manageTabbarItemsize() // When we  edit post tabbar item srink  so we use this method to resolve srink problem
            let arrOfviews = self.tabBarController?.view.subviews
            for view in arrOfviews!{
                if view.isKind(of: UIButton.self) {
                    view.isHidden = false
                }
            }
        }
        
        
    // =================For Token Expired==============
        if(APP_Delegate().isPopForLogin){
            DispatchQueue.main.async {
                APP_Delegate().tokenExpired(controller: (self.tabBarController as? TabBarController)!)
            }
        }
        
        DispatchQueue.main.async {
            self.tbl_View.reloadData()
        }
        
   // ============For Manage Segment Controller==============
        if(APP_Delegate().reqType){
            btn_Sagment.selectedSegmentIndex = 0
        }else{
            btn_Sagment.selectedSegmentIndex = 1
        }
        
   

        lbl_OFBaner.text = APP_Delegate().reqType == true ? "The Feed is your own personal and customized channel where you see users discussing topics from Hives that you are a part of." : "The HELP is where you can see and respond to help requests from the people around you. Click on any of them to know more."
        
        
        
        //=============user join neew group nad exit group and Delete any Post From postVC =====
        if(APP_Delegate().isRefreshFeedVClist){
            self.callOnlyaddAndRemovePostAtATimeJoinAndExitGroup()
        }
        //=======================================================
    }
    
    
    func callOnlyaddAndRemovePostAtATimeJoinAndExitGroup(){
        
        isRefresh = false
        isNoMoreData = false
        //self.pagesCountOfHive = 1
        //self.pagesCountOfHelp = 1
        self.arrOFShowData.removeAll()
        
        APP_Delegate().reqType == true ? self.getHiveReqAllPost(arrOfActyOrLoctNm:  self.FltArrOfAcyNmOrLoctNm.count != 0 ? self.FltArrOfAcyNmOrLoctNm : [], arrOfScatIds: self.FltArrOfScatIds.count != 0 ? self.FltArrOfScatIds : [], arrOfTags: self.FltArrOfTags.count != 0 ? self.FltArrOfTags : []) : getAllHelpReqPost(arrOfActyOrLoctNm:  self.FltArrOfAcyNmOrLoctNm.count != 0 ? self.FltArrOfAcyNmOrLoctNm : [], arrOfScatIds: self.FltArrOfScatIds.count != 0 ? self.FltArrOfScatIds : [], arrOfTags: self.FltArrOfTags.count != 0 ? self.FltArrOfTags : [])
    }
    
//================= Future Use HR Section  =============================
    func removeHrSection(){
        self.btnSegment_H.constant = 0
        self.bannerView_Y.constant = 0
    }
    
    
    func creatSharedStanceOfChatClass(_ notification: NSNotification){
        ChatClass.sharedInstance.getAllHelpedUserOnSelfPostAtChat(controller: self)
        APP_Delegate().myOnlineStatus()
        //APP_Delegate().getMyUnreadCountAtSupports()
    }
    
    func showUnreadmessageOnview(){ //For Futrue Use 
        
        //---------------------- Callback From appdelegate for showmn the suppor                                                      (admin) unread mess of user send by admin--------------
        
        APP_Delegate().callForFeedVCToSowUnreadCount = {(isSuccess : Bool , result : Int) -> Void in
            //print(result)
            if(result > 0){
                
                let totalUnreadCountOfBothPost  =  ChatClass.sharedInstance.getTotelcount()
                let totalUnreadCountOfSuports =  result
                self.tabBarController?.tabBar.items?[1].badgeValue =  String(format: "%d", (totalUnreadCountOfBothPost + totalUnreadCountOfSuports))
            }else{
                
                if(ChatClass.sharedInstance.getTotelcount() != 0 ){
                    self.tabBarController?.tabBar.items?[1].badgeValue = String(format: "%d", ChatClass.sharedInstance.getTotelcount() )
                }else{
                    self.tabBarController?.tabBar.items?[1].badgeValue = nil
                }
            }
        }
        
        ChatClass.sharedInstance.unreadCallback {
            let totalUnreadCountOfBothPost  =  ChatClass.sharedInstance.getTotelcount()
            let totalUnreadCountOfSuports =  APP_Delegate().supportsUnreadCount
            
            self.tabBarController?.tabBar.items?[1].badgeValue =  String(format: "%d", (totalUnreadCountOfBothPost + totalUnreadCountOfSuports!))
            
        }
    }
//=======================================================================
    
   
    
    
    func addButtons() -> Void {
        //create a new button
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "karmaPoint"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(KrmapointsBtnAction(btn:)), for: .touchUpInside)
        button.frame = CGRect(x: 50, y: 0, width: 50, height: 50)
        let barButton = UIBarButtonItem(customView: button)
        
        
        lbl_ShowKMPoints = UILabel()
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
    
    
//=========================================
//MARK:-FeedBtn Action Method
//=========================================
    @IBAction func feedBtnAction(_ sender: Any) {
         self.isNoMoreData = false

    
        self.arrOFShowData.removeAll()
        self.FltArrOfAcyNmOrLoctNm.removeAll()
        self.FltArrOfScatIds.removeAll()
        self.FltArrOfScatNm.removeAll()
        self.FltArrOfTags.removeAll()
        
        self.manageFltCountOfFilterLabel()

        self.lbl_Feed.textColor = UIColor(red: 5/255, green: 163/255, blue: 164/255, alpha: 1)
        self.lbl_Filter.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        
        if(APP_Delegate().reqType ){
            showLoader(view: self.view)
            self.getHiveReqAllPost(arrOfActyOrLoctNm: FltArrOfAcyNmOrLoctNm, arrOfScatIds: FltArrOfScatIds, arrOfTags: FltArrOfTags)
        }else{
            showLoader(view: self.view)
            self.getAllHelpReqPost(arrOfActyOrLoctNm: FltArrOfAcyNmOrLoctNm, arrOfScatIds: FltArrOfScatIds, arrOfTags: FltArrOfTags)
        }
    }
    
//=========================================
//MARK:- CheckOut Hive Btn Action Method
//=========================================
    @IBAction func checkOutHiveBtnAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
//=========================================
//MARK:- FilterBtn Action Method
//=========================================
    
    @IBAction func FilterBtnAction(_ sender: Any) {
      
        let filterHomeVC = storyboard?.instantiateViewController(withIdentifier: "FILTERHOMEVC") as! FilterHomeVC
        
        filterHomeVC.arrOfSltActyNmOrLotn = self.FltArrOfAcyNmOrLoctNm as! [String]
        filterHomeVC.arrOfSltCatIds = self.FltArrOfScatIds as! [String]
        filterHomeVC.arrOfSltCatNm = self.FltArrOfScatNm as! [String]
        filterHomeVC.addedTags = self.FltArrOfTags as! [String]


        filterHomeVC.callBackFromFltHomeVC = {(isSuccess : Bool , arrOfActyOrLoctNm : [Any] , arrOfScatIds : [Any] , arrOfTags : [Any], arrOfScatNm : [Any]) -> Void in
          
            self.isNoMoreData = false
            self.FltArrOfAcyNmOrLoctNm = arrOfActyOrLoctNm
            self.FltArrOfScatIds = arrOfScatIds
            self.FltArrOfScatNm = arrOfScatNm
            self.FltArrOfTags = arrOfTags
      
            self.arrOFShowData.removeAll()
            
                self.manageFltCountOfFilterLabel()
            
            if(isSuccess){ // Apply Filter
           
                self.lbl_Feed.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
                self.lbl_Filter.textColor = UIColor(red: 5/255, green: 163/255, blue: 164/255, alpha: 1)

                
                if(APP_Delegate().reqType ){
                    showLoader(view: self.view)
                    self.getHiveReqAllPost(arrOfActyOrLoctNm: arrOfActyOrLoctNm, arrOfScatIds: arrOfScatIds, arrOfTags: arrOfTags)

                }else{
                    showLoader(view: self.view)
                    self.getAllHelpReqPost(arrOfActyOrLoctNm: arrOfActyOrLoctNm, arrOfScatIds: arrOfScatIds, arrOfTags: arrOfTags)
                }
            
            }else{ // Reset Flt
              
                   self.lbl_Feed.textColor = UIColor(red: 5/255, green: 163/255, blue: 164/255, alpha: 1)
                   self.lbl_Filter.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)

                if(APP_Delegate().reqType ){
                    showLoader(view: self.view)
                    self.getHiveReqAllPost(arrOfActyOrLoctNm: arrOfActyOrLoctNm, arrOfScatIds: arrOfScatIds, arrOfTags: arrOfTags)
                    
                }else{
                    showLoader(view: self.view)
                    self.getAllHelpReqPost(arrOfActyOrLoctNm: arrOfActyOrLoctNm, arrOfScatIds: arrOfScatIds, arrOfTags: arrOfTags)
                }
            }
        }
        navigationController?.pushViewController(filterHomeVC, animated: true)
    }
    
    
    
    
//================================
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
    
//================================
//MARK:-  Set Up data Method
//================================
    
    func setUpView(){

        // add refresh controller
        self.addRefreshController()

        btn_Sagment.layer.borderColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1).cgColor
        btn_Sagment.layer.borderWidth = 1.0
        btn_Sagment.layer.cornerRadius = 4.0
        btn_Sagment.clipsToBounds = true
        let inactive = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

        
        let yourAttributes1 = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: Font.OpenSansRegular(fontSize: 18.0)]
        btn_Sagment.setTitleTextAttributes(yourAttributes1, for: UIControlState.selected)
        let yourAttributes2 = [NSForegroundColorAttributeName: inactive, NSFontAttributeName: Font.OpenSansRegular(fontSize: 18.0)]
        btn_Sagment.setTitleTextAttributes(yourAttributes2, for: UIControlState.normal)
    }
    
//================================
//MARK:- Karma Points Btn Action Method
//================================
    @objc func KrmapointsBtnAction(btn: UIButton){//Perform actions here
        
        btnClickEvent(caregoryNm: "Karma Points", action: "Clicked Karma Points", label: "")

        let karmaPointsVC = storyboard?.instantiateViewController(withIdentifier: "KARMAPOINTSVC") as! KarmaPointsVC
    
        navigationController?.pushViewController(karmaPointsVC, animated: true)
        
    }


//================================
//MARK:- Btn Action Method
//================================
    @IBAction func btnActionMethod(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.bannerView_H.constant = 1;
            self.view.layoutIfNeeded()
            },
          completion: { (finished) -> Void in
        })

        if(isHive){
            isBannerHideOFHive = true
        }else{
            isBannerHideOFHelp = true
        }
    }
//================================
//MARK:-  Add Refresh Controller
//================================
    
    func addRefreshController(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(pullToDownRefresh), for: UIControlEvents.valueChanged)
        self.tbl_View.addSubview(refreshControl)
       
        pullUpRefeshControl.triggerVerticalOffset = 100;
        pullUpRefeshControl.addTarget(self, action: #selector(pullUpRefreshMethod), for: UIControlEvents.valueChanged)
        self.tbl_View.bottomRefreshControl = pullUpRefeshControl;
    }
    
    func pullToDownRefresh() -> Void {
        isRefresh = false
        isNoMoreData = false
        //self.pagesCountOfHive = 1
        //self.pagesCountOfHelp = 1
        self.arrOFShowData.removeAll()
        
        APP_Delegate().reqType == true ? self.getHiveReqAllPost(arrOfActyOrLoctNm:  self.FltArrOfAcyNmOrLoctNm.count != 0 ? self.FltArrOfAcyNmOrLoctNm : [], arrOfScatIds: self.FltArrOfScatIds.count != 0 ? self.FltArrOfScatIds : [], arrOfTags: self.FltArrOfTags.count != 0 ? self.FltArrOfTags : []) : getAllHelpReqPost(arrOfActyOrLoctNm:  self.FltArrOfAcyNmOrLoctNm.count != 0 ? self.FltArrOfAcyNmOrLoctNm : [], arrOfScatIds: self.FltArrOfScatIds.count != 0 ? self.FltArrOfScatIds : [], arrOfTags: self.FltArrOfTags.count != 0 ? self.FltArrOfTags : [])
    }
    
    func pullUpRefreshMethod(){
        isRefresh = true
        if(APP_Delegate().reqType){
            
            if(isNoMoreData){
                self.showToastForMoreData(message: "No more data", width: 120)
                // Remove Refresh Controller
                self.removeRefreshLoader()
                killLoader()
            }else{
                //pagesCountOfHive = pagesCountOfHive + 1
                self.getHiveReqAllPost(arrOfActyOrLoctNm:  self.FltArrOfAcyNmOrLoctNm.count != 0 ? self.FltArrOfAcyNmOrLoctNm : [], arrOfScatIds: self.FltArrOfScatIds.count != 0 ? self.FltArrOfScatIds : [], arrOfTags: self.FltArrOfTags.count != 0 ? self.FltArrOfTags : [])
            }

        }else{
            
            if(isNoMoreData){
                //showLoader(view: self.view)
                self.showToastForMoreData(message: "No more data", width: 120)
                //Remove Refresh Controller
                self.removeRefreshLoader()
                //killLoader()
               
                
            }else{
                
                //showLoader(view: self.view)
               // pagesCountOfHelp = pagesCountOfHelp + 1
                getAllHelpReqPost(arrOfActyOrLoctNm:  self.FltArrOfAcyNmOrLoctNm.count != 0 ? self.FltArrOfAcyNmOrLoctNm : [], arrOfScatIds: self.FltArrOfScatIds.count != 0 ? self.FltArrOfScatIds : [], arrOfTags: self.FltArrOfTags.count != 0 ? self.FltArrOfTags : [])
            }
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
    
//======================================
//MARK:- Segment Button Action methods
//======================================
    
    @IBAction func segmentBtnAction(_ sender: UISegmentedControl) {
        
        if(self.arrOFShowData.count > 0){
            let indexPath = IndexPath(row: 0, section: 0)
            self.tbl_View.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        
        self.arrOFShowData.removeAll()
        self.FltArrOfAcyNmOrLoctNm.removeAll()
        self.FltArrOfScatIds.removeAll()
        self.FltArrOfScatNm.removeAll()
        self.FltArrOfTags.removeAll()
        
        isNoMoreData = false
        self.tbl_View.isHidden = true
        
        // Remove Flt Count
        self.lbl_Feed.textColor = UIColor(red: 5/255, green: 163/255, blue: 164/255, alpha: 1)
        self.lbl_Filter.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        self.manageFltCountOfFilterLabel()
        
        
        if( sender.selectedSegmentIndex == 1){ // help segment
            
          lbl_OFBaner.text =  "The HELP is where you can see and respond to help requests from the people around you. Click on any of them to know more."
            
             APP_Delegate().reqType = false
             isHive = false;

             self.bannerView_H.constant = 75;
             self.btn_Cross.isUserInteractionEnabled = true
             self.btn_Cross.isHidden = false
            
            if(isBannerHideOFHelp){
                self.btn_Cross.isUserInteractionEnabled = false
                self.btn_Cross.isHidden = true
                UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                  self.bannerView_H.constant = 1;
                })
            }

            showLoader(view: self.view)
            
             self.getAllHelpReqPost(arrOfActyOrLoctNm:  self.FltArrOfAcyNmOrLoctNm.count != 0 ? self.FltArrOfAcyNmOrLoctNm : [], arrOfScatIds: self.FltArrOfScatIds.count != 0 ? self.FltArrOfScatIds : [], arrOfTags: self.FltArrOfTags.count != 0 ? self.FltArrOfTags : [])
       
        }else{// hive segment
            
           lbl_OFBaner.text = "The HIVE is where you can see what people are discussing, debate ideas and ask for advise from those around you."
            
             APP_Delegate().reqType = true
             isHive = true;
            
            if(isBannerHideOFHive){
                  self.btn_Cross.isUserInteractionEnabled = false
                  self.btn_Cross.isHidden = true
                 UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.bannerView_H.constant = 1;
                })
            }
            
            showLoader(view: self.view)
            
            self.getHiveReqAllPost(arrOfActyOrLoctNm:  self.FltArrOfAcyNmOrLoctNm.count != 0 ? self.FltArrOfAcyNmOrLoctNm : [], arrOfScatIds: self.FltArrOfScatIds.count != 0 ? self.FltArrOfScatIds : [], arrOfTags: self.FltArrOfTags.count != 0 ? self.FltArrOfTags : [])
        }
    }
    
//======================================
//MARK:- Tabel view delegate methods
//======================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOFShowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(arrOFShowData.count == 0){
            let cell : UITableViewCell
            if(APP_Delegate().reqType){
                cell = self.tbl_View.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! FeedCell
            }else{
                cell = self.tbl_View.dequeueReusableCell(withIdentifier: reuseIdOfHelp) as! HelpCell
            }
            return cell
        }
        
        if(APP_Delegate().reqType){ // Hive Cell
           let cell:FeedCell = self.tbl_View.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! FeedCell
            cell.BgViewOfImg.layer.borderColor = UIColor.lightGray.cgColor
            cell.delegate = self
            cell.tag = indexPath.row
            
            // initiall 0 For Moew Post
            self.bgViewOFMorePost_H.constant = 0
            
            let countryList = self.arrOFShowData[indexPath.row]
            DispatchQueue.main.async {
                if(countryList.profile_image != nil && countryList.profile_image != ""){
                    saveImgIntoCach(strImg: countryList.profile_image!, imageView: cell.cell_ImgView)
                }else{
                    cell.cell_ImgView.image =  UIImage(named: "helpPost_Defalt")
                }
            }
            
            cell.txtView_Tittle.text = countryList.pst_title!.capitalizingFirstLetter()
            cell.txtView_Des.text = countryList.pst_description!.capitalizingFirstLetter()
            cell.lbl_CatName.text = String(format: "#%@     ", countryList.grp_title ?? "")
            
            cell.lbl_Date.text = showDate(timeInterval: (countryList.pst_updatedate != "" ? countryList.pst_updatedate : countryList.pst_createdate)!)
            cell.lbl_Replies.text = String(format: "%@ replies", countryList.replies_count ?? "0")
            cell.btn_UpDownVote.addTarget(self, action: #selector(upAndDownVoteBtnAction(btn:)), for: .touchUpInside)
            cell.btn_UpDownVote.tag = indexPath.row
            cell.lbl_VotesCount.text = countryList.upvote_count
            
            
            if( countryList.usr_upvote == "NO"){
                cell.imgViewOfVotes.image = UIImage(named: "up_1x")
            }else{
                cell.imgViewOfVotes.image = UIImage(named: "up_Active")
            }
      
            
                var arrOfTags = [Tags]()
                arrOfTags = countryList.tags!
                
                if arrOfTags.count >= 3 {
                    
                    cell.lbl_Hashtag1.text = String(format: "%@     ", arrOfTags[0].htag_text!)
                    cell.lbl_Hashtag2.text = String(format: "%@     ", arrOfTags[1].htag_text!)
                    cell.lbl_Hashtag3.text = String(format: "%@     ", arrOfTags[2].htag_text!)
                    cell.lbl_Hashtag4.text = String(format: "%@     ", arrOfTags[2].htag_text!)
                    
                    self.manageDesignOftagsFeedCell(feed_Cell: cell)
                    self.manageTagsSize(feed_Cell: cell )
                    
                    
                }else  if arrOfTags.count >= 2 {
                    cell.lbl_Hashtag1.text = String(format: "%@     ", arrOfTags[0].htag_text!)
                    cell.lbl_Hashtag2.text = String(format: "%@     ", arrOfTags[1].htag_text!)
                    cell.lbl_Hashtag3.text = ""
                    self.manageDesignOftagsFeedCell(feed_Cell: cell)
                    
                    
                }else  if arrOfTags.count >= 1 {
                    cell.lbl_Hashtag1.text = String(format: "%@     ", arrOfTags[0].htag_text!)
                    cell.lbl_Hashtag2.text = ""
                    cell.lbl_Hashtag3.text = ""
                    self.manageDesignOftagsFeedCell(feed_Cell: cell)
                }else {
                    cell.lbl_Hashtag1.text = ""
                    cell.lbl_Hashtag2.text = ""
                    cell.lbl_Hashtag3.text = ""
                    cell.bg_TagView_H.constant = 0
                    cell.lbl_Hashtag4.isHidden = true
                }
            return cell
            
        }else{ // Help Cell
            
            let cell:HelpCell = self.tbl_View.dequeueReusableCell(withIdentifier: reuseIdOfHelp) as! HelpCell
            cell.bgViewOfImg.layer.borderColor = UIColor.lightGray.cgColor
            cell.delegate = self
            cell.tag = indexPath.row
            
            // initiall 0 For Moew Post
            self.bgViewOFMorePost_H.constant = 0
            
  
            let countryList = arrOFShowData[indexPath.row]
            
            let diffOfDate = countryList.pext_date == nil ? "Same" :   datedifference(timeInterval: countryList.pext_date!, timeZone: countryList.pext_timeZone!)
            
            if diffOfDate == "Small" || countryList.pst_completed == "Expired"{
                cell.lbl_ReqOnDate.text = "Request Expired"
            }else if (countryList.pst_completed == "Yes"){
                cell.lbl_ReqOnDate.text = "Request Ended"
            }else if(diffOfDate == "Same"){
                cell.lbl_ReqOnDate.text = "Request help by today"
            }else{
                cell.lbl_ReqOnDate.text = String(format: "Needs help by %@  ",  dateFormateWithMonthandDay(timeInterval: countryList.pext_date!))
            }
            

            if(countryList.subCat_icon != ""){
                saveImgIntoCach(strImg: countryList.subCat_icon ?? "", imageView: cell.cell_ImgView)
            }else{
                cell.cell_ImgView.image =  UIImage(named: "helpPost_Defalt")
            }
            
        
            cell.lbl_tittle.text = countryList.pst_title!.capitalizingFirstLetter()
            cell.lbl_CatName.text = String(format: "#%@     ", countryList.scat_title!)
            if(countryList.pext_type == "Location"){
                cell.lbl_HelpTypName.text = "needs help at a location"
                cell.imgVW_HelpType.image = UIImage(named: "Location_white")
                
            }else{
                cell.lbl_HelpTypName.text = "needs help by web and phone"
                cell.imgVW_HelpType.image = UIImage(named: "VirtLocation_img")
            }

            var arrOfTags = [Tags]()
            arrOfTags = countryList.tags!
            
            if arrOfTags.count >= 3 {
                    cell.lbl_Hashtag1.text = String(format: "%@     ", arrOfTags[0].htag_text!)
                    cell.lbl_Hashtag2.text = String(format: "%@     ", arrOfTags[1].htag_text!)
                    cell.lbl_Hashtag3.text = String(format: "%@     ", arrOfTags[2].htag_text!)
                    cell.lbl_Hashtag4.text = String(format: "%@     ", arrOfTags[2].htag_text!)
                    
                    
                    self.manageDesignOftagsForHelpCell(help_Cell: cell)
                    self.manageTagsSizeForHelpCell(help_Cell: cell)
                    
                    
                }else  if arrOfTags.count >= 2 {
                    cell.lbl_Hashtag1.text = String(format: "%@     ", arrOfTags[0].htag_text!)
                    cell.lbl_Hashtag2.text = String(format: "%@     ", arrOfTags[1].htag_text!)
                    cell.lbl_Hashtag3.text = ""
                    
                    self.manageDesignOftagsForHelpCell(help_Cell: cell)
                    
                    
                }else  if arrOfTags.count >= 1 {
                    cell.lbl_Hashtag1.text = String(format: "%@     ", arrOfTags[0].htag_text!)
                    cell.lbl_Hashtag2.text = ""
                    cell.lbl_Hashtag3.text = ""
                    self.manageDesignOftagsForHelpCell(help_Cell: cell)
                }else {
                    cell.lbl_Hashtag1.text = ""
                    cell.lbl_Hashtag2.text = ""
                    cell.lbl_Hashtag3.text = ""
                    cell.bg_TagView_H.constant = 0
                    cell.lbl_Hashtag4.isHidden = true
                }
             return cell
        }
            
        
    }
    
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let countryList = arrOFShowData[indexPath.row]
        
        if(APP_Delegate().reqType){
            let postVC = storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
            postVC.ctyListObjFrmFeedVC = countryList
            postVC.isCameFrmNotiVC = false
            postVC.onHideComplete = {(isDelete : Bool) -> Void in
                if(isDelete){
                    self.arrOFShowData.remove(at: indexPath.row)
                    self.tbl_View.reloadData()
                }
            }
            navigationController?.pushViewController(postVC, animated: true)
        }else{
            let helpReqDetaliVC = storyboard?.instantiateViewController(withIdentifier: "HelpReqDetaliVC") as! HelpReqDetaliVC
            helpReqDetaliVC.postId = countryList.pst_id
            helpReqDetaliVC.ctylstObjFrmHelpVC = countryList
            
            helpReqDetaliVC.pstDeleteCallback = {(isDelete : Bool) -> Void in
                if(isDelete){
                    self.arrOFShowData.remove(at: indexPath.row)
                    self.tbl_View.reloadData()
                }
            }
            navigationController?.pushViewController(helpReqDetaliVC, animated: true)
        }
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableViewAutomaticDimension
      }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2000
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let VisibleRow = self.tbl_View.indexPathsForVisibleRows?.last?.row;
        let lastRowIndex : Int = self.arrOFShowData.count - 1
        if VisibleRow == lastRowIndex {
            if(Int(self.totalPostCount) != self.arrOFShowData.count){
                imgVw_MorePost.image = UIImage.gifImageWithName("DropDownArrowImg")
                self.bgViewOFMorePost_H.constant = 26
            }else{
                 self.bgViewOFMorePost_H.constant = 0
            }
        }else{
            self.bgViewOFMorePost_H.constant = 0
        }
    }
    


  
    func manageDesignOftagsFeedCell( feed_Cell : FeedCell ){
        feed_Cell.bg_TagView_H.constant = 26
        feed_Cell.lbl_Hashtag4.isHidden = true
        
        feed_Cell.lbl_Hashtag1.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        feed_Cell.lbl_Hashtag2.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        feed_Cell.lbl_Hashtag3.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        feed_Cell.lbl_Hashtag4.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        
         feed_Cell.lbl_Hashtag1.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
         feed_Cell.lbl_Hashtag2.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
         feed_Cell.lbl_Hashtag3.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
         feed_Cell.lbl_Hashtag4.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
    }
    
    func manageDesignOftagsForHelpCell( help_Cell : HelpCell ){
        
        help_Cell.bg_TagView_H.constant = 26
        help_Cell.lbl_Hashtag4.isHidden = true

        help_Cell.lbl_Hashtag1.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        help_Cell.lbl_Hashtag2.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        help_Cell.lbl_Hashtag3.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        help_Cell.lbl_Hashtag4.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor

        
        help_Cell.lbl_Hashtag1.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        help_Cell.lbl_Hashtag2.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        help_Cell.lbl_Hashtag3.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        help_Cell.lbl_Hashtag4.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
    }
    
    
    func manageTagsSize(feed_Cell : FeedCell ){
       
        //feed_Cell.bg_TagView.backgroundColor = UIColor.red
        let lbl_Hashtag1 = feed_Cell.lbl_Hashtag1.intrinsicContentSize.width
        let lbl_Hashtag2 = feed_Cell.lbl_Hashtag2.intrinsicContentSize.width
        let lbl_Hashtag3 = feed_Cell.lbl_Hashtag3.intrinsicContentSize.width

        
        if(feed_Cell.bg_TagView.frame.size.width < (lbl_Hashtag1 + lbl_Hashtag2 + lbl_Hashtag3)){
            feed_Cell.bg_TagView_H.constant = 50
            feed_Cell.lbl_Hashtag3.isHidden = true
            feed_Cell.lbl_Hashtag4.isHidden = false

      
        }else{
            feed_Cell.bg_TagView_H.constant = 26
            feed_Cell.lbl_Hashtag3.isHidden = false
            feed_Cell.lbl_Hashtag4.isHidden = true
        }
        
    }
    
    func manageTagsSizeForHelpCell(help_Cell : HelpCell ){
        
        //feed_Cell.bg_TagView.backgroundColor = UIColor.red
        let lbl_Hashtag1 = help_Cell.lbl_Hashtag1.intrinsicContentSize.width
        let lbl_Hashtag2 = help_Cell.lbl_Hashtag2.intrinsicContentSize.width
        let lbl_Hashtag3 = help_Cell.lbl_Hashtag3.intrinsicContentSize.width
        
        
        if(help_Cell.tag_View.frame.size.width < (lbl_Hashtag1 + lbl_Hashtag2 + lbl_Hashtag3)){
            help_Cell.bg_TagView_H.constant = 50
            help_Cell.lbl_Hashtag3.isHidden = true
            help_Cell.lbl_Hashtag4.isHidden = false
        }else{
            help_Cell.bg_TagView_H.constant = 26
            help_Cell.lbl_Hashtag3.isHidden = false
            help_Cell.lbl_Hashtag4.isHidden = true
        }
    }
    

    @objc func upAndDownVoteBtnAction(btn: UIButton){//Perform actions here
        if(isNetwork){
            self.upVoteAndDownVoteForPost(sender: btn)
        }else{
            
            ShowAlert(title: "Alert", message: "Please check your internet connection", controller: UIApplication.shared.keyWindow!.rootViewController!, cancelButton: nil, okButton: "Ok", style: .alert, callback: { (isOk, isCancel) in
                
            })
        }
    }
    
    /*
     1.usrToken->user token
     2.voteTyp->vote type (Post or Answer)
     3.voteId->Post or Answer id
 */
//========================================================
//MARK:- Call Service For Up and Down Votes
//========================================================
    func upVoteAndDownVoteForPost(sender : UIButton){
        
        sender.isUserInteractionEnabled = false
        
        let userData = getUserData()
        let countryList = arrOFShowData[sender.tag]
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let cell = self.tbl_View.cellForRow(at: indexPath) as! FeedCell
         DispatchQueue.main.async {
          self.getUpVoteCount(cell: cell, countryList: countryList)
        }
        

        let dict : Dictionary = ["usrToken" : userData["usr_token"],
                                 "voteTyp" : "Post",
                                 "voteId" : countryList.pst_id]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.upVoteAndDownVoteForPost, callBack: {[weak self] (response:Any ,isError:Bool) in
    
                
                guard let weakSelf = self else { return }
                
                guard !isError , (response as! [String : Any])["success"] as! Bool else {
                    killLoader()
                  
                    if(!isError && (response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                            DispatchQueue.main.async {
                                APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                                ShowError(message: (response as! [String : Any])["message"] as! String, controller: weakSelf)
                            }
                        }else{
                            sender.isUserInteractionEnabled = true
                            ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                            DispatchQueue.main.async {
                                weakSelf.getUpVoteCount(cell: cell, countryList: countryList)
                            }
                        }
                    return
                }

                
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    sender.isUserInteractionEnabled = true
                }
          })

     }

    
    
    func getUpVoteCount(cell : FeedCell , countryList: CountryList) {
        if( countryList.usr_upvote == "NO"){
    
            btnClickEvent(caregoryNm: "Hive Request", action: "Upvote Post", label: "")
            cell.imgViewOfVotes.image = UIImage(named: "up_Active")
            cell.lbl_VotesCount.text = String(format: "%d",(Int(cell.lbl_VotesCount.text!)! + 1))
            countryList.upvote_count =  cell.lbl_VotesCount.text
            countryList.usr_upvote  = "YES"
            
        }else{
              btnClickEvent(caregoryNm: "Hive Request", action: "Downvote Post", label: "")
              cell.imgViewOfVotes.image = UIImage(named: "up_1x")
              cell.lbl_VotesCount.text = String(format: "%d",(Int(cell.lbl_VotesCount.text!)! - 1))
              countryList.upvote_count =  cell.lbl_VotesCount.text
              countryList.usr_upvote  = "NO"

        }
        self.tbl_View.reloadData()
    }
    
//========================================================
//MARK:- Call Service For GetAll Hive Post
//========================================================

    func getHiveReqAllPostAtPopTime(_ notification: Any ){
        APP_Delegate().isRefreshFeedVClist = false
        btn_Sagment.selectedSegmentIndex = 0
        
        self.tbl_View.isHidden = true
        if (UserDefaults.standard.value(forKey: "HiveReq_Id") != nil) {
            
          self.isNoMoreData = false
          showLoader(view: self.view)
           //if(!APP_Delegate().isFltEnable){
                // Remove All Arr And FltArray When Add New Post
                self.arrOFShowData.removeAll()
                self.FltArrOfAcyNmOrLoctNm.removeAll()
                self.FltArrOfScatIds.removeAll()
                self.FltArrOfScatNm.removeAll()
                self.FltArrOfTags.removeAll()
                
                // Remove Flt Count
                self.lbl_Feed.textColor = UIColor(red: 5/255, green: 163/255, blue: 164/255, alpha: 1)
                self.lbl_Filter.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
                self.manageFltCountOfFilterLabel()
            
           // }

            let userData = getUserData()
            let dict : Dictionary = ["usrToken" : userData["usr_token"],
                                     "catId" :  UserDefaults.standard.value(forKey: "HiveReq_Id"),
                                     "activity" : "" ,
                                     "scatId" : "",
                                     "tags" : "" ,
                                     "limit" : "10",
                                     "page" : self.arrOFShowData.count,
                                     "grpId" : "",
                                     "pstId" : "",
                                     "trndPst" : ""]
            
            ServerCommunicator(params: dict as Any as? Dictionary<String, Any> , service: Service.getUserHiveReqPost, callBack: { [weak self] (response:Any ,isError:Bool) in
                
              guard let weakSelf = self else { return }
              guard !isError, (response as! [String : Any])["success"] as! Bool else {
                 killLoader()
                // Remove Refresh Controller
                 weakSelf.removeRefreshLoader()
                 if( !isError &&  (response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                        DispatchQueue.main.async {
                            APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                            ShowError(message: (response as! [String : Any])["message"] as! String, controller: weakSelf)
                            killLoader()
                        }
                    }else{
                        DispatchQueue.main.async {
                            if (weakSelf.arrOFShowData.count==0 && response != nil){
                                weakSelf.tbl_View.isHidden = true
                                weakSelf.bgalertView.isHidden = false
                            }
                            killLoader()
                        }
                    }
                return
            }
                
                
                
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                        weakSelf.arrOFShowData =  (countryResponseBody?.data)!
                     //  print("RESPONSE ==",response)

                        DispatchQueue.main.async {
                            if let count = countryResponseBody?.total_count{
                                weakSelf.totalPostCount = count
                            }
                            
                            weakSelf.btn_Sagment.selectedSegmentIndex = APP_Delegate().reqType! ? 0 : 1
                            killLoader()
                            weakSelf.tbl_View.isHidden = false
                            weakSelf.bgalertView.isHidden = true
                            weakSelf.removeRefreshLoader()
                            weakSelf.tbl_View.reloadData()
                            weakSelf.moveAutomaticallyOnTopOFTableView()
                        }
                })
        }else{
                killLoader()
        }
    }
    
    
    func moveAutomaticallyOnTopOFTableView(){

          self.tbl_View.reloadData()
          self.tbl_View.setContentOffset(CGPoint.zero, animated: true)
    
    }
    
//========================================================
//MARK:- Call Service For GetAll Hive Post
//========================================================
    /*
    1.usrToken->user token
    2.catId->category id
    3.activity->(UPVOTE or COMMENT)
    4.scatId->string(1,2,3)
    5.tags->array('sport','demo')
    6.limit->limit
    7.page->page
     
    trndPst -> TREND
    */
    
    
    func getHiveReqAllPost(arrOfActyOrLoctNm : [Any] , arrOfScatIds : [Any], arrOfTags: [Any]){
         APP_Delegate().isRefreshFeedVClist = false
        if (UserDefaults.standard.value(forKey: "HiveReq_Id") != nil) {
            let userData = getUserData()
            let dict : Dictionary = ["usrToken" : userData["usr_token"],
                                     "catId" :  UserDefaults.standard.value(forKey: "HiveReq_Id"),
                                     "activity" : arrOfActyOrLoctNm.count == 0 ? "" : (arrOfActyOrLoctNm[0] as? String == "Most upvotes" ? "UPVOTE" : "COMMENT"),
                                     "scatId" : arrOfScatIds.count == 0 ? "" : arrOfScatIds ,
                                     "tags" : arrOfTags.count == 0 ? "" : arrOfTags ,
                                     "limit" : "10",
                                     "page" : self.arrOFShowData.count,
                                     "grpId" : "",
                                     "pstId" : "",
                                     "trndPst" : ""]
            
           
            
            ServerCommunicator(params: dict as Any as? Dictionary<String, Any> , service: Service.getUserHiveReqPost, callBack: { [weak self] (response:Any ,isError:Bool) in
                if(!isError){
        
                    
                     if((response as! [String : Any])["success"] as! Bool == false){
                        if((response as! [String : Any])["message"] as! String == "Deactive" ){
                            DispatchQueue.main.async {
                                APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                            }
                            return
                        }
                    }
                    
                    
                    guard let weakSelf = self else { return }
                    if((response as! [String : Any])["success"] as! Bool){
                        DispatchQueue.main.async {
                           // print("RESPONSE ==",response)
                             weakSelf.tbl_View.isHidden = false
                             weakSelf.bgalertView.isHidden = true
                            let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                             weakSelf.arrOFShowData += (countryResponseBody?.data!)!
                            if let count = countryResponseBody?.total_count{
                                weakSelf.totalPostCount = count
                            }
                             weakSelf.removeRefreshLoader()
                             weakSelf.tbl_View.reloadData()
                             killLoader()
                        }
                    }else{
                        if((response as! [String : Any])["message"] as! String == "Deactive" ){
                            DispatchQueue.main.async {
                                APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                            }
                            return
                        }
                        
                        if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                            DispatchQueue.main.async {
                                APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                                ShowError(message: (response as! [String : Any])["message"] as! String, controller: weakSelf)
                            }
                        }else{
                            
                            DispatchQueue.main.async {
                                killLoader()
                                if(weakSelf.arrOFShowData.count > 0){
                                    weakSelf.isNoMoreData = true
                                    weakSelf.showToastForMoreData(message: "No more data", width: 120)
                                }else{
                                    DispatchQueue.main.async {
                                        if (weakSelf.arrOFShowData.count==0){
                                            weakSelf.tbl_View.isHidden = true
                                            weakSelf.bgalertView.isHidden = false
                                           // weakSelf.lbl_Commt.text = (response as! [String : Any])["message"]  as? String
                                        }
                                    }
                                }
                                weakSelf.removeRefreshLoader()
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        
                        self?.bgalertView.isHidden = true
                        killLoader()
                        // Remove Refresh Controller
                        self?.removeRefreshLoader()
                        ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                         })
                    }
                }
            })
        }
    }
    
//===============================================================================
// MARK:-Call Service For Get Main Category list and also called get all feed post
//===============================================================================
    
//    func getMainCategoryListByNotificationCenter(_ notification: NSNotification){
//        self.getMainCategorylistMethod()
//    }
//    
//    
//    func getMainCategoryListWithoutNotificationCenter(){
//        self.getMainCategorylistMethod()
//    }
    
    
    func getMainCategorylistMethod(){
       
    if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {

        showLoader(view: self.view)
        let userData = getUserData()
        let dict : Dictionary = ["usrToken" : userData["usr_token"]]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getMaincategoryList, callBack: {(response:Any ,isError:Bool) in
            if(!isError){
                if((response as! [String : Any])["success"] as! Bool){
                    DispatchQueue.main.async {
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                
                        UserDefaults.standard.set(countryResponseBody?.data?[1].cat_id, forKey: "HelpReq_Id")
                        UserDefaults.standard.set(countryResponseBody?.data?[0].cat_id, forKey: "HiveReq_Id")
                        
//                       if(countryResponseBody?.count != "0"){
//                            self.tabBarController?.tabBar.items?[3].badgeValue = countryResponseBody?.count
//                            if #available(iOS 10.0, *) {
//                                self.tabBarController?.tabBar.items?[3].badgeColor = UIColor(red: 4/255, green: 163/255, blue: 163/255, alpha: 1)
//                            }
//                        }else{
//                            self.tabBarController?.tabBar.items?[3].badgeValue  = nil
//                        }
                        //self.getAdminDetail()

                        self.btn_Sagment.selectedSegmentIndex = 0
                        self.getHiveReqAllPost(arrOfActyOrLoctNm:  self.FltArrOfAcyNmOrLoctNm.count != 0 ? self.FltArrOfAcyNmOrLoctNm : [], arrOfScatIds: self.FltArrOfScatIds.count != 0 ? self.FltArrOfScatIds : [], arrOfTags: self.FltArrOfTags.count != 0 ? self.FltArrOfTags : [])
                    
                        
                        self.GetTotalKrmPoints()
                    }
                }else{
                    
                    if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self.tabBarController as? TabBarController)!)
                        }
                        return
                    }
                    
//
                    
                   killLoader()
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                        DispatchQueue.main.async {
                            APP_Delegate().tokenExpired(controller: (self.tabBarController as? TabBarController)!)
                            ShowError(message: (response as! [String : Any])["message"] as! String, controller: self)
                        }
                    }else{
                      ShowError(message: (response as! [String : Any])["message"] as! String, controller: self)
                    }
                }
            }else{
                killLoader()
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
        }else{
            APP_Delegate().tokenExpired(controller: self)
        }
    }
    
//========================================================
//MARK:- Remove Array At Logout
//========================================================
    func removeFeedArrAtLogOut(_ notification: Any ){
        // Remove All Arr And FltArray When Add New Post
        self.arrOFShowData.removeAll()
        self.FltArrOfAcyNmOrLoctNm.removeAll()
        self.FltArrOfScatIds.removeAll()
        self.FltArrOfScatNm.removeAll()
        self.FltArrOfTags.removeAll()
        
    }
    
//========================================================
//MARK:- Call Service For GetAll Help Req Post At Pop Time
//========================================================
    func HelpReqAllPostAtPopTime(_ notification: Any ){
        
        btn_Sagment.selectedSegmentIndex = 1

         self.isNoMoreData  = false
         self.tbl_View.isHidden = true

//        if(self.arrOFShowData.count > 0){
//            let indexPath = IndexPath(row: 0, section: 0)
//            self.tbl_View.scrollToRow(at: indexPath, at: .top, animated: true)
//        }
        
        // Remove All Arr And FltArray When Add New Post
        self.arrOFShowData.removeAll()
        self.FltArrOfAcyNmOrLoctNm.removeAll()
        self.FltArrOfScatIds.removeAll()
        self.FltArrOfScatNm.removeAll()
        self.FltArrOfTags.removeAll()
        
        // Remove Flt Count
        self.lbl_Feed.textColor = UIColor(red: 5/255, green: 163/255, blue: 164/255, alpha: 1)
        self.lbl_Filter.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        self.manageFltCountOfFilterLabel()
        tbl_View.reloadData()
        
        self.getAllHelpReqPost(arrOfActyOrLoctNm: [], arrOfScatIds: [], arrOfTags: [])
        
        self.moveAutomaticallyOnTopOFTableView()
    }
    
//========================================================
//MARK:- Call Service For GetAll Help Req Post
//========================================================
   /*
     1.usrToken->user token
    2.catId->category id
    3.helpTyp->help type('Location', 'Virtual')
    4.scatId->array(1,2,3)
    5.tags->array('sport','demo')
    6.limit->limit
    7.page->page
   
    */
    
    func getAllHelpReqPost(arrOfActyOrLoctNm : [Any] , arrOfScatIds : [Any], arrOfTags: [Any]){
        
        if (UserDefaults.standard.value(forKey: "HelpReq_Id") != nil) {
            
            let userData = getUserData()
            let dict : Dictionary = ["usrToken" : userData["usr_token"],
                                     "catId" :  UserDefaults.standard.value(forKey: "HelpReq_Id"),
                                     "helpTyp" : arrOfActyOrLoctNm.count == 0 ? "" : (arrOfActyOrLoctNm[0] as? String),
                                     "scatId" : arrOfScatIds.count == 0 ? "" : arrOfScatIds  ,
                                     "tags" : arrOfTags.count == 0 ? "" : arrOfTags,
                                     "limit" : "10",
                                     "page" : self.arrOFShowData.count,
                                      ]
            
           // "currentDate" : convertSystemDateIntoLocalTimeZone(date: Date())
            ServerCommunicator(params: dict as Any as? Dictionary<String, Any> , service: Service.getUserHelpReqPost, callBack: {[weak self] (response:Any ,isError:Bool) in
                
                guard let weakSelf = self else { return }

                if(!isError){
                    let dictResponse = response as! NSDictionary
                    if(dictResponse["success"] as! Bool){
                        let resultData = dictResponse["data"]
                        print("RESPONSE ==",resultData!)
                        
                        if(dictResponse["data"] != nil){
                           
                            DispatchQueue.main.async {
                                weakSelf.bgalertView.isHidden = true
                                weakSelf.tbl_View.isHidden = false
                                let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                                 print(countryResponseBody!)
                                
                                weakSelf.arrOFShowData +=  (countryResponseBody?.data)!
                                
                                weakSelf.totalPostCount = countryResponseBody?.total_count

                                //===========================================
                                if(APP_Delegate().reqType){ //for  when pop from create post which post is visible
                                    weakSelf.btn_Sagment.selectedSegmentIndex = 0
                                }else{
                                    weakSelf.btn_Sagment.selectedSegmentIndex = 1
                                }
                                
                                weakSelf.removeRefreshLoader()
                                weakSelf.tbl_View.reloadData()
                                killLoader()
                            }
                        }
                    }else{
                        
                       if((response as! [String : Any])["message"] as! String == "Deactive" ){
                            DispatchQueue.main.async {
                                APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                               }
                        return

                        }
                        
                        killLoader()
                        // Remove Refresh Controller
                        weakSelf.removeRefreshLoader()
                        
                        DispatchQueue.main.async {
                            weakSelf.tbl_View.isHidden = false
                        }

                        if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                            DispatchQueue.main.async {
                                APP_Delegate().tokenExpired(controller: (self?.tabBarController as? TabBarController)!)
                                ShowError(message: (response as! [String : Any])["message"] as! String, controller: self!)
                            }
                        }else{
                            DispatchQueue.main.async {
                                if(weakSelf.arrOFShowData.count > 0){
                                    weakSelf.isNoMoreData = true
                                    weakSelf.showToastForMoreData(message: "No more data", width: 120)
                                }else{
                                    DispatchQueue.main.async {
                                        if (weakSelf.arrOFShowData.count==0){
                                            weakSelf.tbl_View.isHidden = true
                                            weakSelf.bgalertView.isHidden = false
                                          //  weakSelf.lbl_Commt.text = (response as! [String : Any])["message"]  as? String
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        killLoader()
                        // Remove Refresh Controller
                        weakSelf.removeRefreshLoader()
                        
                        weakSelf.tbl_View.isHidden = true
                        weakSelf.bgalertView.isHidden = true
                        ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: weakSelf, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                        })
                    }
                }
            })
        }else{
            DispatchQueue.main.async {
                self.arrOFShowData.removeAll()
                self.tbl_View.reloadData()
            }
        }
    }
    
    
    //==========================================================
    //MARK:- Call Service To GetTotalKrmPoints At Notification
    //==========================================================
    
    func getTotalKrmPointsUsingNotificationCenter(_ notification: NSNotification){
        self.GetTotalKrmPoints()
    }
    //====================================================
    //MARK:- Call Service To GetTotalKrmPoints
    //====================================================
    /*
     1.usrToken->user token
     2.count->send some value if you want to get total count else blank
     3.helpId->help cat id
     
     */
    func GetTotalKrmPoints() {
        
               // showLoader(view: self.view)
                let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                         "count" : "TOTALCOUNT",
                                         "helpId" : UserDefaults.standard.value(forKey: "HelpReq_Id") as! String,
                                         "hiveId" : UserDefaults.standard.value(forKey: "HiveReq_Id") as! String,
                                         "usrId" : getUserData()["usr_id"] as? String]
                
                ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.getKrmPotsActsList , callBack: { [weak self] (response:Any ,isError: Bool) in
                    
                    guard let weakSelf = self else { return }
                    
                    
                    
                    
                    
                    guard !isError , (response as! [String : Any])["success"] as! Bool else {
                        
                    killLoader()
                        ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                        return
                    }
                    
                DispatchQueue.main.async {
                    if((response as! [String : Any])["count"] as? String != "0"){
                       
                           
                            if(UserDefaults.standard.value(forKey: "ShowNotificationCount") as? String == "YES" || UserDefaults.standard.value(forKey: "ShowNotificationCount") == nil){
                                weakSelf.tabBarController?.tabBar.items?[3].badgeValue = (response as! [String : Any])["count"] as? String
                                if #available(iOS 10.0, *) {
                                    weakSelf.tabBarController?.tabBar.items?[3].badgeColor = UIColor(red: 4/255, green: 163/255, blue: 163/255, alpha: 1)
                                }
                                
                            }else{
                              
                              weakSelf.tabBarController?.tabBar.items?[3].badgeValue  = nil
                            }
                          
                        
                      }else{
                        weakSelf.tabBarController?.tabBar.items?[3].badgeValue  = nil
                      }
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        killLoader()
                        UserDefaults.standard.set( (response as! [String : Any])["data"] as? String, forKey: "TotalKMPoints")
                        weakSelf.lbl_ShowKMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
                        NotificationCentreClass.fireRefreshKarmaPointsNotifier()
                    }
                })
    }
    
//========================================================
//MARK:-Manage FltCount Of FilterLabel
//========================================================
    func manageFltCountOfFilterLabel(){
      if(self.FltArrOfScatNm.count == 0 && self.FltArrOfAcyNmOrLoctNm.count == 0 && self.FltArrOfTags.count == 0 ){
            self.lbl_Filter.text = "Filter"
        }else if (self.FltArrOfScatNm.count != 0 && self.FltArrOfAcyNmOrLoctNm.count == 0 && self.FltArrOfTags.count == 0){
         
            self.lbl_Filter.text = "Filter(1)"
            
        }else if (self.FltArrOfScatNm.count != 0 && self.FltArrOfAcyNmOrLoctNm.count != 0 && self.FltArrOfTags.count == 0){
            
            self.lbl_Filter.text = "Filter(2)"
            
        }else if (self.FltArrOfScatNm.count != 0 && self.FltArrOfAcyNmOrLoctNm.count != 0 && self.FltArrOfTags.count != 0){
       
            self.lbl_Filter.text = "Filter(3)"
            
        }else if (self.FltArrOfScatNm.count == 0 && self.FltArrOfAcyNmOrLoctNm.count != 0 && self.FltArrOfTags.count == 0){
           
            self.lbl_Filter.text = "Filter(1)"
            
        }else if (self.FltArrOfScatNm.count != 0 && self.FltArrOfAcyNmOrLoctNm.count != 0 && self.FltArrOfTags.count == 0){
        
            self.lbl_Filter.text = "Filter(2)"
            
        }else if (self.FltArrOfScatNm.count == 0 && self.FltArrOfAcyNmOrLoctNm.count != 0 && self.FltArrOfTags.count != 0){
           
            self.lbl_Filter.text = "Filter(2)"
            
        }else if (self.FltArrOfScatNm.count == 0 && self.FltArrOfAcyNmOrLoctNm.count == 0 && self.FltArrOfTags.count != 0){
         
            self.lbl_Filter.text = "Filter(1)"
            
        }else if (self.FltArrOfScatNm.count != 0 && self.FltArrOfAcyNmOrLoctNm.count == 0 && self.FltArrOfTags.count != 0){
           
            self.lbl_Filter.text = "Filter(2)"
            
        }else if (self.FltArrOfScatNm.count == 0 && self.FltArrOfAcyNmOrLoctNm.count != 0 && self.FltArrOfTags.count != 0){
   
            self.lbl_Filter.text = "Filter(2)"
            
        }
        
    }

}   


