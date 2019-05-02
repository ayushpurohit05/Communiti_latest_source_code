//
//  KarmaPointsVC.swift
//  Community
//
//  Created by Hatshit on 13/02/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class KarmaPointsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var btnHowToEarnKMPts: UIButton!
    
    @IBOutlet var scrollview: UIScrollView!
    
    @IBOutlet var containerView_Bottom: NSLayoutConstraint!
    @IBOutlet weak var lbl_TotalKMPoints: UILabel!
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet weak var lbl_EarnKMPoints: UILabel!
    
    var arrOfShowData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCentreClass.registerCategoryRegisterNotifier(vc: self, selector: #selector(self.refreshKarmaPointsByNotifier))

         self.setUpData()
        //=============Future use ================
        // arrOfShowData = ["Category" , "Action"]
        //=========================================
        arrOfShowData = ["Hives" ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.lbl_TotalKMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
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
                self.containerView_Bottom.constant = 0
                self.scrollview.isScrollEnabled = true
            }else{
                self.containerView_Bottom.constant = 30
                self.scrollview.isScrollEnabled = false
            }
            print("iPhone and iPod touch style UI")
            break
        default:
            print("Unspecified UI idiom")
            break
        }
    }
    

    
    @IBAction func btnHowToEarnKmPointsAction(_ sender: Any) {
        let whatsKMVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WHATSKMVC") as! WhatsKMVC
        self.navigationController?.pushViewController(whatsKMVC, animated: true)
    }
    func setUpData()  {
        
        //Set Border Color Here
        self.btnHowToEarnKMPts.layer.borderColor = UIColor.lightGray.cgColor
        
        // To hide the tab bar and tab bar center button
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white

        
        tabBarController?.tabBar.isHidden = true
        if let arrOfviews = tabBarController?.view.subviews{
            for view in arrOfviews{
                if view.isKind(of: UIButton.self) {
                    view.isHidden = true
                }
            }
        }
    }
//======================================
//MARK:- Refresh Karma points
//======================================
    func refreshKarmaPointsByNotifier() {
        DispatchQueue.main.async {
            self.lbl_TotalKMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
        }
        
    }

//======================================
//MARK:- Tabel view delegate methods
//======================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOfShowData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "UserProfileVCCell"
        var cell: UserProfileVCCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserProfileVCCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserProfileVCCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserProfileVCCell
        }
        switch indexPath.row {
        case 0  :
            cell.lbl_ItemNM.text = arrOfShowData[indexPath.row]
            cell.imgVwOfItem.image = UIImage(named: "KPCategory")
        case 1  :
            cell.lbl_ItemNM.text = arrOfShowData[indexPath.row]
            cell.imgVwOfItem.image = UIImage(named: "KPAction")
        default : break
            //print( "default case")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0){
            
            let krmPotsByCatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KRMPOTSBYCATVC") as! KrmPotsByCatVC
            krmPotsByCatVC.isOtherUser = false
           self.navigationController?.pushViewController(krmPotsByCatVC, animated: true)
            
        }else{
            
            let krmPotsByActsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KRMPOTSBYACTSVC") as! KrmPotsByActsVC
            krmPotsByActsVC.isOtherUser = false
            self.navigationController?.pushViewController(krmPotsByActsVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60.0;//Choose your custom row height
    }
}
