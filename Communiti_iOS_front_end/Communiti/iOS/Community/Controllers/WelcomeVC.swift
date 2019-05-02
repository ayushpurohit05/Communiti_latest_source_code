//
//  WelcomeVC.swift
//  Communiti_App
//
//  Created by Navjot  on 11/24/17.
//  Copyright © 2017 Aplite_info. All rights reserved.
//

import UIKit
import ObjectMapper

class WelcomeVC: UIViewController {
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var btnLink_Bootom: NSLayoutConstraint!
    
    @IBOutlet weak var btn_Link: UIButton!
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet weak var continueBtn: UIButton!
    var isCheckIdx: Int!
    var onHideComplete: ((Bool) -> Void)?
    var sltIdx : Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        btn_Link.titleLabel?.adjustsFontSizeToFitWidth = true
        continueBtn.isEnabled = false
        
        if APP_Delegate().cities.count == 0 {
             self.getCountryLocaion()
        }
  
    }
    
    
    override func viewWillLayoutSubviews() {
        
        //  request an UITraitCollection instance
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            print("iPad style UI")
            break
        case .phone:
            if(Constants.kIphone_4s){
                self.btnLink_Bootom.constant = 0
                self.scrollView.isScrollEnabled = true
            }else{
                self.btnLink_Bootom.constant = 30
                self.scrollView.isScrollEnabled = false
            }
            print("iPhone and iPod touch style UI")
            break
        default:
            print("Unspecified UI idiom")
            break
        }
    }
    
//======================================
// MARK:- Open Link Method
//======================================
    @IBAction func openLinkMethod(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "http://www.communiti.io/city-request/")! as URL)
    }
    
//======================================
// MARK:- Cuntinue Btn Action Method
//======================================
    @IBAction func continueBtn(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        APP_Delegate().isPopForLogin = false
        
        let countryList  = APP_Delegate().cities[sltIdx]
        UserDefaults.standard.set(String(format: "%@, %@", countryList.loc_name!, countryList.loc_country!), forKey: "SltCityNm")
        UserDefaults.standard.set(countryList.loc_id, forKey: "SltCity_Id")

        
        UserDefaults.standard.set(true, forKey: "isFirstTime")
        //NotificationCentreClass.fireHelpedUserlistAtChatNotifier()
        self.navigationController?.popToRootViewController(animated: false)
        
        cityEditService()
    }

//======================================
// MARK:- Call SerVice For Edit Loaction
//======================================
    func cityEditService(){
        
        let dict : Dictionary =    ["usrToken" : getUserData()["usr_token"],"locId" : UserDefaults.standard.value(forKey: "SltCity_Id")]
        
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.addAppLocation, callBack: { [weak self] (response:Any ,isError:Bool) in
            
                if(!isError){
                  var dictResponse = response as! [String : Any]
                   if(dictResponse["success"] as! Bool){
             
                }else{
                    if((response as! [String : Any])["success"] as! Bool == false){
                        if((response as! [String : Any])["message"] as! String == "Deactive" ){
                            DispatchQueue.main.async {
                                APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                            }
                            return
                        }
                    }
                    
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
                        
                        ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: self!)
                    }
                }
            }else{
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }
    
    
    
//======================================
// MARK:- Call SerVice For Get Loaction
//======================================
    func getCountryLocaion(){
        showLoader(view: self.view)// show loader
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"]]
                
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getCountryLocation , callBack: { [weak self] (response:Any ,isError: Bool) in
            
             guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                 killLoader()
                 ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                return
            }
            DispatchQueue.main.async {
                let loginResponse = Mapper<CountryResponseBody>().map(JSONObject: response)
               // print(loginResponse!)
                APP_Delegate().cities = (loginResponse?.data)!
                weakSelf.table_View.reloadData()
                killLoader()
            }
        })
    }
}


//======================================
// MARK:-Table view Delegate Method
//======================================
extension WelcomeVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APP_Delegate().cities.count //(arrOfData ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WelcomeTableViewCell
        cell.setUpCell(countryInfo: APP_Delegate().cities[indexPath.row])
        continueBtn.isEnabled = false
        continueBtn.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)
        if(sltIdx != nil){
            if(sltIdx == indexPath.row){
                cell.img_View.isHidden = false
                continueBtn.isEnabled = true
                continueBtn.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
            }else{
                cell.img_View.isHidden = true
                continueBtn.isEnabled = true
                continueBtn.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! WelcomeTableViewCell
        sltIdx = indexPath.row
        if(cell.img_View.isHidden){
            
            cell.img_View.isHidden = false
            continueBtn.isEnabled = true
            continueBtn.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
        }else{
            cell.img_View.isHidden = true
            continueBtn.isEnabled = true
            continueBtn.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
        }
       self.table_View.reloadData()
    }
}
