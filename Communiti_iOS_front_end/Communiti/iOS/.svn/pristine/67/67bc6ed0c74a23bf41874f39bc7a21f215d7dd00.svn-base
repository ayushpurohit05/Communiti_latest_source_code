//
//  KrmPotsByCatVC.swift
//  Community
//
//  Created by Hatshit on 09/02/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class KrmPotsByCatVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table_View: UITableView!

    var arrOfShowData = [CountryList]()
    var otheruser_Id : String!
    var isOtherUser : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCategoryListForKarmaPoint()

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
        return arrOfShowData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "KrmPotsByCatCell"
        var cell: KrmPotsByCatCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? KrmPotsByCatCell
        if cell == nil {
            tableView.register(UINib(nibName: "KrmPotsByCatCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? KrmPotsByCatCell
        }
        let countryListObj = arrOfShowData[indexPath.row]
        cell.lbl_CatNm.text = countryListObj.cat
        cell.lbl_KmPotsCounts.text = countryListObj.Count
        return cell
    }
    

//====================================================
//MARK:- Call Service To Get List Of KrmPots Cat List
//====================================================
    /*
     1.usrToken->user token
     2.hiveId->hive cat id
     3.helpId->help cat id

 */
    func getCategoryListForKarmaPoint() {
       
        showLoader(view: self.view)
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "hiveId" : UserDefaults.standard.value(forKey: "HiveReq_Id") as! String,
                                 "helpId" : UserDefaults.standard.value(forKey: "HelpReq_Id") as! String,
                                 "usrId" : isOtherUser ? otheruser_Id : getUserData()["usr_id"] as? String]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.getKrmPotsCatList , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                
                
                if((response as! [String : Any])["message"] as? String == "Deactive" ){
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
                
             let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)

                weakSelf.arrOfShowData = (countryResponseBody?.data)!
                weakSelf.table_View.reloadData()
             
            }
            
        })
        
    }


}
