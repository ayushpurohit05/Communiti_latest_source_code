//
//  HiveHomeVC.swift
//  Communiti
//
//  Created by mac on 23/05/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class HiveHomeVC: UIViewController , UITableViewDataSource , UITableViewDelegate{
    @IBOutlet weak var bannerView_H: NSLayoutConstraint!
    @IBOutlet var table_View: UITableView!
    
    @IBOutlet var lbl_CountryNm: UILabel!
    var arrOFShowData = [CountryList]()
    var lbl_ShowKMPoints : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCentreClass.registerRefreshKarmaPointsNotifier(vc: self, selector: #selector(self.refreshKarmapoints))

        
        self.addKarmaPointsButtons()
       // self.getGroupList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        DispatchQueue.main.async {
            
            self.getGroupList()
            UserDefaults.standard.set(false, forKey: "isJoinedGrp")
            self.moveAutomaticallyOnTopOFTableView()
            //Sected img of secound tab bar item and un sected ing set from tab bar class
            self.tabBarController?.tabBar.items![1].selectedImage = UIImage(named: "hexgon_icon")?.withRenderingMode(.alwaysOriginal)
            
            self.table_View.reloadData()
            self.setUpData()
        }
    }
    
    func setUpData(){
        DispatchQueue.main.async {
//            let crt_Id = UserDefaults.standard.value(forKey: "SltCity_Id") as? String
//            self.lbl_CountryNm.text = crt_Id == "1" ? "Explore Boston Hives" : "Explore Indore Hives"
            self.navigationController?.navigationBar.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
            self.manageTabbarItemsize()
            let arrOfviews = self.tabBarController?.view.subviews
            for view in arrOfviews!{
                if view.isKind(of: UIButton.self) {
                    view.isHidden = false
                }
            }
        }
    }
    
    func moveAutomaticallyOnTopOFTableView(){
        self.table_View.setContentOffset(CGPoint.zero, animated: true)
    }
    
//================================
//MARK:-Add Karma Points Button
//================================
    
    func addKarmaPointsButtons() -> Void {
        //create a new button
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "karmaPoint"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(KrmapointsBtnAction(btn:)), for: .touchUpInside)
        button.frame = CGRect(x: 50, y: 0, width: 50, height: 50)
        let barButton = UIBarButtonItem(customView: button)
        
        
         lbl_ShowKMPoints = UILabel()
        lbl_ShowKMPoints.frame = CGRect(x: 0, y: 1, width: 50, height: 48)
        lbl_ShowKMPoints.backgroundColor = UIColor.clear
        lbl_ShowKMPoints.textColor = UIColor.white
        lbl_ShowKMPoints.textAlignment = .center
        lbl_ShowKMPoints.alignmentRect(forFrame: button.frame)
        
        //lbl.font = lbl.font.withSize(12)
        lbl_ShowKMPoints.font = UIFont(name: "LucidaSans", size: 12.0)
        
        if(UserDefaults.standard.value(forKey: "TotalKMPoints") != nil){
            lbl_ShowKMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
        }else{
            lbl_ShowKMPoints.text = "0"
        }
        
        APP_Delegate().lbl_KMPoints = lbl_ShowKMPoints
        button.addSubview(lbl_ShowKMPoints)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func refreshKarmapoints(_ notification: Any){
        if(UserDefaults.standard.value(forKey: "TotalKMPoints") != nil){
            lbl_ShowKMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
        }else{
            lbl_ShowKMPoints.text = "0"
        }
        
        APP_Delegate().lbl_KMPoints = lbl_ShowKMPoints
    }
    
    
    
    //================================
    //MARK:- Karma Points Btn Action Method
    //================================
    @objc func KrmapointsBtnAction(btn: UIButton){//Perform actions here
        
        btnClickEvent(caregoryNm: "Karma Points", action: "Clicked Karma Points", label: "")
        
        let karmaPointsVC = storyboard?.instantiateViewController(withIdentifier: "KARMAPOINTSVC") as! KarmaPointsVC
        
        navigationController?.pushViewController(karmaPointsVC, animated: true)
        
    }
    
    //================================
    //MARK:- Manage TabbarItem Size
    //================================
    
    func manageTabbarItemsize(){
        let tabBarItem = tabBarController?.tabBar.items
        
        
        for item in tabBarItem!{
            item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
            switch (item.tag) {
            case 0:
                
                item.imageInsets = UIEdgeInsetsMake(7, 1, -4, 3)
                break;
            case 1:
                item.imageInsets = UIEdgeInsetsMake(7, 1, -4, 2)
                break;
            case 2:
                
                
                break;
            case 3:
                item.imageInsets = UIEdgeInsetsMake(8, 2, -5, 2)
                break;
            case 4:
                item.imageInsets = UIEdgeInsetsMake(8, 5, -5, 0);
                break;
                
            default:
                break;
            }
        }
        
    }
    
//================================
//MARK:- Btn Action Method
//================================
    @IBAction func btnActionMethod(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.bannerView_H.constant = 1;
            self.view.layoutIfNeeded()
        },
                       completion: { (finished) -> Void in
        })
     
    }
    
    
    @IBAction func btnShareLink(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "http://www.communiti.io/suggest-hive")! as URL)
    }
    //=====================================
    //MARK:-  Table View Delegate Method
    //=====================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOFShowData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "HiveHomeCell"
        var cell: HiveHomeCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? HiveHomeCell
        if cell == nil {
            tableView.register(UINib(nibName: "HiveHomeCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HiveHomeCell
        }
        
        let countryList = self.arrOFShowData[indexPath.row]
        cell.setUpOfCellMethod(countryList: countryList)
        cell.joinBtn.addTarget(self, action: #selector(joinBtnAction(btn:)), for: .touchUpInside)
        cell.joinBtn.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
           let strugglingVC = storyboard?.instantiateViewController(withIdentifier: "STRUGGLINGVC") as! StrugglingVC
           strugglingVC.countryListOFHiveHm =  self.arrOFShowData[indexPath.row]
           navigationController?.pushViewController(strugglingVC, animated: true)

    }
    
    
    @objc func joinBtnAction(btn: UIButton){//Perform actions here
        let countryList = self.arrOFShowData[btn.tag]
        self.joinGroup(countryListObj : countryList)
        
    }

    
    
    //========================================================
    // MARK:- Call SerVice For get Group  List
    //========================================================
    
    func getGroupList(){
        /*
         1.usrToken->user token
         2.hiveId->category id
         3.locId->location id
         or
         3.usrId->login user id(when you want to get only joined group )
*/
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "hiveId" :  UserDefaults.standard.value(forKey: "HiveReq_Id") as! String,
                                 "usrId" :  ""]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.getHiveGroupList , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                if(!isError){
                    
                    if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                        }
                        return
                    }
                    
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                            APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                        }
                        return
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: (self?.tabBarController as? TabBarController)!)
                            
                        }
                        return
                    }
                }else{
                    killLoader()
                    ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                }
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
           //     print(response)
                let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                    weakSelf.arrOFShowData = (countryResponseBody?.data)!
                    weakSelf.table_View.reloadData()
            
            }
        })
    }
    
//========================================================
// MARK:- Call SerVice For get Group  List
//========================================================

    func joinGroup(countryListObj : CountryList){
        /*
         1.usrToken->user token
         2.grpId->group id
         */
        let dict : Dictionary = ["usrToken" :  getUserData()["usr_token"],
                                 "grpId" :  countryListObj.grp_id]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any>  , service: Service.joinGroupByUser , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                if(!isError){
                    
                    if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String, controller: (self?.tabBarController as? TabBarController)!)
                        }
                        return
                    }
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                            APP_Delegate().tokenExpired(controller: (weakSelf.tabBarController as? TabBarController)!)
                        }
                        return
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: (self?.tabBarController as? TabBarController)!)
                            
                        }
                        return
                    }
                }else{
                    killLoader()
                    ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller:  windowController())
                }
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                print(response)
                
                countryListObj.usr_join = "YES"
                weakSelf.table_View.reloadData()
                
               // let strugglingVC = weakSelf.storyboard?.instantiateViewController(withIdentifier: "STRUGGLINGVC") as! StrugglingVC
               // strugglingVC.countryListOFHiveHm =  countryListObj
                APP_Delegate().isRefreshFeedVClist = true
                //weakSelf.navigationController?.pushViewController(strugglingVC, animated: true)
                
                
                
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}//END
