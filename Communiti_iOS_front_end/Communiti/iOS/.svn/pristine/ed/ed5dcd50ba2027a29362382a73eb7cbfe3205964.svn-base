//
//  CompletedHRVC.swift
//  Community
//
//  Created by Hatshit on 10/02/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class CompletedHRVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate{
  
    @IBOutlet weak var lbl_Alert: UILabel!
    @IBOutlet weak var lbl_Des: UILabel!
    @IBOutlet weak var table_View: UITableView!
    var actionType : String!
    var arrOfShowData = [CountryList]()
    
    let refreshControl = UIRefreshControl()
    let pullUpRefeshControl = UIRefreshControl()
    //var pageCount : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpOfNavigationBar()
        self.setUpData()
        
    }
    
    func setUpData(){
        
        if(actionType == "COMPLETED_HELP"){
            lbl_Des.text = "Karma Points associated with all the help requests you've completed for others"
        }else if(actionType == "CREATE_HELP"){
            lbl_Des.text = "Karma Points associated with the help requests you've created and marked complete"
        }else{
            
            lbl_Des.text = "Karma Points associated with your Hive posts and answers that others have appreciated."
        }
        
        if(actionType == "COMPLETED_HELP" || actionType == "CREATE_HELP"){
            self.addRefreshController()
            self.createdOrCompletedHelpRequestKarmaPoint()
        }else{
            self.hiveContributionKarmaPoint()
        }
    }
    
    @IBAction func learnHowKmPtsWorkAction(_ sender: Any) {
        let whatsKMVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WHATSKMVC") as! WhatsKMVC
        
        self.navigationController?.pushViewController(whatsKMVC, animated: true)
    }
//================================
//MARK:-  Add Refresh Controller
//================================
    
    func addRefreshController(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(pullToDownRefresh), for: UIControlEvents.valueChanged)

    }
    
    func pullToDownRefresh() -> Void {


        self.arrOfShowData.removeAll()
        if(actionType == "COMPLETED_HELP" || actionType == "CREATE_HELP"){
            self.createdOrCompletedHelpRequestKarmaPoint()
        }
    }
    
    func pullUpRefreshMethod(){

       // self.pageCount =  self.pageCount + 1 ;
        if(actionType == "COMPLETED_HELP" || actionType == "CREATE_HELP"){
            self.createdOrCompletedHelpRequestKarmaPoint()
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
//MARK:- SetUpOfNavigationBar Tittle
//======================================
   func setUpOfNavigationBar(){
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
            if(actionType == "COMPLETED_HELP"){
                self.navigationItem.title = "COMPLETED REQUESTS"
            }else if (actionType == "CREATE_HELP"){
                self.navigationItem.title = "CREATED REQUESTS"
            }else{
                self.navigationItem.title = "HIVE CONTRIBUTIONS"
            }
    }
    
//======================================
//MARK:- Tabel view delegate methods
//======================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOfShowData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "CompletedHRVCCell"
        var cell: CompletedHRVCCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? CompletedHRVCCell
        if cell == nil {
            tableView.register(UINib(nibName: "CompletedHRVCCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CompletedHRVCCell
        }
        cell.SetUpCellMethod(actTyp: actionType, countryListObj: arrOfShowData[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let countryListObj = arrOfShowData[indexPath.row]
        
        if(actionType == "COMPLETED_HELP"){
            
        }else if (actionType == "CREATE_HELP"){
            if(countryListObj.pst_isDeleted == "0"){
            let helpReqDetaliVC = storyboard?.instantiateViewController(withIdentifier: "HelpReqDetaliVC") as! HelpReqDetaliVC
                helpReqDetaliVC.postId = countryListObj.pst_id
               navigationController?.pushViewController(helpReqDetaliVC, animated: true)
            }
        }else{
            if(countryListObj.pst_isDeleted == "0"){
               let postVC = storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
                postVC.ctyListObjFrmFeedVC = arrOfShowData[indexPath.row]
                postVC.isCameFrmNotiVC = false
                navigationController?.pushViewController(postVC, animated: true)
            }
        }
    }
    
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2000
    }
    
//====================================================================================
//MARK:- Call Service To Get List Of Completed And CReated HR Post For kram points
//====================================================================================
    /*
     1.usrToken->user token
     2.catId->(help id)
     3.helpType->COMPLETED_HELP or CREATE_HELP
     4.limit->limit
     5.page->page
     
     */
    func createdOrCompletedHelpRequestKarmaPoint() {
        
        showLoader(view: self.view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "catId" : UserDefaults.standard.value(forKey: "HelpReq_Id") as! String,
                                 "helpType" : actionType,
                                 "limit" : "10" ,
                                 "page" : self.arrOfShowData.count]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.createdOrCompletedHelpRequestKarmaPoint , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
            
                if(isError){
                    DispatchQueue.main.async {
                        killLoader()
                        weakSelf.lbl_Alert.isHidden = true
                        // Remove Refresh Controller
                        self?.removeRefreshLoader()
                        ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                        })
                        weakSelf.table_View.reloadData()
                    }
                }else{
                    
                    DispatchQueue.main.async {
                        killLoader()
                        if(weakSelf.arrOfShowData.count > 0){
                            weakSelf.lbl_Alert.isHidden = true
                            weakSelf.showToastForMoreData(message: "No more data", width: 120)
                            weakSelf.table_View.reloadData()
                        }else{
                            
                            weakSelf.lbl_Alert.isHidden = false
                           // ShowError(message: (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                        }
                        // Remove Refresh Controller
                        weakSelf.removeRefreshLoader()
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                weakSelf.lbl_Alert.isHidden = true
             //   print(response)
                 let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                   weakSelf.arrOfShowData += (countryResponseBody?.data)!
                   weakSelf.table_View.reloadData()
                   weakSelf.removeRefreshLoader()
            }
            
        })
    }

//====================================================================================
//MARK:- Call Service To Get List Of Hive Contribution For kram points
//====================================================================================
    /*
     
     1.usrToken->user token
     2.catId->(help id)
     3.limit->limit
     5.page->page
     
     */
    func hiveContributionKarmaPoint() {
        
        showLoader(view: self.view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "catId" : UserDefaults.standard.value(forKey: "HiveReq_Id") as! String]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.hiveContributionKarmaPoint , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                if(isError){
                    DispatchQueue.main.async {
                        killLoader()
                        weakSelf.lbl_Alert.isHidden = true
                        ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                        })
                        weakSelf.table_View.reloadData()
                    }
                }else{
                    
                    DispatchQueue.main.async {
                        killLoader()
                        weakSelf.table_View.reloadData()
                        //ShowError(message: (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                        weakSelf.lbl_Alert.isHidden = false

                    }
                }


                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                weakSelf.lbl_Alert.isHidden = true
                let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                print(response)
                weakSelf.arrOfShowData = (countryResponseBody?.data)!
                weakSelf.table_View.reloadData()
            }
            
        })
        
    }
   
}//END
