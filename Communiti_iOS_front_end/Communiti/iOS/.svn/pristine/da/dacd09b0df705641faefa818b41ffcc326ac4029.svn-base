//
//  KudosDetailsVC.swift
//  Communiti
//
//  Created by mac on 27/07/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class KudosDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table_View: UITableView!
    @IBOutlet var imgVw_Kudos: UIImageView!
    @IBOutlet var lbl_KudosN: UILabel!
    @IBOutlet var lbl_PostWithKudosNm: UILabel!
    @IBOutlet var lbl_KudosCount: UILabel!
    @IBOutlet var lbl_KudosDes: UILabel!

    
    var arrOFShowData = [CountryList]()
    var objOFUserProfile : CountryList?
    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    var isRemove = false
    var KudosPostCount : String!
    var callBackFromKdDetailVC: ((Bool) -> Void)?
    var isOtherUser : Bool?
    var user_id : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if(user_id  == getUserData()["usr_id"] as? String){
            isOtherUser = false
        }else{
            isOtherUser = true
        }
        
        self.getUserKudosPost()
        self.setUpData()
    }
    
    func setUpData(){
        if  !(isOtherUser!) {
            if objOFUserProfile?.kd_isRead == "NO"{
                self.readKudos()
            }
        }
     

        self.addRefreshController()
        let typeWithImg = KudosTypeAndImage(kudosTyp: KudosType(rawValue: Int((objOFUserProfile?.kd_id!)!)!)!, isSmall: false)

        self.lbl_KudosN.text = typeWithImg.0
        self.imgVw_Kudos.image = typeWithImg.1
        self.lbl_KudosCount.text = objOFUserProfile?.kd_count
         self.lbl_KudosDes.text = objOFUserProfile?.kd_description
        self.lbl_PostWithKudosNm.text = "Posts With Your \(typeWithImg.0) answers"

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
        //self.isNoMoreData = false
        isRemove = true
        self.arrOFShowData.removeAll()
        self.getUserKudosPost()
        
    }
    
    func pullUpRefreshMethod(){
        
        isRemove = false
        if(Int(self.KudosPostCount) != self.arrOFShowData.count){
            self.getUserKudosPost()
            
        }else{
            //if(!isNoMoreData){
                self.removeRefreshLoader()
                self.showToastForMoreData(message: "No more data", width: 120)
              //  self.isNoMoreData = true
//            }else{
//                self.removeRefreshLoader()
//            }
            
            
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOFShowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "KudosDetailCell"
        var cell: KudosDetailsCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? KudosDetailsCell
        if cell == nil {
            tableView.register(UINib(nibName: "KudosDetailCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? KudosDetailsCell
        }
        
        let countryListResult = arrOFShowData[indexPath.row]
        cell.lbl_Tittle.text = countryListResult.pst_title
        if(isOtherUser)!{
            cell.bgVw_BtnShare_H.constant = 0
        }else{
            cell.bgVw_BtnShare_H.constant = 40
            //Share Btn Action
            cell.btnShare.addTarget(self, action: #selector(ShareBtnaction(sender:)), for: UIControlEvents.touchUpInside)
            cell.btnShare.tag = indexPath.row
        }
     
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postVC = storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        
        let countryList = arrOFShowData[indexPath.row]
        postVC.ctyListObjFrmFeedVC = countryList
        postVC.isCameFrmNotiVC = false
        postVC.onHideComplete = {(isDelete : Bool) -> Void in
            if(isDelete){
                self.arrOFShowData.remove(at: indexPath.row)
                self.table_View.reloadData()
            }
        }
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2000
    }
    
    
    //====================================
    //MARK:- Share Btn Action Method
    //====================================
    
    @objc func ShareBtnaction (sender: UIButton){
        
        let countryList = self.arrOFShowData[sender.tag]

        let txt = String(format: "I received the %@ badge on Communiti, the peer-to-peer social platform for change-makers. See my answer here. \n%@checkCommunityApp?pstId=%@&type=hive", self.lbl_KudosN.text!,Service.Base_URL,(countryList.pst_id)!)
        
        self.shareNotes(message: txt)
    }
    
    func shareNotes(message : String){
        
        let text = message
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
    

    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let VisibleRow = self.table_View.indexPathsForVisibleRows?.last?.row;
//        let lastRowIndex : Int = self.arrOFShowData.count - 1
//        if VisibleRow == lastRowIndex {
//            if(Int(self.KudosPostCount) != arrOFShowData.count){
//                imgVw_MorePost.image = UIImage.gifImageWithName("DropDownArrowImg")
//                self.bgViewOFMorePost_H.constant = 26
//            }else{
//                self.bgViewOFMorePost_H.constant = 0
//            }
//        }else{
//            self.bgViewOFMorePost_H.constant = 0
//       }
//    }
//
    //================================
    // Call Service For Give Kudos
    //================================
    func getUserKudosPost(){
        
        /*
         1.usrToken->user token
         2.kudosId->kudosId
         3.limit->limit
         4.page->page
         */
        showLoader(view: windowController().view)
        let dict : Dictionary =  ["usrToken" : getUserData()["usr_token"],
                                  "usrId" : user_id,
                                  "kudosId" : objOFUserProfile?.kd_id ,
                                  "limit" : "10",
                                  "page" : isRemove  ? 0 : self.arrOFShowData.count]
        
        ServerCommunicator(params: dict as? Dictionary<String, Any>  , service: Service.getUserKudosPost, callBack: { [weak self] (response:Any ,isError:Bool) in

            guard let weakSelf = self else { return }
            
            // Remove Refresh Controller
            weakSelf.removeRefreshLoader()
            killLoader()
            if(!isError){
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    let resultData = dictResponse["data"] as Any
                    print("RESPONSE ==",resultData)
                    DispatchQueue.main.async {
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                        weakSelf.arrOFShowData += (countryResponseBody?.data!)!
                        if let count = countryResponseBody?.total_count{
                            weakSelf.KudosPostCount = count
                        }
                        
                        weakSelf.table_View.reloadData()
                    }
                    
                }else{
                    
               //     ShowError(message: dictResponse["message"]  as! String, controller: windowController())
                    if(weakSelf.arrOFShowData.count > 0){
                        weakSelf.showToastForMoreData(message: "No more data", width: 120)
                        return
                    }
                    
                }
                
            }else{
                
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: windowController(), cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
                
            }
        })
        
        
        
    }
    //================================
    // Call Service For Kudos Unread
    //================================
    func readKudos(){
        
        /*
         1.usrToken->user token
         2.kudosId->kudosId
         */
        
        let dict : Dictionary =  ["usrToken" : getUserData()["usr_token"],
                                  "kudosId" : objOFUserProfile?.kd_id ]
        
        ServerCommunicator(params: dict as? Dictionary<String, Any>  , service: Service.readKudos, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weakSelf = self else { return }
            
            // Remove Refresh Controller
            weakSelf.removeRefreshLoader()
            killLoader()
            if(!isError){
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    let resultData = dictResponse["data"] as Any
                    print("RESPONSE ==",resultData)
                    DispatchQueue.main.async {
                       weakSelf.objOFUserProfile?.kd_isRead  =  "YES"
                        if(weakSelf.callBackFromKdDetailVC != nil){
                            weakSelf.callBackFromKdDetailVC!(true)
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
