//
//  EditCityVC.swift
//  Community
//
//  Created by Hatshit on 22/02/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class EditCityVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var urlButton: UIButton!
    

    var sltIdx : Int!
    var vc : UserProfileVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if APP_Delegate().cities.count == 0 {
             self.getCountryLocaion()
        }
        urlButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//======================================
// MARK:- Action of SAVE button
//======================================
    @IBAction func saveButton(_ sender: Any) {
      UserDefaults.standard.set(String(format: "%@, %@", APP_Delegate().cities[sltIdx].loc_name!, APP_Delegate().cities[sltIdx].loc_country!), forKey: "SltCityNm")
        cityEditService(locId: APP_Delegate().cities[sltIdx].loc_id!)
    }
    
    
//======================================
// MARK:- Open Link Method
//======================================
    @IBAction func urlAction(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "http://www.communiti.io/city-request/")! as URL)
    }
    
    
//======================================
// MARK:- Call SerVice For Edit Loaction
//======================================
    func cityEditService(locId: String){
        
        showLoader(view: self.view)
        
        let dict : Dictionary =    ["usrToken" : getUserData()["usr_token"],"locId" : locId]
        
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.addAppLocation, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            if(!isError){
                var dictResponse = response as! [String : Any]
                if(dictResponse["success"] as! Bool){
                    DispatchQueue.main.async {
                        
                        btnClickEvent(caregoryNm: "Edit Profile", action: "Edit City", label: "")
                        
                        let locCity = APP_Delegate().cities[(self?.sltIdx)!].loc_name
                        
                        let locCountry = APP_Delegate().cities[(self?.sltIdx)!].loc_country
                        
                        self?.vc.lbl_CityNm.text = String(format: "%@, %@", locCity!, locCountry!)
                        
                        UserDefaults.standard.set(String(format: "%@, %@", (APP_Delegate().cities[(self?.sltIdx)!].loc_name!), (APP_Delegate().cities[(self?.sltIdx)!].loc_country!)), forKey: "SltCityNm")
                        
                        UserDefaults.standard.set(APP_Delegate().cities[(self?.sltIdx)!].loc_id! , forKey: "SltCity_Id")
                        
                        self?.navigationController?.popViewController(animated: true)
                    }
                }else{
                    
                     if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                        }
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
                weakSelf.tableView.reloadData()
                killLoader()
            }
        })
    }
}


//======================================
// MARK:-Table view Delegate Method
//======================================
extension EditCityVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print(APP_Delegate().cities.count)
        return APP_Delegate().cities.count //(arrOfData ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WelcomeTableViewCell
        cell.setUpCell(countryInfo: APP_Delegate().cities[indexPath.row])
        //print(cell.countryLbl)
        if(sltIdx != nil){
            if(sltIdx == indexPath.row){
                cell.img_View.isHidden = false
            }else{
                cell.img_View.isHidden = true
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! WelcomeTableViewCell
        sltIdx = indexPath.row
        
        if(cell.img_View.isHidden){
            cell.img_View.isHidden = false
        }else{
            cell.img_View.isHidden = true
        }
        self.tableView.reloadData()
        
    }
}
