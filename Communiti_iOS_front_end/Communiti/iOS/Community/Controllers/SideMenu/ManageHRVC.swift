//
//  ManageHRVC.swift
//  Community
//
//  Created by Hatshit on 10/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class ManageHRVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate {
    
    @IBOutlet weak var lbl_Alert: UILabel!
    var endReqAlert = EndReqAlert()
    var helpedUsrLstVw = HelpedUserListView()
    var arrOfData = [CountryList]()
    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    var isRefresh = false
    //var pageCount = 1
    var isRemove = false
    var selectedBtn : UIButton!

    @IBOutlet weak var btnEndReq: UIButton!
    @IBOutlet weak var btnActiveReq: UIButton!
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet weak var btn_Segment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(view: self.view)
        self.setUpView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
          self.table_View.reloadData()
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

//================================
//MARK:-  Set Up data Method
//================================
    
    func setUpView(){
        
        // Add Refresh Controler
        self.addRefreshController()
        
        // inital set 0 idx and selected btn
        btn_Segment.selectedSegmentIndex = 0
        self.selectedBtn = btnActiveReq
    
        // call service
        self.manageMyOrOtherHelpRequest(user_Id: getUserData()["usr_id"] as! String, completedStatus: "No")
        
        self.btnActiveReq.setTitleColor(theamColor(red:5,green: 163 ,blue: 164) , for: UIControlState.normal)
        self.btnEndReq.setTitleColor(UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1), for: UIControlState.normal)

        
        btn_Segment.layer.borderColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1).cgColor
        btn_Segment.layer.borderWidth = 1.0
        
        let inactive = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
        
        let yourAttributes1 = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: Font.QuicksandRegular(fontSize: 14.0)]
        btn_Segment.setTitleTextAttributes(yourAttributes1, for: UIControlState.selected)
        let yourAttributes2 = [NSForegroundColorAttributeName: inactive, NSFontAttributeName: Font.QuicksandRegular(fontSize: 14.0)]
        btn_Segment.setTitleTextAttributes(yourAttributes2, for: UIControlState.normal)
    }
    
    
//================================
//MARK:-  Add Refresh Controller
//================================
    
    func addRefreshController(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(pullToDownRefresh), for: UIControlEvents.valueChanged)
        
        
        pullUpRefeshControl.triggerVerticalOffset = 100;
        pullUpRefeshControl.addTarget(self, action: #selector(pullUpRefreshMethod), for: UIControlEvents.valueChanged)
        self.table_View.bottomRefreshControl = pullUpRefeshControl;
        self.table_View.addSubview(refreshControl)
         //not required when using UITableViewController
    }
    
    func pullToDownRefresh() -> Void {
        //self.pageCount = 1
        //self.arrOfData.removeAll()
        isRemove = true
       managePageCountForUpAndDownRefresh(sender: self.selectedBtn)
    }
    
    func pullUpRefreshMethod(){
         //self.pageCount = self.pageCount + 1
           managePageCountForUpAndDownRefresh(sender: self.selectedBtn)
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
    
    
    func  managePageCountForUpAndDownRefresh(sender : UIButton){
        
        //self.pageCount = 1
        
        if(btn_Segment.selectedSegmentIndex == 0){
            if (sender.tag == 0){
                self.btnActiveReq.setTitleColor(theamColor(red:5,green: 163 ,blue: 164) , for: UIControlState.normal)
                self.btnEndReq.setTitleColor(UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1), for: UIControlState.normal)
                
                //showLoader(view: self.view)
                self.manageMyOrOtherHelpRequest(user_Id :getUserData()["usr_id"] as! String,completedStatus: "No")
                
            }else{
                
                self.btnActiveReq.setTitleColor(UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1), for: UIControlState.normal)
                self.btnEndReq.setTitleColor(theamColor(red:5,green: 163 ,blue: 164) , for: UIControlState.normal)
                
                //showLoader(view: self.view)
                self.manageMyOrOtherHelpRequest(user_Id :getUserData()["usr_id"] as! String,completedStatus: "Yes")
            }
        }else{
            
            if (sender.tag == 0){
                self.btnActiveReq.setTitleColor(theamColor(red:5,green: 163 ,blue: 164) , for: UIControlState.normal)
                self.btnEndReq.setTitleColor(UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1), for: UIControlState.normal)
                
                //showLoader(view: self.view)
                self.manageMyOrOtherHelpRequest(user_Id : "",completedStatus: "No")
                
            }else{
                self.btnActiveReq.setTitleColor(UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1), for: UIControlState.normal)
                self.btnEndReq.setTitleColor(theamColor(red:5,green: 163 ,blue: 164) , for: UIControlState.normal)
                
                
                //showLoader(view: self.view)
                self.manageMyOrOtherHelpRequest(user_Id : "",completedStatus: "Yes")
            }
            
        }
        
    }
    
    
    @IBAction func segmentBtnAction(_ sender: UISegmentedControl) {
        self.arrOfData.removeAll()
        table_View.reloadData()
        showLoader(view: self.view)
        managePageCountForUpAndDownRefresh(sender: self.selectedBtn)
    }
    
    
    @IBAction func btnActionMethod(_ sender: UIButton) {
        
         self.arrOfData.removeAll()
         table_View.reloadData()
         selectedBtn = sender
        
        if(btn_Segment.selectedSegmentIndex == 0){
            if (sender.tag == 0){
                self.btnActiveReq.setTitleColor(theamColor(red:6,green: 163 ,blue: 164) , for: UIControlState.normal)
                self.btnEndReq.setTitleColor(UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1), for: UIControlState.normal)
                
                showLoader(view: self.view)
                self.manageMyOrOtherHelpRequest(user_Id :getUserData()["usr_id"] as! String,completedStatus: "No")
                
            }else{
                self.btnActiveReq.setTitleColor(UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1), for: UIControlState.normal)
                self.btnEndReq.setTitleColor(theamColor(red:5,green: 163 ,blue: 164) , for: UIControlState.normal)
    
                showLoader(view: self.view)
                self.manageMyOrOtherHelpRequest(user_Id :getUserData()["usr_id"] as! String,completedStatus: "Yes")
            }
        }else{
            
            if (sender.tag == 0){
                self.btnActiveReq.setTitleColor(theamColor(red:5,green: 163 ,blue: 164) , for: UIControlState.normal)
                self.btnEndReq.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                
                showLoader(view: self.view)
                self.manageMyOrOtherHelpRequest(user_Id : "",completedStatus: "No")
                
            }else{
                self.btnActiveReq.setTitleColor(UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1), for: UIControlState.normal)
                self.btnEndReq.setTitleColor(theamColor(red:5,green: 163 ,blue: 164
                ) , for: UIControlState.normal)
              
                showLoader(view: self.view)
                self.manageMyOrOtherHelpRequest(user_Id : "",completedStatus: "Yes")
            }
            
        }
    }
 
//=====================================
//MARK:-  Table View Delegate Method
//=====================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOfData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ManageHRCell"
        var cell: ManageHRCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ManageHRCell
        if cell == nil {
            tableView.register(UINib(nibName: "ManageHRCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ManageHRCell
        }
        

        
        let countryList = arrOfData[indexPath.row]
        cell.lbl_taskName.text = countryList.pst_title?.capitalizingFirstLetter()
        cell.lbl_CatName.text = String(format: "#%@     ",countryList.scat_title!)
        cell.btnEndReqOfMyReq.isHidden = true
        
        if(btn_Segment.selectedSegmentIndex == 0 && selectedBtn.tag == 0){
            
            cell.btnEndReqOfMyReq.isHidden = false
            cell.btnEndReqOfMyReq.addTarget(self, action: #selector(endHelpReqAction(sender:)), for: UIControlEvents.touchUpInside)
            cell.btnEndReqOfMyReq.tag = indexPath.row
        }
        
        
        let diffOfDate = countryList.pext_date == nil ? "Same" :   datedifference(timeInterval: countryList.pext_date!, timeZone: countryList.pext_timeZone!)
        
        if diffOfDate == "Small" || countryList.pst_completed == "Expired"{
            cell.btnEndReqOfMyReq.isHidden = true
            cell.lbl_Date.text = "Request Expired"
        }else if (countryList.pst_completed == "Yes"){
            cell.btnEndReqOfMyReq.isHidden = true
            cell.lbl_Date.text = "Request Ended"
        }else if(diffOfDate == "Same"){
            cell.lbl_Date.text = "Request help by today"
        }else{
            cell.lbl_Date.text = String(format: "Needs help by %@  ",  dateFormateWithMonthandDay(timeInterval: countryList.pext_date!))
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let countryList = arrOfData[indexPath.row]
        
        let helpReqDetaliVC = storyboard?.instantiateViewController(withIdentifier: "HelpReqDetaliVC") as! HelpReqDetaliVC
        helpReqDetaliVC.postId = countryList.pst_id
        helpReqDetaliVC.pstDeleteCallback = {(isDelete : Bool) -> Void in
            if(isDelete){
                self.arrOfData.remove(at: indexPath.row)
                self.table_View.reloadData()
            }
        }
        
        helpReqDetaliVC.endReqCallbackOFHRdetails = {(isEnd : Bool) -> Void in
            if(isEnd){
                self.arrOfData.remove(at: indexPath.row)
                self.table_View.reloadData()
            }
        }
        navigationController?.pushViewController(helpReqDetaliVC, animated: true)
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2000
    }
    
   
//    func scrollViewDidEndDecelerating(_ scrollView: UITableView) {
//        let VisibleRow = tableview.indexPathsForVisibleRows?.last?.row;
//        let lastRowIndex : Int = self.arrOfData.count - 1
//        if VisibleRow == lastRowIndex {
//            pullUpRefreshMethod()
//        }
//    }
    
//========================================================
//MARK:- Table view cell button action method(End Req)
//========================================================
    @objc func endHelpReqAction (sender: UIButton){
        
        let countryList = arrOfData[sender.tag]

        DispatchQueue.main.async {
            self.helpedUsrLstVw = HelpedUserListView.instanceFromNib() as! HelpedUserListView;
            self.helpedUsrLstVw.frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width), height: UIScreen.main.bounds.height)
            self.showHelpedUserListViewWithAnimation(view: self.helpedUsrLstVw )
            self.helpedUsrLstVw.getAllHelpRequestedUser(controller: self, pst_Id: countryList.pst_id!, callBack: {[weak self]  (isSuccess:Bool , message : String)  in
                
                guard let weekSelf = self else { return }
                
                  if(isSuccess){ // is Success at user is in user list
                      windowController().view.addSubview(weekSelf.helpedUsrLstVw)
                      weekSelf.helpedUsrLstVw.layoutIfNeeded()
                  }else{
                    
                    if(message == "Oops! There is no data to display."){
                        weekSelf.endHelpRequest(pst_Id: countryList.pst_id!, postTtl: countryList.pst_title! , arrOfID: ["NO_ID"] , idx : sender.tag)
                    }else{
                         ShowError(message: message  , controller: self!)
                    }
                  }
                })

           self.helpedUsrLstVw.onHideComplete = {(isSuccess : Bool , arrOfSltId : [Any]) -> Void in
                if(isSuccess){ // isSuccess End Req Btn Clicked
                    
                    self.endHelpRequest(pst_Id: countryList.pst_id!, postTtl: countryList.pst_title! , arrOfID: arrOfSltId , idx : sender.tag)
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
// MARK:- Call SerVice For Delete Post Of Hive and Help
//========================================================
    /*
     1.usrToken->user token
     2.usrId->user id(only for my record)
     3.catId->category id
     4.completed->(Yes or No)
     5.limit->limit
     6.page->page
     */
    func manageMyOrOtherHelpRequest(user_Id : String,completedStatus : String){

        self.lbl_Alert.isHidden = true
        
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "usrId" :  user_Id,
                                 "catId" : UserDefaults.standard.value(forKey: "HelpReq_Id"),
                                 "completed" : completedStatus,
                                 "limit" : "10",
                                 "page" : isRemove ? 0 : String(self.arrOfData.count),
                                 ]
        
        
       // print(dict)
        
       /* ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.manageMyOrOtherHelpRequest , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
         
            DispatchQueue.main.async {
                
                killLoader()
                // Remove Refresh Controller
                weakSelf.removeRefreshLoader()
                
//                if(weakSelf.pageCount == 1){
//                    weakSelf.arrOfData.removeAll()
//                    weakSelf.table_View.reloadData()
//
//                }
                
                // weakSelf.arrOfData.removeAll()
                //weakSelf.table_View.reloadData()
                
                if(!isError){
                    if weakSelf.isRemove == true{
                        weakSelf.isRemove = false
                        weakSelf.table_View.isHidden = true
                        weakSelf.lbl_Alert.isHidden = false
                        weakSelf.lbl_Alert.text = (response as! [String : Any])["message"]  as? String
                        
                    }
                }else{
                    weakSelf.lbl_Alert.isHidden = true
                    weakSelf.table_View.isHidden = true
                    weakSelf.lbl_Alert.text = isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String
                }
                  return
                }
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                
                weakSelf.lbl_Alert.isHidden = true
                weakSelf.table_View.isHidden = false
                weakSelf.removeRefreshLoader()
                
                if(weakSelf.isRemove == true){
                    weakSelf.isRemove = false
                    weakSelf.arrOfData.removeAll()
                }
              
               // weakSelf.pageCount = weakSelf.pageCount + 1
                let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
               // print(countryResponseBody!)
                weakSelf.arrOfData += (countryResponseBody?.data!)!
                weakSelf.table_View.reloadData()
            }
        })*/
        
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any> , service: Service.manageMyOrOtherHelpRequest, callBack: { [weak self] (response:Any ,isError:Bool) in
            if(!isError){
                
                if self?.isRemove == true {
                    self?.isRemove =  false
                    self?.arrOfData.removeAll()
                }
                
                guard let weakSelf = self else { return }
                if((response as! [String : Any])["success"] as! Bool){
                    DispatchQueue.main.async {
                        print("RESPONSE ==",response)
                        weakSelf.table_View.isHidden = false
                        weakSelf.lbl_Alert.isHidden = true
                        
                    
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                         print(countryResponseBody!)
                        weakSelf.arrOfData += (countryResponseBody?.data!)!
                        weakSelf.table_View.reloadData()
                        
                        // Remove Refresh Controller
                        weakSelf.removeRefreshLoader()
                        killLoader()
                    }
                }else{
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                            APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                            ShowError(message: (response as! [String : Any])["message"] as! String, controller: weakSelf)
                        }
                        
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                         DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: weakSelf)
                        }
                        return
                    }else{
                        
                        DispatchQueue.main.async {
                            killLoader()
                            if(weakSelf.arrOfData.count > 0){
                                weakSelf.showToastForMoreData(message: "No more data", width: 120)
                            }else{
                                DispatchQueue.main.async {
                                    if (weakSelf.arrOfData.count==0){
                                        weakSelf.table_View.isHidden = true
                                        weakSelf.lbl_Alert.isHidden = false
                                        weakSelf.lbl_Alert.text = (response as! [String : Any])["message"]  as? String
                                    }
                                }
                            }
                            weakSelf.removeRefreshLoader()
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    
                    killLoader()
                    // Remove Refresh Controller
                    self?.removeRefreshLoader()
                    ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                    })
                }
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
    func endHelpRequest(pst_Id: String , postTtl : String ,arrOfID: [Any] , idx : Int){
        //showLoader(view: self.view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "usrIdFrm" :  arrOfID,
                                 "pstId" : pst_Id,
                                 "pstTtl" : postTtl]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.endHelpRequest , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                
                return
            }
            
            DispatchQueue.main.async {
                btnClickEvent(caregoryNm: "Help Request", action: "End Help Request", label: "")
                killLoader()
                weakSelf.showAlertForHelpReqComplete()
                weakSelf.arrOfData.remove(at: idx)
                weakSelf.table_View.reloadData()

            }
            
            
            NotificationCentreClass.fireGetTotalKrmPointsUsingNotificationCenter()
        })
        
    }

    

}
