//
//  FltByActivityVC.swift
//  Community
//
//  Created by Hatshit on 29/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class FltByActivityVC: UIViewController, UITableViewDataSource , UITableViewDelegate{

    var arrOfShowData = [String]()
    var arrOfSltActNmOfActyVC = [Any]()

    var callBackFrmFltActivity: ((Bool , [Any]) -> Void)?
    var sltIdx : Int!
    
    @IBOutlet weak var table_View: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideTabBar()
        arrOfShowData = ["Most upvotes" ,"Most comments"]

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
        return arrOfShowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "FltByActivityCell"
        var cell: FltByActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? FltByActivityCell
        if cell == nil {
            tableView.register(UINib(nibName: "FltByActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FltByActivityCell
        }
      
            
        
        cell.lbl_Tittle.text = arrOfShowData[indexPath.row]

        
        let predicates  = NSPredicate(format: "self MATCHES %@", String(format: "%@", arrOfShowData[indexPath.row]))
        
        let filterArray = (self.arrOfSltActNmOfActyVC as NSArray).filtered(using: predicates)
        
        if(sltIdx != nil){
            
            if(sltIdx == indexPath.row){
                cell.img_ViewCheckMark.isHidden = false
            }else{
                cell.img_ViewCheckMark.isHidden = true
            }
            
        }else{
            if(filterArray.count != 0){
                cell.img_ViewCheckMark.isHidden = false
            }else{
                cell.img_ViewCheckMark.isHidden = true
            }
            
        }
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FltByActivityCell
        
           sltIdx = indexPath.row
            if(cell.img_ViewCheckMark.isHidden == true){
                cell.img_ViewCheckMark.isHidden = false
                
                if self.callBackFrmFltActivity != nil {
                    self.callBackFrmFltActivity!(true , [cell.lbl_Tittle.text!])
                }
            }else{
                cell.img_ViewCheckMark.isHidden = true
                
//                if self.callBackFrmFltActivity != nil {
//                    self.callBackFrmFltActivity!(false , [cell.lbl_Tittle.text!])
//                }
            }
  
         self.table_View.reloadData()
     
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2000
    }

}
