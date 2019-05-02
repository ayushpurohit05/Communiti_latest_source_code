//
//  ReportView.swift
//  Community
//
//  Created by Navjot  on 2/26/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class ReportView: UIView, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var containerVw: UIView!
   // var listOfReport : [CountryList]!
    var type : String!
    var id : String!
    var countryListObj : CountryList!
    var repostStatusOFChat : String!
    var isRepostForChat : Bool!
    var chatHomeDataModel : ChatHomeDM!
    var MYchatHomeDataModel : MYChatHomeDM!
    var typeOfPst : String!
    var isChatScreen : Bool!
    var isAnswer : Bool!

    var otherUsrID : String!
    var callbackReport: ((Bool) -> Void)?
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first!
        if (touch.view == bgView){
            DispatchQueue.main.async {
                self.removeReportView()
                
            }
        }
    }
    
    override func awakeFromNib() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reportViewCell")
        tableView.delegate = self
        tableView.dataSource = self
     }
    
    
    func removeReportView(sender: UITapGestureRecognizer? = nil) {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.bgView.alpha = 0.0
                        self.containerVw.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: { (finished) -> Void in
            self.removeFromSuperview()
        })
    }
    
    //==============================
    //MARK: Cancel Button Action
    //==============================
    @IBAction func cancelButton(_ sender: Any) {
        removeReportView()
    }
    
    
    //========================================================
    //MARK: TableView Delegate and Datasource Methods
    //========================================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if APP_Delegate().listOfReport != nil{
            return APP_Delegate().listOfReport.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = UIFont(name: "Lucida Sans", size: 14)
        
        if APP_Delegate().listOfReport != nil{
            cell.textLabel?.text = APP_Delegate().listOfReport[indexPath.row].scat_title
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .black
        addReport(scat_id:APP_Delegate().listOfReport[indexPath.row].scat_id)
    }
    
    //======================================
    // MARK:- Call SerVice For Add Report
    //======================================

    func addReport(scat_id:String?){
        showLoader(view: self)// show loader

        var psd = String()
        
        if countryListObj != nil{
            if (isChatScreen != nil && isChatScreen == true){
                // psd = countryListObj.usr_id!
                psd = countryListObj.pst_id!
            }else if(isAnswer != nil && isAnswer == true){
                psd = countryListObj.ans_id!
            }else{
                psd = countryListObj.pst_id!
            }
        }else{
            if chatHomeDataModel != nil {
                //psd = chatHomeDataModel.pst_usr_id!
                psd = chatHomeDataModel.pst_id!
            }else if(MYchatHomeDataModel != nil){
                // psd = otherUsrID
                psd = MYchatHomeDataModel.pst_id!
            }
        }
        
        
        
        
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],"scatId":scat_id,"type":self.type,"rptForId":psd]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.addUserReport, callBack: { [weak self] (response:Any ,isError: Bool) in
            //guard let weakSelf = self?.vc else { return }
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                
                var alert = UIAlertController(title: "Alert",message:isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String,
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK",style:UIAlertActionStyle.default,handler: nil))
                self?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                
                return
            }
            
            let dictResponse = response as! NSDictionary
            DispatchQueue.main.async {
                
                if self?.countryListObj != nil{
                    if (self?.isChatScreen != nil && self?.isChatScreen == true){
                        self?.countryListObj.chat_report = "YES"
                    }else if(self?.isAnswer != nil && self?.isAnswer == true){
                        self?.countryListObj.usr_report = "YES"
                    }else{
                        self?.countryListObj.usr_report = "YES"
                    }
                }else{
                    if self?.chatHomeDataModel != nil {
                        self?.chatHomeDataModel.chat_report = "YES"
                    }else if(self?.MYchatHomeDataModel != nil){
                        self?.MYchatHomeDataModel.chat_report = "YES"
                    }
                }
                
                if self?.callbackReport != nil {
                    self?.callbackReport!(true)
                }
                
            windowController().showToast(message: (response as! [String : Any])["message"]  as! String, width: 200)
                self?.removeReportView()
                killLoader()
            }
        })
    }
    
    //======================================
    // MARK:- Call SerVice For Get List
    //======================================
    func getReportList(controller : UIViewController? , countryList : CountryList){
        
        self.countryListObj = countryList
        self.isRepostForChat = false
      
        if (APP_Delegate().listOfReport != nil) && APP_Delegate().listOfReport.count > 0 {
            
            self.tableView.reloadData()
            if (tableView.contentSize.height < tableView.frame.size.height) {
                tableView.isScrollEnabled = false}
            else {
                tableView.isScrollEnabled = true}
            
            return
        }
        
        
        getDataFromServer(controller: controller)
    }
    
    
    //======================================
    // MARK:- Call SerVice For Get List
    //======================================
    func getReportListAtChat(controller : UIViewController? , nsObj : NSObject , type : String ){
        
        self.isRepostForChat = true
        self.typeOfPst = type
    
        if(type == "MY_CHAT"){
            MYchatHomeDataModel = nsObj as? MYChatHomeDM
        }else{
            chatHomeDataModel = nsObj as? ChatHomeDM
        }
   
        if (APP_Delegate().listOfReport != nil) && APP_Delegate().listOfReport.count > 0 {
            
             self.tableView.reloadData()
            if (tableView.contentSize.height < tableView.frame.size.height) {
                tableView.isScrollEnabled = false }
            else {
                tableView.isScrollEnabled = true}
            
            return
        }
        getDataFromServer(controller: controller)
    }
    /*
     1.usrToken->user token
     2.scatType->enum('REPORT', 'KUDOS')
    */
    func getDataFromServer(controller : UIViewController?) -> Void {
        
        showLoader(view: self)
        
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "scatType" : "REPORT"]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getReportListData, callBack: { [weak self] (response:Any ,isError: Bool) in
            guard let weakSelf = controller else { return }
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                return
            }
        
            DispatchQueue.main.async {
                let loginResponse = Mapper<CountryResponseBody>().map(JSONObject: response)

                APP_Delegate().listOfReport = (loginResponse?.data)!
                
                self?.tableView.reloadData()
                killLoader()
            }
        })
    }
}
