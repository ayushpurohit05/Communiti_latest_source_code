//
//  StrugglingVC.swift
//  Communiti
//
//  Created by mac on 25/05/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class StrugglingVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var countryListOFHiveHm: CountryList?
    var arrOFShowData = [CountryList]()
    var totalPostCount : String!
    var isNoMoreData = false
    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    var isTrendingPst = false
    
    @IBOutlet var lbl_UserCount: UILabel!
    @IBOutlet var lbl_PostCount: UILabel!
    @IBOutlet var tbl_View: UITableView!
    @IBOutlet weak var lbl_Commt: UILabel!
    @IBOutlet var btnJoin: UIButton!
    @IBOutlet var btnAll: UIButton!
    @IBOutlet var btnTrending: UIButton!
    
    @IBOutlet var lbl_GroupNm: UILabel!
    
    @IBOutlet var imgVw_Group: UIImageView!
    
    @IBOutlet var lbl_GropDes: UILabel!
    @IBOutlet var btn_DropDown: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpdata()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tbl_View.reloadData()
            self.hiddenNaviAndTabbar()
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpdata(){
        
        self.lbl_GropDes.text = countryListOFHiveHm?.grp_description
        self.btn_DropDown.isHidden = countryListOFHiveHm?.usr_join == "NO" ? true : false
        self.lbl_GroupNm.text = String(format: "#%@",(countryListOFHiveHm?.grp_title)!)
        self.btnJoin.isHidden =  countryListOFHiveHm?.usr_join == "NO" ? false : true
        self.lbl_UserCount.text = countryListOFHiveHm?.usr_count
        self.lbl_PostCount.text = countryListOFHiveHm?.pst_count
        DispatchQueue.main.async {
            if(self.countryListOFHiveHm?.grp_image != nil && self.countryListOFHiveHm?.grp_image != ""){
                saveImgIntoCach(strImg: (self.countryListOFHiveHm?.grp_image!)!, imageView:  self.imgVw_Group)
            }else{
                self.imgVw_Group.image =  UIImage(named: "helpPost_Defalt")
            }
        }
        self.addRefreshController()
        self.getHiveReqAllPost(trendPost: "")
    }
    
    func hiddenNaviAndTabbar(){
        
        self.navigationController?.navigationBar.isHidden = true

        tabBarController?.tabBar.isHidden = true
        if let arrOfviews = tabBarController?.view.subviews{
            for view in arrOfviews{
                if view.isKind(of: UIButton.self) {
                    view.isHidden = true
                }
            }
        }

    }
    
    @IBAction func dropDownBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Leave Hive", style: .default) { action in
             self.exitGroup()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { action in
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func trendingBtnAction(_ sender: Any) {
        isTrendingPst = true
        self.btnTrending.setTitleColor(theamColor(red: 54, green: 181, blue: 185), for: UIControlState.normal)
        self.btnAll.setTitleColor( UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: UIControlState.normal)

        DispatchQueue.main.async {
            self.arrOFShowData.removeAll()
            self.getHiveReqAllPost(trendPost: "TREND")
        }
    }
    
    @IBAction func allBtnAction(_ sender: Any) {
        isTrendingPst = false
        self.btnAll.setTitleColor(theamColor(red: 54, green: 181, blue: 185), for: UIControlState.normal)
        self.btnTrending.setTitleColor( UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: UIControlState.normal)
        DispatchQueue.main.async {
            self.arrOFShowData.removeAll()
            self.getHiveReqAllPost(trendPost: "")
        }
    }
    @IBAction func joinBtnAction(_ sender: UIButton) {
        self.joinGroup(btnJoin: sender)
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
        isNoMoreData = false
        self.arrOFShowData.removeAll()
        if(isTrendingPst){
            self.getHiveReqAllPost(trendPost: "TREND")

        }else{
            self.getHiveReqAllPost(trendPost: "")

        }
      
    }
    
    func pullUpRefreshMethod(){
            if(isNoMoreData){
                self.showToastForMoreData(message: "No more data", width: 120)
                // Remove Refresh Controller
                self.removeRefreshLoader()
                killLoader()
            }else{
                if(isTrendingPst){
                    self.getHiveReqAllPost(trendPost: "TREND")
                    
                }else{
                    self.getHiveReqAllPost(trendPost: "")
                    
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
    //MARK:- Tabel view delegate methods
    //======================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOFShowData.count
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "Cell"
        var cell: FeedCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? FeedCell
        if cell == nil {
            tableView.register(UINib(nibName: "HiveHomeCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FeedCell

        }
        cell.BgViewOfImg.layer.borderColor = UIColor.lightGray.cgColor

        let countryList = self.arrOFShowData[indexPath.row]
        DispatchQueue.main.async {
            if(countryList.profile_image != nil && countryList.profile_image != ""){
                saveImgIntoCach(strImg: countryList.profile_image!, imageView: cell.cell_ImgView)
            }else{
                cell.cell_ImgView.image =  UIImage(named: "helpPost_Defalt")
            }
        }
        
        
        cell.lbl_Tittle.text = countryList.pst_title!.capitalizingFirstLetter()
        cell.lbl_Desc.text = countryList.pst_description!.capitalizingFirstLetter()
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
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postVC = storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        postVC.ctyListObjFrmFeedVC = arrOFShowData[indexPath.row]
        postVC.isCameFrmNotiVC = false
        postVC.onHideComplete = {(isDelete : Bool) -> Void in
            if(isDelete){
                self.arrOFShowData.remove(at: indexPath.row)
                self.tbl_View.reloadData()
            }
        }
        navigationController?.pushViewController(postVC, animated: true)
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
            DispatchQueue.main.async {
             sender.isUserInteractionEnabled = true
            }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                

                
                if(!isError && (response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                    DispatchQueue.main.async {
                        APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                        ShowError(message: (response as! [String : Any])["message"] as! String, controller: weakSelf)
                    }
                }else{
                    ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                    DispatchQueue.main.async {
                        weakSelf.getUpVoteCount(cell: cell, countryList: countryList)
                    }
                }
                return
            }
            
            
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
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
    
    
//=======================================================
//MARK:- Call Service For Get HIVES ALL Post
//========================================================
    
    func getHiveReqAllPost(trendPost : String){
        showLoader(view: windowController().view)
        if (UserDefaults.standard.value(forKey: "HiveReq_Id") != nil) {

            let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                     "catId" :  UserDefaults.standard.value(forKey: "HiveReq_Id"),
                                     "activity" : "",
                                     "scatId" : "" ,
                                     "tags" : "" ,
                                     "limit" : "10",
                                     "page" : self.arrOFShowData.count,
                                     "grpId" : countryListOFHiveHm?.grp_id ?? "",
                                     "pstId" : "",
                                     "trndPst" : trendPost ]
        
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
                            print("RESPONSE ==",response)
                            weakSelf.tbl_View.isHidden = false
                            weakSelf.lbl_Commt.isHidden = true
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
                                            weakSelf.lbl_Commt.isHidden = false
                                            weakSelf.lbl_Commt.text = (response as! [String : Any])["message"]  as? String
                                        }
                                    }
                                }
                                weakSelf.removeRefreshLoader()
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        
                        self?.lbl_Commt.isHidden = true
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

//========================================================
// MARK:- Call SerVice For Join Group
//========================================================
    
    func joinGroup(btnJoin : UIButton){
        /*
         1.usrToken->user token
         2.grpId->group id
         */
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "grpId" :  countryListOFHiveHm?.grp_id ?? ""]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.joinGroupByUser , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                if(!isError){
                    //Btn Join
                     weakSelf.btnJoin.isHidden = false;
                    
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
                    }
                }else{
                    killLoader()
                    ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                }
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
               // print(response)
                weakSelf.countryListOFHiveHm?.usr_join = "YES"
                weakSelf.btnJoin.isHidden = true;
                weakSelf.btn_DropDown.isHidden = false
                APP_Delegate().isRefreshFeedVClist = true

            }
        })
    }
    
    //========================================================
    // MARK:- Call SerVice For Exit grroup
    //========================================================
    
    func exitGroup( ){
        /*
         1.usrToken->user token
         2.grpId->group id
         */
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "grpId" :  countryListOFHiveHm?.grp_id ?? ""]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.removeFromGroup , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                if(!isError){
                    //Btn Join
                    weakSelf.btnJoin.isHidden = false;
                    
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
                    }
                }else{
                    killLoader()
                    ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                }
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                print(response)
                weakSelf.countryListOFHiveHm?.usr_join = "NO"
                APP_Delegate().isRefreshFeedVClist = true
                weakSelf.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    
}//END
