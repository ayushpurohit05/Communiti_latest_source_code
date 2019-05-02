//
//  CategoryVC.swift
//  Community
//
//  Created by Navjot  on 12/1/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper

class CategoryVC: UIViewController , UITableViewDelegate ,UITableViewDataSource{
    
    let cellReuseIdentifier = "CategoryCell"

    @IBOutlet weak var lbl_PrgressBar: UILabel!
    var arrOfCountryListCls = [CountryList]()
    var ctrObjOFCatg : CountryList!
    var sltSubCatName : String!
    var sltGroupName : String!
    var addedTags = [Any]() // used to get data from TagVC

    @IBOutlet weak var lbl_tittle: UILabel!
    @IBOutlet weak var tbl_view: UITableView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APP_Delegate().notiResponse = nil
        
        if(APP_Delegate().reqType){
            createProgressBar(idx: 2, viewController: self)
        }else{
            let width = self.view.frame.size.width/5
            let label = UILabel(frame: CGRect(x: 0, y: 63, width: width, height: 5))
            label.text = ""
            label.clipsToBounds = true;
            label.backgroundColor = progressBarColor()
            self.view.addSubview(label)
        }
        
        self.setUpView()
        self.getHiveGroupList()
        //===========Future Useed==========
        //self.getSubCategoryList()
        //===============================
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        // To hide the tab bar and tab bar center button
        tabBarController?.tabBar.isHidden = true
        if let arrOfviews = tabBarController?.view.subviews{
            for view in arrOfviews{
                if view.isKind(of: UIButton.self) {
                    view.isHidden = true
                }
            }
        }

    }
    
    func setUpView(){
        lbl_tittle.text = APP_Delegate().reqType! ? "What topic would your post be about?" : "What category best describes your Help Request?"
    }
    
//==================================
//MARK:-Table View Delegate Method
//===================================
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfCountryListCls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CategoryCell = self.tbl_view.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CategoryCell
        let countryList = arrOfCountryListCls[indexPath.row]
        cell.categoryLbl.text = countryList.grp_title
        
        if(countryList.grp_title == self.sltGroupName){
            cell.backgroundColor =  UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        }else{
            cell.backgroundColor =  UIColor.clear
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let countryList = arrOfCountryListCls[indexPath.row]
        self.sltGroupName = countryList.grp_title
        self.tbl_view.reloadData()
        
        if(APP_Delegate().reqType){
            if(APP_Delegate().isEditHiveFld){// For edit the Hive Post

                //let countryList = arrOFShowData[cell.tag]
                let upDatePostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpDatePostVC") as! UpDatePostVC
                upDatePostVC.ctrObjOfUpdatePost = ctrObjOFCatg
                
                if let arrayOfTags : [Tags]  = ctrObjOFCatg.tags {
                    for case let obj in arrayOfTags{
                        upDatePostVC.addedTags.append(obj.htag_text ?? "")
                        
                    }
                    upDatePostVC.sltGroup_Id = countryList.grp_id
                    upDatePostVC.sltGroupName = self.sltGroupName
                    self.navigationController?.pushViewController(upDatePostVC, animated: true)
                }
            }else{ // For Simple Create Post Of Hive
                
                let newPostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
                newPostVC.ctrObjOfNewPost = countryList
                self.navigationController?.pushViewController(newPostVC, animated: true)
            }
        }else{
            if(APP_Delegate().isEditHelpFld){// For edit the help Post
                
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                let typeOfHelpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TypeOfHelp") as! TypeOfHelpVC
                
                typeOfHelpVC.cameFmFilterVC = false
                typeOfHelpVC.ctrObjOFTypOfHelp = ctrObjOFCatg
                setDataInUserDefalt(key: "HelpReqSubCatImg", userData: countryList.scat_image!)
                setDataInUserDefalt(key: "UpdateHelpReqSubCatId", userData: countryList.scat_id!)
                setDataInUserDefalt(key: "UpdateHelpReqSubCatName", userData: self.sltSubCatName!)
                self.navigationController?.pushViewController(typeOfHelpVC, animated: true)
             
            }else{   // For Simple Create Post Of Help
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                let typeOfHelpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TypeOfHelp") as! TypeOfHelpVC
    
                typeOfHelpVC.cameFmFilterVC = false
                setDataInUserDefalt(key: "HelpReqSubCatId", userData: countryList.scat_id!)
                setDataInUserDefalt(key: "HelpReqSubCatName", userData: countryList.scat_title!)
                self.navigationController?.pushViewController(typeOfHelpVC, animated: true)
            }
        }
    }
    
    //========================================================
    //MARK:- Call Service For Get Hive Group List
    //========================================================
    func getHiveGroupList(){
        /*
         1.usrToken->user token
         2.hiveId->category id
         3.locId->location id
         or
         3.usrId->login user id(when you want to get only joined group )

 */
        showLoader(view: self.view)
        let userData = getUserData()
        let dict : Dictionary = ["usrToken" : userData["usr_token"],
                                 "hiveId" : UserDefaults.standard.value(forKey: "HiveReq_Id") as! String,
                                 "usrId" : userData["usr_id"] as? String]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getHiveGroupList, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weakSelf = self else { return  }
            if(!isError){
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    let resultData = dictResponse["data"]
                    print("RESPONSE ==",resultData!)
                    DispatchQueue.main.async {
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                        //print(countryResponseBody!)
                        weakSelf.arrOfCountryListCls = (countryResponseBody?.data)!
                        weakSelf.tbl_view.reloadData()
                        killLoader()
                    }
                }else{
                    killLoader()
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                        DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                        }
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                        }
                        return
                        
                    }else{
                        ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                    }
                }
            }else{
                killLoader()
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }
    
    
//===================Future Used===========================================
//========================================================
//MARK:- Call Service For Get Sub Gategory List
//========================================================
    func getSubCategoryList(){
        
        showLoader(view: self.view)
        let userData = getUserData()
        let dict : Dictionary = ["usrToken" : userData["usr_token"],
                                 "catId" : APP_Delegate().reqType! ? UserDefaults.standard.value(forKey: "HiveReq_Id") as! String :UserDefaults.standard.value(forKey: "HelpReq_Id") as! String]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getSubcategoryList, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weakSelf = self else { return  }
            if(!isError){
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    let resultData = dictResponse["data"]
                    //print("RESPONSE ==",resultData!)
                    DispatchQueue.main.async {
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                        //print(countryResponseBody!)
                        weakSelf.arrOfCountryListCls = (countryResponseBody?.data)!
                        weakSelf.tbl_view.reloadData()
                        killLoader()
                    }
                }else{
                    killLoader()
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                        DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                        }
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                        }
                        return

                    }else{
                        ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                    }
                }
            }else{
                killLoader()
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }
}//END
