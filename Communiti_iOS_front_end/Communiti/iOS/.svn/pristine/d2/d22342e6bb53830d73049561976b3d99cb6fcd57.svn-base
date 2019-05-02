//
//  FltByCategoryVC.swift
//  Community
//
//  Created by Hatshit on 29/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class FltByCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tab_View: UITableView!
    var arrOfCryLstObj = [CountryList]()
    var arrOfSltCatNmOfFltCagVC = [Any]()
    var callBackFrmFltCat: ((Bool , [[String : Any]]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideTabBar()
        self.getSubCategoryList()

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        
        
//        if self.callBackFrmFltCat != nil {
//            self.callBackFrmFltCat!(false , arrOfSltCatNmOfFltCagVC)
//        }
//        
    }
    
    
    func hideTabBar(){
        
        tabBarController?.tabBar.isHidden = true
        let arrOfviews = tabBarController?.view.subviews
        for view in arrOfviews!{
            if view.isKind(of: UIButton.self) {
                view.isHidden = true
            }
        }
    }

//======================================
// MARK:-Table View Delegate Methods
//======================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOfCryLstObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "FltByCatCell"
        var cell: FltByCatCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? FltByCatCell
        if cell == nil {
            tableView.register(UINib(nibName: "FltByCatCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FltByCatCell
        }
        
        
        let countryList = arrOfCryLstObj[indexPath.row]
        cell.lbl_CatNm.text = countryList.scat_title
        
        
        let predicates  = NSPredicate(format: "self MATCHES %@", String(format: "%@", countryList.scat_title!))

          let filterArray = (self.arrOfSltCatNmOfFltCagVC as NSArray).filtered(using: predicates)
        if(filterArray.count != 0){
            cell.imgViewCheckMark.isHidden = false
        }else{
            
            cell.imgViewCheckMark.isHidden = true
        }
        
        

       // cell.imgViewCheckMark.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FltByCatCell
        
        
        let countryList = arrOfCryLstObj[indexPath.row]
        let dict  =  ["scat_title" : countryList.scat_title,
                      "scat_id" : countryList.scat_id]
        

        if(cell.imgViewCheckMark.isHidden == true){
            cell.imgViewCheckMark.isHidden = false

            if self.callBackFrmFltCat != nil {
                self.callBackFrmFltCat!(true , [dict as Any as! Dictionary<String, Any>])
            }
        }else{
            cell.imgViewCheckMark.isHidden = true

            if self.callBackFrmFltCat != nil {
                self.callBackFrmFltCat!(false , [dict as Any as! Dictionary<String, Any>])
            }
        }
  
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2000
    }
    
    
//========================================================
//MARK:- Call Service For Get Sub Gategory List
//========================================================
    func getSubCategoryList(){
        
        showLoader(view: self.view)
        let userData = getUserData()
        let dict : Dictionary = ["usrToken" : userData["usr_token"],
                                 "catId" : APP_Delegate().reqType! ? UserDefaults.standard.value(forKey: "HiveReq_Id") as! String :UserDefaults.standard.value(forKey: "HelpReq_Id") as! String]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getSubcategoryList, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                
                return
            }
           
                    DispatchQueue.main.async {
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                        //print(countryResponseBody!)
                        weakSelf.arrOfCryLstObj = (countryResponseBody?.data)!
                        weakSelf.tab_View.reloadData()
                        killLoader()
                    }
            
                
         
        })
    }

}
