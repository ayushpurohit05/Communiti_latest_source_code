//
//  ThankYouNotesVC.swift
//  Communiti
//
//  Created by mac on 30/07/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class ThankYouNotesVC: UIViewController, UITableViewDelegate , UITableViewDataSource {

    var arrOFShowData = [CountryList]()
    var arrOfFilterDict  = [[String : [CountryList]]]()
    var filterDict = [String : [CountryList]]()
    var arrOFData = [CountryList]()

    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    var isRemove = false

    var notesCount : String!
    var pageNo : Int?
    var isDrag = false
  //  var isNoMorData = false
    
    var UesrID : String?
    
    @IBOutlet weak var table_view: UITableView!



    override func viewDidLoad() {
        super.viewDidLoad()
        self.getKudosNotesList()
        self.setUpData()

        // Do any additional setup after loading the view.
    }
    
    func setUpData(){
      
        self.addRefreshController()
    }
    
  
    
    
    //================================
    //MARK:-  Add Refresh Controller
    //================================
    
    func addRefreshController(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(pullToDownRefresh), for: UIControlEvents.valueChanged)
        self.table_view.addSubview(refreshControl)
        
        pullUpRefeshControl.triggerVerticalOffset = 100;
        pullUpRefeshControl.addTarget(self, action: #selector(pullUpRefreshMethod), for: UIControlEvents.valueChanged)
        self.table_view.bottomRefreshControl = pullUpRefeshControl;
    }
    
    
    
    func pullToDownRefresh() -> Void {
            isRemove = true
        //    isNoMorData = false
            self.pageNo = nil
            self.filterDict.removeAll()
            self.arrOFData.removeAll()
            self.arrOfFilterDict.removeAll()
            self.getKudosNotesList()
      

    }
    
    func pullUpRefreshMethod(){
            isRemove = false
            if(Int(notesCount) != self.pageNo){
                self.getKudosNotesList()
                
            }else{
              //  if(!isNoMorData){
                    self.removeRefreshLoader()
                    self.showToastForMoreData(message: "No more data", width: 120)
                    //self.isNoMorData = true
//                }else{
//                    self.removeRefreshLoader()
//                }
                
                
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        isDrag = true
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrOfFilterDict.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: Int(self.table_view.frame.size.width), height: 35)
        headerView.backgroundColor = UIColor.white
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 10, width:
            headerView.bounds.size.width-20, height: 20))
        headerLabel.font = Font.OpenSansRegular(fontSize: 13.0)
        headerLabel.textColor = UIColor(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
        
        let dict = self.arrOfFilterDict[section]
        print(dict)
        let firstKey = Array(dict.keys)[0]
        headerLabel.text = firstKey
        headerLabel.textAlignment = .center;
        
        //Spartor label
        let headerSparatorLbl = UILabel(frame: CGRect(x: 40, y: 34, width:
            headerView.bounds.size.width-80, height: 1))
        headerSparatorLbl.backgroundColor = UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        headerView.addSubview(headerSparatorLbl)
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        if(self.arrOfFilterDict.count != 0){
            let dict = self.arrOfFilterDict[section]
            let firstKey = Array(dict.keys)[0] // or .first
            let arr = dict[firstKey]
            return arr!.count
        }else{
            return arrOfFilterDict.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ThankYouNotesCell"
        var cell: ThankYouNotesCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ThankYouNotesCell
        if cell == nil {
            tableView.register(UINib(nibName: "ThankYouNotesCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ThankYouNotesCell

        }
        cell.bgviewOFImage.layer.borderColor = UIColor.lightGray.cgColor

        
        let dict = self.arrOfFilterDict[indexPath.section]
        let firstKey = Array(dict.keys)[0] // or .first
        let arr = dict[firstKey]
        print(indexPath.row)
        let countryList = arr![indexPath.row]
        cell.lbl_PstNm.text = countryList.kd_note
        cell.lbl_UserNm.text = countryList.usr_usrname
        DispatchQueue.main.async {
            if(countryList.profile_image != nil && countryList.profile_image != ""){
                saveImgIntoCach(strImg: countryList.profile_image!, imageView: cell.imgVe_User)
            }else{
                cell.imgVe_User.image =  UIImage(named: "helpPost_Defalt")
            }
        }
        
        
        //Share Btn Action
        cell.btnShare.addTarget(self, action: #selector(ShareBtnaction(sender:)), for: UIControlEvents.touchUpInside)
        cell.btnShare.tag = indexPath.row
        cell.btnShare.section = indexPath.section
        
       cell.btnProfileImg.addTarget(self, action: #selector(profileBtnaction(sender:)), for: UIControlEvents.touchUpInside)
        cell.btnProfileImg.tag = indexPath.row
        cell.btnProfileImg.section = indexPath.section
        
        
        //For Saparator Label
        if(indexPath.row ==  ((arr?.count)! - 1)){
              cell.lbl_Sparator_H.constant = (tableView.frame.size.width)
        }else{
            cell.lbl_Sparator_H.constant  =  (tableView.frame.size.width - 80)
        }
        
        //For Share Btn Show And Hide
        if(UesrID != getUserData()["usr_id"] as? String){ //Other User
            cell.bgViewShare_H.constant = 0
        }
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 3000
    }
    
  
    //====================================
    //MARK:- Share Btn Action Method
    //====================================
    
    @objc func ShareBtnaction (sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: sender.section)

        let dict = self.arrOfFilterDict[indexPath.section]
        let firstKey = Array(dict.keys)[0] // or .first
        let arr = dict[firstKey]
        print(indexPath.row)
        let countryList = arr![indexPath.row]
        
        let txt = String(format: "%@. I received the following note of appreciation on Communiti,  the peer-to-peer social platform for change-makers. See why here. \n%@checkCommunityApp?pstId=%@&type=hive",countryList.kd_note!,Service.Base_URL,(countryList.pst_id)!)

        self.shareNotes(message: txt)
    }

    
    
    func shareNotes(message : String){

        let text = message
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //====================================
    //MARK:- ProfileBtn Btn Action Method
    //====================================
    
    @objc func profileBtnaction (sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: sender.section)
        let dict = self.arrOfFilterDict[indexPath.section]
        let firstKey = Array(dict.keys)[0] // or .first
        let arr = dict[firstKey]
        print(indexPath.row)
        let countryList = arr![indexPath.row]
        
        
        let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "USERPROFILEVC") as! UserProfileVC
        userProfileVC.otherUserId =  countryList.usr_id
        self.navigationController?.pushViewController(userProfileVC, animated: true)

    }
    
    
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let VisibleRow = self.table_view.indexPathsForVisibleRows?.last?.section.row;
//        let lastRowIndex : Int = self.pageNo! - 1
//        if VisibleRow == lastRowIndex {
//            if(Int(self.notesCount) != self.pageNo){
//                imgVw_MorePost.image = UIImage.gifImageWithName("DropDownArrowImg")
//                self.bgViewOFMorePost_H.constant = 26
//            }else{
//                self.bgViewOFMorePost_H.constant = 0
//            }
//        }else{
//            self.bgViewOFMorePost_H.constant = 0
//        }
//    }
//
    
    //========================================================
    //MARK:- Show Thank you Notes  Post
    //========================================================
    /*
     
     1.usrToken->user token
     2.limit->limit
     3.page->page
     
     */
    func getKudosNotesList(){
        showLoader(view: windowController().view)
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "limit" : "10",
                                 "page" : isRemove  ? 0 : self.pageNo,
                                 "usrId" : UesrID]
        
        ServerCommunicator(params: dict as? Dictionary<String, Any>  , service: Service.getKudosNotesList, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weakSelf = self else { return }
            // Remove Refresh Controller
            weakSelf.removeRefreshLoader()
            killLoader()
            
            if(!isError){
                var dictResponse = response as! [String : Any]
                if(dictResponse["success"] as! Bool){
                    DispatchQueue.main.async {
                        print(response)
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                       let result =  countryResponseBody?.data?.count
                        if(weakSelf.pageNo != nil){
                            weakSelf.pageNo = (result! + weakSelf.pageNo!)

                        }else{
                            weakSelf.pageNo = result

                        }
                        //weakSelf.arrOFShowData +=  (countryResponseBody?.data)!
                        if let count = countryResponseBody?.total_count{
                            weakSelf.notesCount = count
                        }
                        weakSelf.createSection(arr: (countryResponseBody?.data)!)
                    }
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
                        
                        if( weakSelf.pageNo != nil){
                            weakSelf.showToastForMoreData(message: "No more data", width: 120)
                            return
                        }else{
                             ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: self!)
                        }
                        
                   
                     
                    }
                }
            }else{
                killLoader()
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }
    
    //=====================================
    // MARK:- Create Section for jobList
    //=====================================
    
    func createSection(arr : [CountryList]){
        
        for  objOfCountyList in arr{
            
            let strDate = dayDifference(unixTimestamp: objOfCountyList.kd_createdate!)
            
            if(self.arrOfFilterDict.count > 0){
                if let index = (self.arrOfFilterDict.index { (dict) -> Bool in    dict[strDate] != nil }){
                    var dictObj = self.arrOfFilterDict[index]
                    dictObj[strDate]?.append(objOfCountyList)
                    self.arrOfFilterDict[index] = dictObj
                }else{
                    self.arrOFData.removeAll()
                    self.filterDict.removeAll()
                    self.arrOFData.append(objOfCountyList)
                    self.filterDict[strDate] = self.arrOFData
                    self.arrOfFilterDict.append(self.filterDict)
                }
                
            }else{
                arrOFData.append(objOfCountyList)
                self.filterDict[strDate] = self.arrOFData
                self.arrOfFilterDict.append(self.filterDict)
            }
        }
        
        DispatchQueue.main.async {
            print( self.arrOfFilterDict)
            self.table_view.reloadData()
        }
    }

}
