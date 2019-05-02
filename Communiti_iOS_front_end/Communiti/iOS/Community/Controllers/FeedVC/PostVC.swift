 //
//  PostVC.swift
//  Community
//
//  Created by Navjot  on 11/28/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper
import TPKeyboardAvoiding
import MGSwipeTableCell

class PostVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,MGSwipeTableCellDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate ,UIScrollViewDelegate{
    
    
    @IBOutlet weak var btn_SendOrUpdate: UIButton!
    @IBOutlet weak var bgViewOfTextView: UIView!
    @IBOutlet weak var text_View: UITextView!
    @IBOutlet weak var table_View: UITableView!
    
    var arryCount : Int = 50
    var isFirstTime = true
    var isCameFrmNotiVC : Bool!
    var isNotify : Bool!
    let cellReuseIdentifier = "cell"
    let reuseIdOfHelp = "GreatAnswerCell"
    var greatAnsView = GreatAns_View()
    var countryListObj: CountryList?
    var ctyListObjFrmFeedVC : CountryList?
    var arrOFShowData = [CountryList]()
    var isSendBtnClk : Bool!
    var sltCellIdx : Int!
    var onHideComplete: ((Bool) -> Void)?
    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    var isShareBtnClk = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader(view: self.view)
         self.setUpView()
  
        self.registorKeyBordNotifiCations()
        
        //Registor GetHivePostDetails Notification
        NotificationCentreClass.registerGetHivePostDetailsNotifire(vc: self, selector: #selector(self.getHivePostDetailsUsingNotificationCenter(_:)))
        
        DispatchQueue.main.async {
            self.table_View.estimatedRowHeight = 2000;
            self.table_View.estimatedRowHeight = UITableViewAutomaticDimension
            self.table_View.rowHeight = UITableViewAutomaticDimension
            self.table_View.isHidden = true
            self.getHivePostDetails()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        DispatchQueue.main.async {
//            self.table_View.reloadData()
//        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
       self.removeKeyBordNotifiCations()
    }
    
//=======================================
//MARK:- Registor KeyBord NotifiCations
//======================================
    
    func registorKeyBordNotifiCations(){
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
//=======================================
//MARK:- Remove KeyBord NotifiCations
//======================================
    func removeKeyBordNotifiCations(){
        if(!isShareBtnClk){
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            
            NotificationCentreClass.removeGetHivePostDetailsNotifire(vc: self)
        }else{
            isShareBtnClk = false
        }
    }
    
//=================================
//MARK:-  SetUp of View method
//===============================
    
    func setUpView(){
        // Hide 3Dots
         self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // addRefesh controller
        self.addRefreshController()
        
        //set btn Text
        self.btn_SendOrUpdate.setTitle("SEND", for: UIControlState.normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white

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
    }
    
//========================================================
//MARK:- Right Navi Btn Action
//========================================================
    @IBAction func rightNviBtnActionMethod(_ sender: Any) {
        openDropDownMenuOfPost()
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
        // not required when using UITableViewController
    }
    
    func pullToDownRefresh() -> Void {
        arrOFShowData.removeAll()
        self.getAllPostComments()
    }
    
    func pullUpRefreshMethod(){
         self.getAllPostComments()
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
    
//========================================================
//MARK:- table view delegate methods
//========================================================
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOFShowData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(isFirstTime){
            let cell: PostCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PostCell
               cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell

        }
        
        if indexPath.row == 0 {
            
            let cell: PostCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PostCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.user_ImagView.image =  UIImage(named: "helpPost_Defalt")
            if(countryListObj?.profile_image != nil && countryListObj?.profile_image != ""){
                saveImgIntoCach(strImg: countryListObj!.profile_image!, imageView: cell.user_ImagView)
            }else{
                cell.user_ImagView.image =  UIImage(named: "helpPost_Defalt")
            }

            cell.bgViewOfImage.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtVW_Tittle.text = countryListObj?.pst_title?.capitalizingFirstLetter()
            cell.txtVW_Des.text = countryListObj?.pst_description?.capitalizingFirstLetter()
            cell.lbl_CatName.text = String(format: "#%@     ", countryListObj?.grp_title ?? "")
            cell.lbl_Date.text = convertDateInUTCFormate(timeInterval: (countryListObj?.pst_updatedate != "" ? countryListObj?.pst_updatedate : countryListObj?.pst_createdate)!)
            cell.lbl_VotesCount.text = countryListObj?.upvote_count


            //Btn userimg Of Post
            cell.btnUserImgOfPost.addTarget(self, action: #selector(openUserProfileOfPostUser(btn:)), for: .touchUpInside)
            cell.btnUserImgOfPost.tag = indexPath.row

            //Btn UpVoteClick Action
            cell.btn_UpVote.addTarget(self, action: #selector(upVoteBtnAction(btn:)), for: .touchUpInside)
            cell.btn_UpVote.tag = indexPath.row
            
            //Btn DownVoteClick Action
            cell.btnDownVote.addTarget(self, action: #selector(downVoteBtnAction(btn:)), for: .touchUpInside)
            cell.btnDownVote.tag = indexPath.row
            
            if( countryListObj?.usr_upvote == "NO"){
                cell.img_VwUpVote.image = UIImage(named: "up_1x")
                cell.img_VwDownVote.isHidden = true
                cell.btn_UpVote.isEnabled = true
                cell.btnDownVote.isEnabled = false
                
            }else{
                cell.img_VwUpVote.image = UIImage(named: "up_Active")
                cell.img_VwDownVote.isHidden = false
                cell.btn_UpVote.isEnabled = false
                cell.btnDownVote.isEnabled = true
                
            }
            cell.lbl_Replies.text = String(format: "%@ replies", countryListObj?.replies_count ?? "0")
            
        
            // Create Tag
            self.createTags(cell : cell, countryListObj: countryListObj!)
            return cell
        }
        else{
            
            let cell:GreatAnswerCell = tableView.dequeueReusableCell(withIdentifier: reuseIdOfHelp) as! GreatAnswerCell
            
                cell.delegate = self
                cell.tag = indexPath.row
            
               cell.selectionStyle = UITableViewCellSelectionStyle.none
            if(arrOFShowData.count != 0){
                
                let countryListResult = arrOFShowData[indexPath.row - 1]
                let ans_Id = countryListResult.ans_id
                
                // Btn Open Menu
                cell.btn_OpenMenu.addTarget(self, action: #selector(openActionSheetMenu(btn:)), for: .touchUpInside)
                cell.btn_OpenMenu.tag = indexPath.row
            
                if(countryListResult.profile_image != nil && countryListResult.profile_image != ""){
                    saveImgIntoCach(strImg: countryListResult.profile_image!, imageView:  cell.img_ViewUser)
                    
                }else{
                     cell.img_ViewUser.image  =  UIImage(named: "helpPost_Defalt")
                }
                
             
                cell.lbl_Date.text =  convertDateInUTCFormate(timeInterval: countryListResult.ans_updatedate != "" ? countryListResult.ans_updatedate! : countryListResult.ans_createdate!)
                
                cell.imgback_viw.layer.borderColor = UIColor.lightGray.cgColor
                cell.txtVw_comment.text = countryListResult.ans_description?.capitalizingFirstLetter()
                
                //Btn UserProfileOf Comment
                cell.btnUserProfile.addTarget(self, action: #selector(openUserProfileOfCommentUser(btn:)), for: .touchUpInside)
                 cell.btnUserProfile.tag = indexPath.row

                 // Btn DownVote
                cell.btn_DownVote.addTarget(self, action: #selector(downVoteActionOfComments(btn:)), for: .touchUpInside)
                cell.btn_DownVote.tag = indexPath.row
                cell.btn_DownVote.isEnabled = false

                // Btn UpVote
                cell.btn_Vote.addTarget(self, action: #selector(upVoteActionOfComments(btn:)), for: .touchUpInside)
                cell.btn_Vote.tag = indexPath.row
                cell.lbl_VotesCount.text = countryListResult.count_upvote ?? "0"


                if(countryListResult.user_upvote == "NO" ){
                    
                    cell.img_View_UpVote.image = UIImage(named: "up_1x")
                    cell.img_View_DownVote.isHidden = true
                    cell.btn_Vote.isEnabled = true
                    cell.btn_DownVote.isEnabled = false

                }else{
                    
                    cell.img_View_UpVote.image = UIImage(named: "up_Active")
                    cell.img_View_DownVote.isHidden = false
                    cell.btn_Vote.isEnabled = false
                    cell.btn_DownVote.isEnabled = true


                }
              
                if(getUserData()["usr_id"] as? String  == countryListObj?.usr_id){
                    
                 if(getUserData()["usr_id"] as? String != countryListResult.usr_id){
                    cell.bgVwOfGreatAns_H.constant = 28
                // GreatAns btn
                    cell.btn_Greatans.addTarget(self, action: #selector(btnActionMethod(sender:)), for: UIControlEvents.touchUpInside)
                    cell.btn_Greatans.tag = indexPath.row
                    
                    if( countryListResult.kudos == "NO"){// for change btn color
                        cell.bgViewOfGreatAns.backgroundColor = UIColor(red: 216/255, green: 213/255, blue: 213/255, alpha: 1);
                        cell.lbl_GreatAns.text = "Kudos"
                        cell.lbl_GreatAns.textColor =  UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1);
                        cell.imgView_SmallThumb.image = UIImage(named: "thumbs_up black")
                    }else{
                        
                        
                        let typeWithImg = KudosTypeAndImage(kudosTyp: KudosType(rawValue: Int(countryListResult.kd_id!)!)!, isSmall: true)
                        cell.lbl_GreatAns.text = typeWithImg.0
                        cell.imgView_SmallThumb.image = typeWithImg.1
                        cell.lbl_GreatAns.textColor = UIColor.white
                        cell.bgViewOfGreatAns.backgroundColor = UIColor(red: 236/255, green: 201/255, blue: 37/255, alpha: 1)

                    }
                 }else{
                    cell.bgVwOfGreatAns_H.constant = 0

                    }
             
                }else{
                    
                    cell.bgVwOfGreatAns_H.constant = 0
                    if( countryListResult.kudos == "YES"){// for change btn color
                        let typeWithImg = KudosTypeAndImage(kudosTyp: KudosType(rawValue: Int(countryListResult.kd_id!)!)!, isSmall: true)
                        cell.lbl_GreatAns.text = typeWithImg.0
                        cell.imgView_SmallThumb.image = typeWithImg.1
                        cell.btn_Greatans.isUserInteractionEnabled = false
                        cell.bgVwOfGreatAns_H.constant = 28
                        cell.lbl_GreatAns.textColor = UIColor.white
                        cell.bgViewOfGreatAns.backgroundColor = UIColor(red: 236/255, green: 201/255, blue: 37/255, alpha: 1)

                    }
                }
                
            }
            return cell
         }
            
        
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 3000
    }

//========================================================
//MARK:- Open DropDownMenu Of Comment
//========================================================
    
    func openDropDownMenuOfComment(idx : Int){
        
        let countryList = arrOFShowData[idx - 1]
        let userId = getUserData()["usr_id"] as! String
        let responseid = countryList.usr_id!
  
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
      if(userId == responseid){ //For Edit Only Self Comments
            alert.addAction(UIAlertAction(title: "Edit", style: .default) { action in
                
                self.btn_SendOrUpdate.setTitle("UPDATE", for: UIControlState.normal)
                self.sltCellIdx = idx
                let countryListResult = self.arrOFShowData[idx - 1]
                self.text_View.text  = countryListResult.ans_description
                self.text_View.textColor = UIColor.black
                self.dismiss(animated: true, completion: nil)
            })
     

          alert.addAction(UIAlertAction(title: "Delete", style: .default) { action in
            showLoader(view: self.view)
            self.deleteCommentMethod(idx: idx)
   
          })
  
    }
        if(userId != responseid){ //For Report Other Comment
            
            if countryList.usr_report == "YES"{
                alert.addAction(UIAlertAction(title: "Already Reported Comment", style: .destructive) { action in
                })
            }else{
                alert.addAction(UIAlertAction(title: "Report", style: .destructive) { action in
                    self.repostBtnAction(isAnswer: true, reporyType: "ANSWER", countryList: countryList)
                })
               
            }
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
        })
         self.present(alert, animated: true, completion: nil)
    }
    
//========================================================
//MARK:- Open DropDownMenu Of User Post
//========================================================
    
    func openDropDownMenuOfPost(){
        
        let userId = getUserData()["usr_id"] as! String
        let responseid = countryListObj?.usr_id!
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if(userId == responseid){ //For Edit Only Self Comments
            alert.addAction(UIAlertAction(title: "Edit", style: .default) { action in
                
                self.moveToCategoryVC()
            })
            
            alert.addAction(UIAlertAction(title: "Delete", style: .default) { action in
                
                showLoader(view: self.view)
                self.detetePostOfHive(countryList: self.countryListObj!)
            })
        }
        alert.addAction(UIAlertAction(title: "Share", style: .default) { action in
            self.shareBtnACtion(message: "I think you might like this post on Communiti, the app for helping and building meaningful connections with people around you!", isPostShare: true)
        })
        
        if(userId != responseid){ //For Edit Only Self Comments
            if countryListObj!.usr_report == "YES"{
                alert.addAction(UIAlertAction(title: "Already Reported Post", style: .destructive) { action in
                })
            }else{
                alert.addAction(UIAlertAction(title: "Report", style: .destructive) { action in
                    self.repostBtnAction(isAnswer: false, reporyType: "POST", countryList: self.countryListObj!)
                })
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
        })
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
//====================================
//MARK:- Move To CategoryVC Method
//====================================
    func moveToCategoryVC(){
        
        let userId = getUserData()["usr_id"] as! String
        let responseid = countryListObj?.usr_id!
        
        if(userId == responseid){
            
            APP_Delegate().reqType = true
            APP_Delegate().isEditHiveFld = true
            APP_Delegate().isEditHelpFld = false
            let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
            if(isCameFrmNotiVC){
       
                categoryVC.ctrObjOFCatg = countryListObj
                categoryVC.sltGroupName = countryListObj?.grp_title
            }else{
                categoryVC.ctrObjOFCatg = ctyListObjFrmFeedVC
                categoryVC.sltGroupName = ctyListObjFrmFeedVC?.grp_title
            }
            
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }

    
//====================================
//MARK:- Share Btn Action Method
//====================================
    func shareBtnACtion(message : String , isPostShare : Bool){
        isShareBtnClk = true

        let text = String(format: "%@ \n%@checkCommunityApp?pstId=%@&type=hive",message,Service.Base_URL,(self.countryListObj?.pst_id)!)
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if(success){
                if(isPostShare){
                    btnClickEvent(caregoryNm: "Hive Request", action: "Share Hive Post", label: "")
                }
            }
        }
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
//====================================
//MARK:- Repost Btn Action Method
//====================================
    func repostBtnAction( isAnswer : Bool,reporyType : String , countryList : CountryList ){
        if(countryList.usr_report == "YES"){
            
            ShowAlert(title: "", message: isAnswer ? "You have already reported this post." : "You have already reported this comment.", controller: self, cancelButton: "Ok", okButton: nil, style: .alert, callback: { (isOk, isCancel) in})
            return
        }
        
        let reportView = UINib(nibName: "ReportView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ReportView
        reportView.frame = UIScreen.main.bounds
        reportView.getReportList(controller: self , countryList: countryList)
        reportView.type = reporyType
        reportView.id = isAnswer ? countryList.ans_id : countryList.pst_id
        self.tabBarController?.view.addSubview(reportView)
        reportView.isAnswer = isAnswer
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
    
//===============================
//MARK:- Create Tag Method
//================================
    
    func createTags(cell : PostCell ,countryListObj : CountryList ){
        
        var arrOfTags = [Tags]()
        arrOfTags = countryListObj.tags!
        
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

        
    }

    func manageDesignOftagsFeedCell( feed_Cell : PostCell ){
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
    
    func manageTagsSize(feed_Cell : PostCell ){
        
        //feed_Cell.bg_TagView.backgroundColor = UIColor.red
        let lbl_Hashtag1 = feed_Cell.lbl_Hashtag1.intrinsicContentSize.width
        let lbl_Hashtag2 = feed_Cell.lbl_Hashtag2.intrinsicContentSize.width
        let lbl_Hashtag3 = feed_Cell.lbl_Hashtag3.intrinsicContentSize.width
        
        
        if(feed_Cell.tag_View.frame.size.width < (lbl_Hashtag1 + lbl_Hashtag2 + lbl_Hashtag3)){
            feed_Cell.bg_TagView_H.constant = 50
            feed_Cell.lbl_Hashtag3.isHidden = true
            feed_Cell.lbl_Hashtag4.isHidden = false
            
            
        }else{
            feed_Cell.bg_TagView_H.constant = 26
            feed_Cell.lbl_Hashtag3.isHidden = false
            feed_Cell.lbl_Hashtag4.isHidden = true
        }
        
    }

    
    //========================================================
    //MARK:- Table view cell button action method(Great Btn)
    //========================================================
    @objc func btnActionMethod (sender: UIButton){
        //sender.isUserInteractionEnabled = false
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let greatCell: GreatAnswerCell = self.table_View.cellForRow(at: indexPath) as! GreatAnswerCell
        let countryListObjOFAns = arrOFShowData[sender.tag - 1]
        
        
     
        
        if(countryListObjOFAns.kudos == "YES"){ //DisLike
            self.giveKudos(countryListObjOFAns: countryListObjOFAns, greatCell: greatCell , sender: sender)
        }else{ // Like
            
            let kudosVC = storyboard?.instantiateViewController(withIdentifier: "KUDOSVC") as! KudosVC
            kudosVC.countryListObjOFAns = countryListObjOFAns
            kudosVC.countryList = countryListObj
            kudosVC.callbackOFKudos = {(sltKudos_ID : Int?) -> Void in
                DispatchQueue.main.async {
                    
                    
                    let typeWithImg = KudosTypeAndImage(kudosTyp: KudosType(rawValue: sltKudos_ID!)!, isSmall: true)
                        btnClickEvent(caregoryNm: "Hive Request", action: "Great Answer", label: "")
                        countryListObjOFAns.kudos = "YES"
                        greatCell.lbl_GreatAns.text = typeWithImg.0
                        greatCell.lbl_GreatAns.textColor = UIColor.white
                        greatCell.bgViewOfGreatAns.backgroundColor = UIColor(red: 236/255, green: 201/255, blue: 37/255, alpha: 1)
                        greatCell.imgView_SmallThumb.image = typeWithImg.1
             
                    
                }
                
                
            }
            navigationController?.pushViewController(kudosVC, animated: true)

        }
        
        
        
        
        
        
        
//
//
//        greatAnsView = GreatAns_View.instanceFromNib() as! GreatAns_View;
//
//        // Call Back For Great Ans How To Earn karma points Button Click
//        greatAnsView.HowKMPointsWorksCallBack = {(isSuccess : Bool) -> Void in
//            if(isSuccess){
//                let whatsKMVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WHATSKMVC") as! WhatsKMVC
//
//                self.navigationController?.pushViewController(whatsKMVC, animated: true)
//            }
//        }
//        DispatchQueue.main.async {
//
//            self.greatAnsView.greatAndUnGreatAnsMethod(controller: self, ans_Id:countryListObj.ans_id!,callBack: {[weak self]  (isSuccess:Bool)  in
//
//                guard let weekSelf = self else { return }
//
//                if(isSuccess){ // Like
//                    if( UserDefaults.standard.object(forKey: "IsShowGreatAnsAlert") as! Bool){
//
//                    weekSelf.greatAnsView.frame = CGRect(x: 0, y: 0, width: (weekSelf.view.frame.size.width), height: UIScreen.main.bounds.height)
//                    weekSelf.greatAnsView.setUpOfLbl()
//                   // weekSelf.showGreatAnsViewWithAnimation(view: weekSelf.greatAnsView )
//                    weekSelf.tabBarController?.view.addSubview(weekSelf.greatAnsView)
//                    weekSelf.greatAnsView.layoutIfNeeded()
//
//                    DispatchQueue.main.async {
//                        btnClickEvent(caregoryNm: "Hive Request", action: "Great Answer", label: "")
//
//
//                        countryListObj.great = "YES"
//                        greatCell.lbl_GreatAns.textColor = UIColor.white
//                        greatCell.bgViewOfGreatAns.backgroundColor = UIColor(red: 236/255, green: 201/255, blue: 37/255, alpha: 1)
//                       // greatCell.btn_Greatans.setImage(UIImage(named: "thumbs up white"), for: UIControlState.normal)
//
//                        greatCell.imgView_SmallThumb.image = UIImage(named: "thumbs up white")
//
//                        // For show Great Ans Popup Only One Time
//                         UserDefaults.standard.set(false, forKey: "IsShowGreatAnsAlert")
//                        sender.isUserInteractionEnabled = true
//
//
//                      }
//                    }else{
//
//                        btnClickEvent(caregoryNm: "Hive Request", action: "Great Answer", label: "")
//
//                        countryListObj.great = "YES"
//                        greatCell.lbl_GreatAns.textColor = UIColor.white
//                        greatCell.bgViewOfGreatAns.backgroundColor = UIColor(red: 236/255, green: 201/255, blue: 37/255, alpha: 1)
//                        //greatCell.btn_Greatans.setImage(UIImage(named: "thumbs up white"), for: UIControlState.normal)
//                        greatCell.imgView_SmallThumb.image = UIImage(named: "thumbs up white")
//                        sender.isUserInteractionEnabled = true
//                    }
//                }else{ // DisLike
//
//                    countryListObj.great = "NO"
//                    greatCell.bgViewOfGreatAns.backgroundColor = UIColor(red: 216/255, green: 213/255, blue: 213/255, alpha: 1);
//                    greatCell.lbl_GreatAns.textColor =  UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1);
//                   // greatCell.btn_Greatans.setImage(UIImage(named: "thumbs_up black"), for: UIControlState.normal)
//                    greatCell.imgView_SmallThumb.image = UIImage(named: "thumbs_up black")
//                    sender.isUserInteractionEnabled = true
//
//                }
//            })
//
//        }
    }

    
//    func showGreatAnsViewWithAnimation(view : GreatAns_View){
//        view.isHidden=false;
//        view.alert_View.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//        view.bg_View.alpha = 0.0 ;
//        UIView.animate(withDuration: 0.1,
//                       delay: 0.0,
//                       options: UIViewAnimationOptions.curveEaseIn,
//                       animations: { () -> Void in
//                        view.bg_View.alpha = 0.7
//                        view.alert_View.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }, completion: { (finished) -> Void in
//      })
//    }
//
    
//========================================================
//MARK:- Btn UserProfile of Post And Comment Action
//========================================================
    
    @objc func openUserProfileOfPostUser(btn: UIButton){//Perform actions here

            let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "USERPROFILEVC") as! UserProfileVC
            userProfileVC.otherUserId =  self.countryListObj?.usr_id
            self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    @objc func openUserProfileOfCommentUser(btn: UIButton){//Perform actions here
        let countryLst = arrOFShowData[btn.tag - 1]
            let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "USERPROFILEVC") as! UserProfileVC
            //userProfileVC.isOtherUSerProfile = true
            userProfileVC.otherUserId =  countryLst.usr_id
            self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
//========================================================
//MARK:- Up And Down Vote Btn Action
//========================================================
    
    @objc func downVoteBtnAction(btn: UIButton){//Perform actions here
        btnClickEvent(caregoryNm: "Hive Request", action: "Upvote Post", label: "")

        self.upAndDownVotesActionForPost(btn: btn)
    }

    
    @objc func upVoteBtnAction(btn: UIButton){//Perform actions here
        
        btnClickEvent(caregoryNm: "Hive Request", action: "Downvote Post", label: "")
        self.upAndDownVotesActionForPost(btn: btn)
        
    }
    
    func upAndDownVotesActionForPost(btn: UIButton){
        if(isNetwork){
            let indexPath = IndexPath(item: btn.tag, section: 0)
            let cell = self.table_View.cellForRow(at: indexPath) as! PostCell
            DispatchQueue.main.async {
                self.getUpVoteCountForPost(cell: cell, countryList: self.countryListObj!)
            }
            self.upVoteAndDownVoteForPost(sender: btn, id: (self.countryListObj?.pst_id)!,cell : cell , type: "Post")
        }else{
            
            ShowAlert(title: "Alert", message: "Please check your internet connection", controller: UIApplication.shared.keyWindow!.rootViewController!, cancelButton: nil, okButton: "Ok", style: .alert, callback: { (isOk, isCancel) in
                
            })
        }
    }
    
    
    func getUpVoteCountForPost(cell : PostCell , countryList: CountryList) {
        
        
        if( countryList.usr_upvote == "NO"){

            cell.img_VwUpVote.image = UIImage(named: "up_Active")
            cell.lbl_VotesCount.text = String(format: "%d",(Int(cell.lbl_VotesCount.text!)! + 1))
            ctyListObjFrmFeedVC?.upvote_count =  cell.lbl_VotesCount.text
            ctyListObjFrmFeedVC?.usr_upvote  = "YES"
            countryList.upvote_count =  cell.lbl_VotesCount.text
            countryList.usr_upvote  = "YES"
            cell.img_VwDownVote.isHidden = false
            cell.btn_UpVote.isEnabled = false
            cell.btnDownVote.isEnabled = true
            
            
        }else{
            
            cell.img_VwUpVote.image = UIImage(named: "up_1x")
            cell.lbl_VotesCount.text = String(format: "%d",(Int(cell.lbl_VotesCount.text!)! - 1))
            
            ctyListObjFrmFeedVC?.upvote_count =  cell.lbl_VotesCount.text
            ctyListObjFrmFeedVC?.usr_upvote  = "NO"
            countryList.upvote_count =  cell.lbl_VotesCount.text
            countryList.usr_upvote  = "NO"
            cell.img_VwDownVote.isHidden = true
            cell.btnDownVote.isEnabled = false
            cell.btn_UpVote.isEnabled = true
            
        }
        self.table_View.reloadData()
        
    }
    
    @objc func openActionSheetMenu(btn: UIButton){//Perform actions for UpVote
        
           openDropDownMenuOfComment(idx: btn.tag)
    }
    
    
    @objc func upVoteActionOfComments(btn: UIButton){//Perform actions for UpVote
        
        //Google Analitics
        btnClickEvent(caregoryNm: "Hive Request", action: "Upvote Comments", label: "")

        // Up Vote For Comment
        self.upanddownVoteActionOfComments(btn)
        
    }
    @objc func downVoteActionOfComments(btn: UIButton){//Perform actions for DownVote
        
        //Google Analitics
        btnClickEvent(caregoryNm: "Hive Request", action: "Downvote Comments", label: "")
        
        //Down Vote For Comment
        self.upanddownVoteActionOfComments(btn)

    }


    func upanddownVoteActionOfComments(_ btn : UIButton){
        
        if(isNetwork){
            let countryListResult = arrOFShowData[btn.tag - 1]
            let indexPath = IndexPath(item: btn.tag, section: 0)
            let cell = self.table_View.cellForRow(at: indexPath) as! GreatAnswerCell
            DispatchQueue.main.async {
                self.setUpOfVotesForComments(cell: cell, countryList: countryListResult)
            }
            self.upVoteAndDownVoteForPost(sender: btn,id: (countryListResult.ans_id)!, cell : cell , type: "Answer")
        }else{
            
            ShowAlert(title: "Alert", message:"Please check your internet connection", controller: UIApplication.shared.keyWindow!.rootViewController!, cancelButton: nil, okButton: "Ok", style: .alert, callback: { (isOk, isCancel) in
                
            })
        }
    }
    
    func setUpOfVotesForComments(cell: GreatAnswerCell, countryList: CountryList){
        
        if(countryList.user_upvote == "NO" || countryList.user_upvote == nil){
            
            cell.img_View_UpVote.image = UIImage(named: "up_Active")
            cell.lbl_VotesCount.text = String(format: "%d",(Int(cell.lbl_VotesCount.text!)! + 1))
            countryList.count_upvote =  cell.lbl_VotesCount.text
            countryList.user_upvote  = "YES"
            cell.img_View_DownVote.isHidden = false
            cell.btn_Vote.isEnabled = false
            cell.btn_DownVote.isEnabled = true
        }else{
            
            cell.img_View_UpVote.image = UIImage(named: "up_1x")
            cell.lbl_VotesCount.text = String(format: "%d",(Int(cell.lbl_VotesCount.text!)! - 1))
            countryList.count_upvote =  cell.lbl_VotesCount.text
            countryList.user_upvote  = "NO"
            cell.img_View_DownVote.isHidden = true
            cell.btn_Vote.isEnabled = true
            cell.btn_DownVote.isEnabled = false
        }
    }
    
//========================================================
//MARK:- Text View Delegate Methods
//========================================================
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {

        if textView.text == "Comment here..." {
            textView.text = "";
            textView.textColor = UIColor.black;
            
        }
        return true;
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            if(textView.text == ""){
                textView.text = "Comment here..."
                textView.textColor = UIColor.lightGray;
                
            }
            return false
        }
        return true
    }
    
    @IBAction func sendBtnActionMethod(_ sender: UIButton) {
        
        let trimmedString = text_View.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       
        if (trimmedString == "") || (text_View.text == "Comment here...") {
            return
        }
        
        DispatchQueue.main.async {
            
            if(sender.title(for: .normal) == "SEND"){
                
                self.text_View.resignFirstResponder()
                self.addUserCommentForPost()
            }else{
                
                showLoader(view: self.view)
                let countryListResult = self.arrOFShowData[self.sltCellIdx - 1]
                self.text_View.resignFirstResponder()
                self.editCommentMethod(countryListResult: countryListResult)
            }
           
        }
    }
    
//========================================
//MARK:-  Key Board notification method
//========================================
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var visibleRect = self.bgViewOfTextView.frame
            visibleRect.origin.y = (self.view.frame.size.height - keyboardSize.height) - self.bgViewOfTextView.frame.size.height
            
            self.bgViewOfTextView.frame = visibleRect
           // self.table_View.frame.size.height -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.async {
            //self.table_View.frame.size.height += keyboardSize.height
            
            var visibleRect = self.bgViewOfTextView.frame
            visibleRect.origin.y = self.view.frame.size.height - self.bgViewOfTextView.frame.size.height
            self.bgViewOfTextView.frame = visibleRect
            }
        }
    }
    

//========================================================
//MARK:- Call Service For GetAll Post Comments
//========================================================
    /*
     1.usrToken->user token
     2.pstId->post id
     */
    func getAllPostComments(){
        
        let dict : Dictionary = ["usrToken" :getUserData()["usr_token"],
                                 "pstId" : ctyListObjFrmFeedVC?.pst_id,
                                 "limit" : "50",
                                 "page" : String(arrOFShowData.count)]
        
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.getAllPostComments, callBack: { [weak self]  (response:Any ,isError:Bool) in
            
            guard let weekSelf = self else { return }
            
            if(!isError){
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    let resultData = dictResponse["data"]
                    print("RESPONSE ==",resultData!)
                    
                    DispatchQueue.main.async {
                        // Remove Refresh Controller
                        weekSelf.removeRefreshLoader()

//                        if(weekSelf.pageCount == 1){
//                            weekSelf.arrOFShowData.removeAll()
//                        }

                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                       // print(countryResponseBody!)
                        weekSelf.arrOFShowData +=  (countryResponseBody?.data)!

                        weekSelf.table_View.reloadData()
                        
                        if self?.isNotify == true{
                            self?.isNotify = false
                            weekSelf.moveToLastIndex()
                        }
                        killLoader()
                    }
                    
                }else{
                    killLoader()
                    weekSelf.removeRefreshLoader()
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
                            if(weekSelf.arrOFShowData.count > 0){
                                weekSelf.showToastForMoreData(message: "No more data", width: 120)
                            }
                        }
                    }
                }
            }else{
                killLoader()
                weekSelf.removeRefreshLoader()
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }
    
//========================================================
//MARK:- Call Service For Add User Comment For Post
//========================================================
    /*
     1.usrToken->user token
     2.pstId->Post id
     3.dscptn->comment
  */
    func addUserCommentForPost(){
        //showLoader(view: self.view)
    
        let trimmedCommt = self.text_View.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let dict : Dictionary =    ["usrToken" : getUserData()["usr_token"],
                                    "pstId" : countryListObj?.pst_id,
                                    "dscptn" : trimmedCommt,
                                    "pstTtl" : countryListObj?.pst_title,
                                    "pstUsrId" : countryListObj?.usr_id]
        
        text_View.text = "Comment here..."
        text_View.textColor = UIColor.lightGray;
        
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.addCommentOnPost, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weekSelf = self else {
                return
            }
            
            if(!isError){
                
                var dictResponse = response as! [String : Any]
                if(dictResponse["success"] as! Bool){
                    var resultData = dictResponse["data"] as! [[String : Any]]
                   // print("RESPONSE ==",resultData)
                    
                    weekSelf.isSendBtnClk = true
                    
                    DispatchQueue.main.async {
                        var Userimg =  resultData[0]["profile_image"]
                        Userimg = getUserData()["profile_image"]
                        resultData[0]["profile_image"] = Userimg
                        dictResponse["data"] = resultData ;
                        
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: dictResponse)
                        
                         weekSelf.arrOFShowData.insert((countryResponseBody?.data?[0])!, at:  weekSelf.arrOFShowData.count )

                        weekSelf.countryListObj?.replies_count  = String(format: "%d", Int((weekSelf.countryListObj?.replies_count)!)! + 1)
                        weekSelf.ctyListObjFrmFeedVC?.replies_count = String(format: "%d", Int((weekSelf.ctyListObjFrmFeedVC?.replies_count)!)! + 1)
                        weekSelf.table_View.reloadData()
                        weekSelf.moveToLastIndex()
                        
                        btnClickEvent(caregoryNm: "Hive Request", action: "Add Comments", label: "")

                   
                    }
                    
                }else{

                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                        }
                        
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: self!)
                            
                        }
                        return
                    }else{
                        
                        ShowError(message: (response as! [String : Any])["message"]  as! String, controller: self!)
                    }
                }
                
            }else{
             
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })

        
    }

    
    
    func moveToLastIndex(){
        
        // First figure out how many sections there are
        let lastSectionIndex = self.table_View!.numberOfSections - 1
        
        // Then grab the number of rows in the last section
        let lastRowIndex = self.table_View!.numberOfRows(inSection: lastSectionIndex) - 1
        // Now just construct the index path
        let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)

        // Make the last row visible
        self.table_View?.scrollToRow(at: pathToLastRow, at: UITableViewScrollPosition.none, animated: true)
    }
//========================================================
//MARK:- Call Service For  Up And Down Vote For Post
//========================================================

    func upVoteAndDownVoteForPost(sender : UIButton ,id : String , cell : UITableViewCell , type : String){
    
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "voteTyp" : type,
                                 "voteId" : id]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.upVoteAndDownVoteForPost, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            
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
                
                
                if(cell.tag == 0){
                    DispatchQueue.main.async {
                        weakSelf.getUpVoteCountForPost(cell: cell as! PostCell, countryList: weakSelf.countryListObj!)
                    }
                }else{
                    DispatchQueue.main.async {
                        let countryListResult = weakSelf.arrOFShowData[sender.tag - 1]
                        weakSelf.setUpOfVotesForComments(cell: cell as! GreatAnswerCell, countryList: countryListResult)
                    }
                }
                return
            }
            
            let dictResponse = response as! NSDictionary
            if(dictResponse["success"] as! Bool){
               // print("RESPONSE ==",response)
      
            }
      
        })
        
    }
    
//========================================================
//MARK:- Call Service For Edit Comment
//========================================================
    /*
     1.usrToken->user token
     2.ansId->answer id
     3.dscptn->description

  */
    func editCommentMethod(countryListResult : CountryList){
        let trimmedCommt = self.text_View.text.trimmingCharacters(in: .whitespacesAndNewlines)

        
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "ansId" : countryListResult.ans_id,
                                 "dscptn" : trimmedCommt]
        
        text_View.text = "Comment here..."
        text_View.textColor = UIColor.lightGray;
        self.btn_SendOrUpdate.setTitle("SEND", for: UIControlState.normal)

        
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.editHiveReqComment, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            
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
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: self!)
                           
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
             let dictResponse = response as! NSDictionary
             if(dictResponse["success"] as! Bool){
               // print("RESPONSE ==",response)
                var dictResponse = response as! [String : Any]
                countryListResult.ans_description = (dictResponse["data"] as! [[String : Any]])[0]["ans_description"] as? String
              
                countryListResult.ans_createdate = (dictResponse["data"] as! [[String : Any]])[0]["ans_createdate"] as? String
                weakSelf.table_View.reloadData()
             }
            }
            
        })
        
    }
    
//========================================================
//MARK:- Call Service For Delete Comment
//========================================================
    /*
     
     1.usrToken->user token
     2.ansId->answer id
     1.usrToken->user token
     2.ansId->answer id
     3.pstId->post id
     */
    func deleteCommentMethod(idx : Int){
        
        text_View.text = "Comment here..."
        text_View.textColor = UIColor.lightGray;
        self.btn_SendOrUpdate.setTitle("SEND", for: UIControlState.normal)
        
        let countryListResult = self.arrOFShowData[idx - 1]

    
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "ansId" : countryListResult.ans_id,
                                 "ntfyId" : countryListResult.ans_ntfy_id]
        
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.deleteHiveReqComment, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            
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
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    //print("RESPONSE ==",response)
                   weakSelf.arrOFShowData.remove(at: idx - 1)
                    
                    // change Replies Count In Data Model
                    weakSelf.countryListObj?.replies_count  = String(format: "%d", Int((weakSelf.countryListObj?.replies_count)!)! - 1)
                    weakSelf.ctyListObjFrmFeedVC?.replies_count  = String(format: "%d", Int((weakSelf.ctyListObjFrmFeedVC?.replies_count)!)! - 1)
                    weakSelf.table_View.reloadData()
                    weakSelf.moveToLastIndex()
                }
            }
            
        })
        
    }
    
//========================================================
// MARK:- Call SerVice For Delete Post Of Hive and Help
//========================================================
    
    /*
     1.usrToken->user token
     2.pstId->post id
     
     
     */
    func detetePostOfHive( countryList : CountryList){
        showLoader(view: self.view)// show loader
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "pstId" : countryList.pst_id]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.detetePostOfHiveOrHelp , callBack: { [weak self] (response:Any ,isError: Bool) in
            
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
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: self!)
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
                APP_Delegate().isRefreshFeedVClist = true
                weakSelf.navigationController?.popViewController(animated: true)

                if weakSelf.onHideComplete != nil {
                    weakSelf.onHideComplete!(true)
                 }
               }
            
            killLoader()
            
        })
        
    }
    
//================================================================
// MARK:- Call SerVice For Get HivePost Req Detail At Notification
//================================================================
    func getHivePostDetailsUsingNotificationCenter(_ notification: NSNotification){
        isNotify = true
        self.arrOFShowData.removeAll()
        self.getHivePostDetails()
    }

//========================================================
// MARK:- Call SerVice For Get HivePost Details
//========================================================
    
    /*
     1.usrToken->user token
     2.catId->category id
     3.activity->(UPVOTE or COMMENT)
     4.scatId->array(1,2,3)
     5.tags->array('sport','demo')
     6.limit->limit
     7.page->page
     or
     9.pstId->post id(only for single post )
     
     */
    func getHivePostDetails(){
 
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "catId" : UserDefaults.standard.value(forKey: "HiveReq_Id") as! String,
                                 "activity" : "",
                                 "scatId" : "",
                                 "tags" : "",
                                 "limit" : "",
                                 "page" : "",
                                 "pstId" : ctyListObjFrmFeedVC?.pst_id,
                                 "locId" : "",
                                 "grpId" : "",
                                 "trndPst" : ""]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getHivePostDetails , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                
                    if(!isError && (response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                            ShowError(message: (response as! [String : Any])["message"]  as! String, controller: self!)
                        }
                    }else{
                        
                        ShowAlert(title: "Error", message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                        })
                    }

                return
            }
            
            DispatchQueue.main.async {
                weakSelf.isFirstTime = false
                // Hide 3Dots
                self?.navigationItem.rightBarButtonItem?.isEnabled = true

                let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                
                print(response)
                // set Response In CountryListObj
                weakSelf.countryListObj = countryResponseBody?.data?[0]
                weakSelf.ctyListObjFrmFeedVC?.replies_count = weakSelf.countryListObj?.replies_count
                weakSelf.ctyListObjFrmFeedVC?.upvote_count = weakSelf.countryListObj?.upvote_count

                weakSelf.table_View.reloadData()
                weakSelf.table_View.isHidden = false
                
                // get all Post Comments
                weakSelf.getAllPostComments()

            }
            
        })
        
    }
    
    //================================
    // Call Service For Give Kudos
    //================================
    func giveKudos(countryListObjOFAns : CountryList , greatCell : GreatAnswerCell , sender : UIButton){
        
        /*
         1.usrToken->user token
         2.ansId->comment id
         3.kudoId->kudoId
         4.kudoCmnt->kudoCmnt
         */
        
        let dict : Dictionary =  ["usrToken" : getUserData()["usr_token"],
                                  "ansId" : countryListObjOFAns.ans_id ,
                                  "kudoId" : "",
                                  "kudoCmnt" : "",
                                  "pstTtl" : countryListObj!.pst_title,
                                  "grtNtfyId" : countryListObjOFAns.gta_ntfy_id]
        
        ServerCommunicator(params: dict as? Dictionary<String, Any>  , service: Service.giveKudos, callBack: {[weak self]  (response:Any ,isError:Bool) in
            
            guard let weekSelf = self else { return }
            
            
            if(!isError){
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    let resultData = dictResponse["data"] as Any
                    print("RESPONSE ==",resultData)
                    
                    DispatchQueue.main.async {
                        
                        if(dictResponse["message"] as! String == "Unlike successfully."){
                            countryListObjOFAns.kudos = "NO"
                            greatCell.bgViewOfGreatAns.backgroundColor = UIColor(red: 216/255, green: 213/255, blue: 213/255, alpha: 1);
                            greatCell.lbl_GreatAns.text = "Kudos"
                            greatCell.lbl_GreatAns.textColor =  UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1);
                            greatCell.imgView_SmallThumb.image = UIImage(named: "thumbs_up black")
                            sender.isUserInteractionEnabled = true
                        }
                    }
                    
                }else{
                    
                    ShowError(message: dictResponse["message"]  as! String, controller: windowController())
                    
                }
                
            }else{
                
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: windowController(), cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
                
            }
        })
        
        
    }
    
    
}//END
