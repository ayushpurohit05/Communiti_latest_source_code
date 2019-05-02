//
//  KrmPotsByActsVC.swift
//  Community
//
//  Created by Hatshit on 09/02/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class KrmPotsByActsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var arrOfShowData = [CountryList]()
    var dictResponse : [String :String]!
    var otheruser_Id : String!
    var isOtherUser : Bool!
    
    @IBOutlet weak var table_View: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
          self.getActionListForKarmaPoint()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func learnHowKmPtsWorkAction(_ sender: Any) {
        let whatsKMVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WHATSKMVC") as! WhatsKMVC
        
        self.navigationController?.pushViewController(whatsKMVC, animated: true)
    }

//======================================
//MARK:- Tabel view delegate methods
//======================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        //return arrOfShowData.count
        if(dictResponse == nil){
            return 0
        }else{
            return dictResponse.keys.count
        }

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "KrmPotsByActsCell"
        var cell: KrmPotsByActsCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? KrmPotsByActsCell
        if cell == nil {
            tableView.register(UINib(nibName: "KrmPotsByActsCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? KrmPotsByActsCell
        }
        
        switch indexPath.row {
            
// ==================== Future Use =================================
//        case 0  :
//            cell.lbl_Tittle.text = "Successfully Completed Help Requests"
//            cell.lbl_KMPointsCounts.text = dictResponse["successfully_completed_help_request"]
//            cell.imgVw_NviArrow?.isHidden = isOtherUser ? true : false
//        case 1  :
//            cell.lbl_Tittle.text = "Successfully Created Help Requests"
//            cell.lbl_KMPointsCounts.text = dictResponse["successfully_created_help_request"]
//            cell.imgVw_NviArrow?.isHidden = isOtherUser ? true : false
    // ================================================================
        case 0  :
            cell.lbl_Tittle.text = "Helpful Hive Contributions"
            cell.lbl_KMPointsCounts.text = dictResponse["helpful_hive_contribution"]
            cell.imgVw_NviArrow?.isHidden = isOtherUser ? true : false
        case 1  :
            cell.lbl_Tittle.text = "Sign Up"
            cell.lbl_KMPointsCounts.text = dictResponse["sign_up"]
            cell.imgVw_NviArrow?.isHidden = isOtherUser ? true : true
        default : break
            //print( "default case")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(!isOtherUser){
            let completedHRVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "COMPLETEDHRVC") as! CompletedHRVC
            
            switch indexPath.row{
// ==================== Future Use =================================

//            case 0  :
//                completedHRVC.actionType = "COMPLETED_HELP"
//            case 1  :
//                completedHRVC.actionType = "CREATE_HELP"
  //================================================================
            case 0  :
                completedHRVC.actionType = ""
            default : break
                // print( "default case")
            }
            
            if(indexPath.row != 3){
                self.navigationController?.pushViewController(completedHRVC, animated: true)
            }
        }
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 60.0;//Choose your custom row height
        }
    
    
//====================================================
//MARK:- Call Service To Get List Of KrmPots Cat List
//====================================================
    /*
     1.usrToken->user token
     2.count->send some value if you want to get total count else blank
     3.helpId->help cat id

     */
    func getActionListForKarmaPoint() {
        
        showLoader(view: self.view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "count" : "",
                                 "helpId" : UserDefaults.standard.value(forKey: "HelpReq_Id") as! String,
                                 "hiveId" : UserDefaults.standard.value(forKey: "HiveReq_Id") as! String,
                                 "usrId" : isOtherUser ? otheruser_Id : getUserData()["usr_id"] as? String]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.getKrmPotsActsList , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                
                if((response as! [String : Any])["message"] as! String == "Deactive" ){
                    DispatchQueue.main.async {
                        APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: (self?.tabBarController as? TabBarController)!)
                    }
                     return
                }
                
                
                
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                weakSelf.dictResponse = (response as! [String : Any])["data"] as! [String : String]
                weakSelf.table_View.reloadData()
            }
        })
    }

}
