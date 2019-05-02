//
//  NotificationHomeVC.swift
//  Community
//
//  Created by Hatshit on 26/02/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
class NotificationHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate {
   
    
    @IBOutlet var imgVw_MorePost: UIImageView!
    
    var totalNotiyCount : String!
    var arrOFShowData = [CountryList]()
    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    var lbl_ShowKMPoints : UILabel!
    var isNoMoreData = false
    var isRemove = false
    @IBOutlet weak var lbl_Alert: UILabel!
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet var bgViewOFMorePost_H: NSLayoutConstraint!

    @IBOutlet var bgViewOFMorePost: UIView!
    override func viewDidLoad() {
         super.viewDidLoad()
        
      NotificationCentreClass.registerRemoveArrayOfNotificationVCNotifier(vc: self, selector: #selector(self.removeNotificationVCArrayAtLogOut(_:)))

         NotificationCentreClass.registerRefreshNotificationScreen(vc: self, selector: #selector(self.getNotificationList))
        
        NotificationCentreClass.registerRefreshKarmaPointsNotifier(vc: self, selector: #selector(self.refreshKarmapoints))

        
    //============add Right Navi Btn===============
        self.addButtonsOnRightSideOfNavigationBar()
        
        
         self.lbl_Alert.isHidden = true
         showLoader(view: self.view)
         self .addRefreshController()
        // self.getNotificationList()

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set("NO", forKey: "ShowNotificationCount")
        if(arrOFShowData.count == 0){
             self.getNotificationList()
        }else{
            self.table_View.reloadData()
        }
  
         self.setUpOfTabBar()
        //self.table_View.reloadData()
    }
    
    
    func setUpOfTabBar(){
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.items?[3].badgeValue  = nil

            self.tabBarController?.tabBar.isHidden = false
            let arrOfviews = self.tabBarController?.view.subviews
            for view in arrOfviews!{
                if view.isKind(of: UIButton.self) {
                    view.isHidden = false
                }
            }
        }
    }
    
    
    func removeNotificationVCArrayAtLogOut(_ notification: Any ){
        self.isRemove = true
        arrOFShowData.removeAll()
        
    }
    
    func refreshKarmapoints(_ notification: Any){
        if(UserDefaults.standard.value(forKey: "TotalKMPoints") != nil){
            lbl_ShowKMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
        }else{
            lbl_ShowKMPoints.text = "0"
        }
        
        APP_Delegate().lbl_KMPoints = lbl_ShowKMPoints
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
    
    //================================
    //MARK:- Karma Points Btn Action Method
    //================================
    @objc func KrmapointsBtnAction(btn: UIButton){//Perform actions here
        
        btnClickEvent(caregoryNm: "Karma Points", action: "Clicked Karma Points", label: "")
        
        let karmaPointsVC = storyboard?.instantiateViewController(withIdentifier: "KARMAPOINTSVC") as! KarmaPointsVC
        
        navigationController?.pushViewController(karmaPointsVC, animated: true)
        
    }
    
//================================
//MARK:-  Add Refresh Controller
//================================
    
    func addRefreshController(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(pullToDownRefresh), for: UIControlEvents.valueChanged)
        self.table_View.addSubview(refreshControl)

        pullUpRefeshControl.triggerVerticalOffset = 100;
        pullUpRefeshControl.addTarget(self, action: #selector(pullUpRefreshMethod), for: UIControlEvents.valueChanged)
        self.table_View.bottomRefreshControl = pullUpRefeshControl;
    }
    
    
    
    func pullToDownRefresh() -> Void {
        self.isNoMoreData = false
        isRemove = true
        DispatchQueue.main.async {
         self.arrOFShowData.removeAll()
         self.table_View.reloadData()
         self.getNotificationList()
        }
    }
    
    func pullUpRefreshMethod(){
            self.getNotificationList()
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
        return arrOFShowData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "NotifyHomeCell"
        var cell: NotifyHomeCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotifyHomeCell
        if cell == nil {
            tableView.register(UINib(nibName: "NotifyHomeCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotifyHomeCell
        }
        
         self.bgViewOFMorePost_H.constant = 0
        let countryList = self.arrOFShowData[indexPath.row]
        cell.setUpOfCellMethod(countryList: countryList)


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         self.changeNotificationStatus(idx: indexPath.row);
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 3000
    }
    
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let VisibleRow = self.table_View.indexPathsForVisibleRows?.last?.row;
        let lastRowIndex : Int = self.arrOFShowData.count - 1
        if VisibleRow == lastRowIndex {

            if(Int(self.totalNotiyCount) != arrOFShowData.count){
                imgVw_MorePost.image = UIImage.gifImageWithName("DropDownArrowImg")
                self.bgViewOFMorePost_H.constant = 26
            }else{
                 self.bgViewOFMorePost_H.constant = 0
            }
        }else{
            self.bgViewOFMorePost_H.constant = 0
        }
    }
    
    //========================================================
    // MARK:- Call SerVice For Get Notification List
    //========================================================

    func getNotificationList(){
        
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "limit" :  "10",
                                 "page" : self.isRemove == true ? 0 : self.arrOFShowData.count]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.getNotificationList , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                if(!isError){
                    
                    if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                        }
                        return
                    }
                    
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                           APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                        }
                        return
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: (self?.tabBarController as? TabBarController)!)
                           
                        }
                         return
                    }else{
                        if(weakSelf.arrOFShowData.count > 0){
                                weakSelf.isNoMoreData = true
                                weakSelf.showToastForMoreData(message: "No more data", width: 120)
                                // Remove Refresh Controller
                                weakSelf.removeRefreshLoader()
                            return
                        }else{
                            DispatchQueue.main.async {
                                killLoader()
                                weakSelf.lbl_Alert.isHidden = false
                                weakSelf.lbl_Alert.text = "You currently have no notifications."
                                // Remove Refresh Controller
                                weakSelf.removeRefreshLoader()
                            }
                            return
                        }
                    }
                }else{
                    killLoader()
                    weakSelf.lbl_Alert.isHidden = true
                    ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                    // Remove Refresh Controller
                    weakSelf.removeRefreshLoader()
                }
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                weakSelf.lbl_Alert.isHidden = true
                // Remove Refresh Controller
                weakSelf.removeRefreshLoader()
                
                
                if (self?.isRemove == true){
                    self?.isRemove = false
                    weakSelf.arrOFShowData.removeAll()
                }
                
                 print(response)
                let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                   weakSelf.arrOFShowData +=  (countryResponseBody?.data)!
                if let count = countryResponseBody?.total_count{
                    weakSelf.totalNotiyCount = count
                }
                weakSelf.table_View.reloadData()
            }
        })
    }
    
    //========================================================
    // MARK:- Call SerVice For Get Notification List
    //========================================================
    /*
     1.usrToken->user token
     2.pstId->post id
     3.ntfyType->sub type
     3.pstType->(HIVE or HELP)
    
     */
    func changeNotificationStatus(idx : Int){
        
        let countryList = arrOFShowData[idx]
        
        if(countryList.ntfy_type == "HIVE_UPVOTE" || countryList.ntfy_type == "HIVE_COMMENT" || countryList.ntfy_type == "COMMENT_UPVOTE" || countryList.ntfy_type == "COMMENT_GREAT"){
            let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
            postVC.ctyListObjFrmFeedVC = countryList
            postVC.isCameFrmNotiVC = true
            navigationController?.pushViewController(postVC, animated: true)
        }else if(countryList.ntfy_type == "HELP_REQUEST" || countryList.ntfy_type == "HELP_RXPIRE"){
            let helpReqDetaliVC = self.storyboard?.instantiateViewController(withIdentifier: "HelpReqDetaliVC") as! HelpReqDetaliVC
            helpReqDetaliVC.postId = countryList.pst_id
            helpReqDetaliVC.ctylstObjFrmHelpVC = countryList
            helpReqDetaliVC.pstDeleteCallback = {(isDelete : Bool) -> Void in
                if(isDelete){
                    //self.arrOFShowData.remove(at: indexPath.row)
                    // self.tbl_View.reloadData()
                }
            }
            navigationController?.pushViewController(helpReqDetaliVC, animated: true)
        }else{
            let karmaPointsVC = self.storyboard?.instantiateViewController(withIdentifier: "KARMAPOINTSVC") as! KarmaPointsVC
            navigationController?.pushViewController(karmaPointsVC, animated: true)
        }
        
        
        
        if countryList.ntfy_isRead == "0" {
            
            countryList.ntfy_isRead = "1"
            
            let badgeCount : Int = self.tabBarController?.tabBar.items?[3].badgeValue == nil ? 0 : Int((self.tabBarController?.tabBar.items?[3].badgeValue)!)! - 1
            if(badgeCount != 0){
                self.tabBarController?.tabBar.items?[3].badgeValue = "\(badgeCount)"
                if #available(iOS 10.0, *) {
                    self.tabBarController?.tabBar.items?[3].badgeColor = UIColor(red: 4/255, green: 163/255, blue: 163/255, alpha: 1)
                }
            }else{
                self.tabBarController?.tabBar.items?[3].badgeValue  = nil
            }
            
            
            
            //Service for update notification Status
            let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                     "pstId" :  countryList.pst_id,
                                     "ntfyType" : countryList.ntfy_type,
                                     "pstType" : countryList.ntfy_pst_type,
                                     "ntfyId" : countryList.ntfy_id]
            
            ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.changeNotificationStatus , callBack: { [weak self] (response:Any ,isError: Bool) in

                guard !isError , (response as! [String : Any])["success"] as! Bool else {
                    killLoader()
                    ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                    return
                }
            })
        }
    }

}//END
