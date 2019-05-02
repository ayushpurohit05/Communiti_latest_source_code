//
//  FilterHomeVC.swift
//  Community
//
//  Created by Hatshit on 29/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class FilterHomeVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tab_View: UITableView!
    @IBOutlet weak var btnApplyFlt: UIButton!
    @IBOutlet weak var lbl_Filter: UILabel!
    

    var arrOfShowData = [String]()
    var arrOfSltCatIds = [String]()
    var arrOfSltCatNm = [String]()
   // var arrOfSltActyNm = [String]()
    var arrOfSltActyNmOrLotn = [String]()
    var addedTags = [Any]() // used to get data from TagVC

    var callBackFromFltHomeVC: ((Bool , [Any] , [Any] , [Any] , [Any]) -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()

        btnApplyFlt.isUserInteractionEnabled = false
      //  btnApplyFlt.alpha = 0.5
        btnApplyFlt.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)


       arrOfShowData = APP_Delegate().reqType == true ? ["Filter By Category" ,"Filter By Tag", "Filter By Activity" ]:   ["Filter By Category" ,"Filter By Tag" ,"Filter By Location"]
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        DispatchQueue.main.async {

           self.tabBarController?.tabBar.isHidden = false
           for view in (self.tabBarController?.view.subviews)!{
            if view.isKind(of: UIButton.self) {
                        view.isHidden = false
                }
            }
        }
    }
    
    func ShowDataForCategoryFileld( cell : FilterHomeCell, arr : [String]){
        
        let bgView_W = cell.bgViewOfLblDes.frame.size.width
        cell.lbl_Des1_W.constant = bgView_W
        
        self.manageFltCountOfFilterLabel()
        for obj in arr{
            
            if(cell.lbl_Des1.text != ""){

                cell.lbl_Des1.text =  String(format: "%@, %@ ", cell.lbl_Des1.text!,obj )

            }else{

                cell.lbl_Des1.text =  String(format: "%@", obj)
                
            }
        }
    }
    
    
    @IBAction func btnFeedAction(_ sender: Any) {
        
        self.arrOfSltCatNm.removeAll()
        self.arrOfSltCatIds.removeAll()
        self.arrOfSltActyNmOrLotn.removeAll()
        self.addedTags.removeAll()
        
        self.manageFltCountOfFilterLabel()
        self.tab_View.reloadData()
        
        if self.callBackFromFltHomeVC != nil {
            //APP_Delegate().isFltEnable = false
            self.callBackFromFltHomeVC!(false , arrOfSltActyNmOrLotn ,arrOfSltCatIds, addedTags , arrOfSltCatNm)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnApplyFltAction(_ sender: Any) {
        
        if self.callBackFromFltHomeVC != nil {
           // APP_Delegate().isFltEnable = true
            self.callBackFromFltHomeVC!(true , arrOfSltActyNmOrLotn ,arrOfSltCatIds, addedTags , arrOfSltCatNm)
        }
        self.navigationController?.popViewController(animated: true)
  
    }

    @IBAction func btnResetAction(_ sender: Any) {
  
        
        self.arrOfSltCatNm.removeAll()
        self.arrOfSltCatIds.removeAll()
        self.arrOfSltActyNmOrLotn.removeAll()
        self.addedTags.removeAll()
        self.manageFltCountOfFilterLabel()
        self.tab_View.reloadData()
        
        if self.callBackFromFltHomeVC != nil {
            //APP_Delegate().isFltEnable = false
            self.callBackFromFltHomeVC!(false , arrOfSltActyNmOrLotn ,arrOfSltCatIds, addedTags , arrOfSltCatNm)
        }
    }
    
 
    
//======================================
// MARK:-Table View Delegate Methods
//======================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return  arrOfShowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "FilterHomeCell"
        var cell: FilterHomeCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? FilterHomeCell
        if cell == nil {
            tableView.register(UINib(nibName: "FilterHomeCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FilterHomeCell
        }
        
  
            
            cell.lbl_FilterTyp.text = arrOfShowData[indexPath.row]
            cell.lbl_Des1.text = ""
        if(indexPath.row == 0){
            ShowDataForCategoryFileld(cell: cell, arr: self.arrOfSltCatNm)

        }else if(indexPath.row == 1){
            
            ShowDataForCategoryFileld(cell: cell, arr: self.addedTags as! [String])

        }else{
            
            ShowDataForCategoryFileld(cell: cell, arr: self.arrOfSltActyNmOrLotn)

        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterHomeCell

        
        if(indexPath.row == 0){
            let fltByCategoryVC = storyboard?.instantiateViewController(withIdentifier: "FLTBYCATEGORYVC") as! FltByCategoryVC
            
            fltByCategoryVC.arrOfSltCatNmOfFltCagVC = arrOfSltCatNm
            
            
            fltByCategoryVC.callBackFrmFltCat = {(isSlt : Bool , arrOfCatNm : [[String : Any]]) -> Void in
                if(isSlt){
             
                    if(cell.lbl_Des1.text != ""){
                        
                        cell.lbl_Des1.text =  String(format: "%@, %@ ", cell.lbl_Des1.text!,((arrOfCatNm[0])["scat_title"] as? String)!)
                        
                    }else{
                        
                        cell.lbl_Des1.text =  String(format: "%@",((arrOfCatNm[0])["scat_title"] as? String)!)
                        
                    }
                    self.arrOfSltCatNm.append(((arrOfCatNm[0])["scat_title"] as? String)!)
                    self.arrOfSltCatIds.append(((arrOfCatNm[0])["scat_id"] as? String)!)
                    
                    //let lbl_W = cell.lbl_Des1.intrinsicContentSize.width
                    let bgView_W = cell.bgViewOfLblDes.frame.size.width
                    cell.lbl_Des1_W.constant = bgView_W
                }else{ // Deselect
                   
                    let predicates  = NSPredicate(format: "self MATCHES %@", String(format: "%@", ((arrOfCatNm[0])["scat_title"] as? String)!))
                    
                    let filterArray = (self.arrOfSltCatNm as NSArray).filtered(using: predicates)
                    if(filterArray.count != 0){
                        if let index = self.arrOfSltCatNm.index(of: ((arrOfCatNm[0])["scat_title"] as? String)!) {
                            self.arrOfSltCatNm.remove(at: index)
                            self.arrOfSltCatIds.remove(at: index)
                             cell.lbl_Des1.text = ""
                            if(self.arrOfSltCatNm.count != 0){

                                for (idx, obj) in self.arrOfSltCatNm.enumerated(){
                                    if(idx == 0){
                                        
                                        cell.lbl_Des1.text =  String(format: "%@", obj  )

                                    }else{
                                        cell.lbl_Des1.text =  String(format: "%@, %@ ", cell.lbl_Des1.text!, obj )

                                    }
                                    
                                }
                                
                            }else{
                                cell.lbl_Des1_W.constant = 0
                                
                            }
                          
                        }
                    }
                }
        
                self.manageFltCountOfFilterLabel()
  
            }
            navigationController?.pushViewController(fltByCategoryVC, animated: true)
        }else if(indexPath.row == 1){
            
            
            let addTagVC  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTagCon") as! AddTagVC
            addTagVC.isMoveFromFltHomeVC = true
            
            addTagVC.arrOfTag = addedTags as! [String]
            self.addedTags.removeAll()
            addTagVC.callForFltHomeVC = {(isAddTags : Bool , tagArry : [Any]) -> Void in
                
                if(isAddTags){
                    if(tagArry.count != 0){
    
                        let bgView_W = cell.bgViewOfLblDes.frame.size.width
                        cell.lbl_Des1_W.constant = bgView_W
                        for (idx, obj) in tagArry.enumerated(){
                            if(idx == 0){
                                
                                cell.lbl_Des1.text =  String(format: "%@", obj as! String )
                            }else{
                                
                                cell.lbl_Des1.text =  String(format: "%@, %@ ", cell.lbl_Des1.text!, obj as! String)
                            }
                            
                          self.addedTags.append(obj)
                        }
                    }else{
                        
                        cell.lbl_Des1_W.constant = 0
                    }
                }
                
                self.manageFltCountOfFilterLabel()

            }
            self.navigationController?.pushViewController(addTagVC, animated: true)
   
        }else{
            if(cell.lbl_FilterTyp.text == "Filter By Activity"){ // Filter By Activity
            let fltByActivityVC = storyboard?.instantiateViewController(withIdentifier: "FLTBYACTIVITYVC") as! FltByActivityVC
            
            fltByActivityVC.arrOfSltActNmOfActyVC = arrOfSltActyNmOrLotn

            
            fltByActivityVC.callBackFrmFltActivity = {(isSltActivityNm : Bool , arrActyNm : [Any]) -> Void in
                if(isSltActivityNm){
                    
                    cell.lbl_Des1.text = ""
                    if(cell.lbl_Des1.text != ""){
                        
                        cell.lbl_Des1.text =  String(format: "%@, %@ ", cell.lbl_Des1.text!,(arrActyNm[0] as? String)! )
                    }else{
                        
                        cell.lbl_Des1.text =  String(format: "%@",(arrActyNm[0] as? String)!  )
                        
                    }
                    self.arrOfSltActyNmOrLotn.removeAll()
                    self.arrOfSltActyNmOrLotn.append((arrActyNm[0] as? String)! )
                    //let lbl_W = cell.lbl_Des1.intrinsicContentSize.width
                    let bgView_W = cell.bgViewOfLblDes.frame.size.width
                    cell.lbl_Des1_W.constant = bgView_W
          
                }
//                }else{ // Deselect
//
//                    
//                    
//                    let predicates  = NSPredicate(format: "self MATCHES %@", String(format: "%@", arrActyNm[0] as! String))
//                    
//                    let filterArray = (self.arrOfSltActyNm as NSArray).filtered(using: predicates)
//                    if(filterArray.count != 0){
//                        if let index = self.arrOfSltActyNm.index(of: arrActyNm[0] as! String) {
//                            self.arrOfSltActyNm.remove(at: index)
//                            cell.lbl_Des1.text = ""
//                            if(self.arrOfSltActyNm.count != 0){
//                                
//                                for (idx, obj) in self.arrOfSltActyNm.enumerated(){
//                                    if(idx == 0){
//                                        
//                                        cell.lbl_Des1.text =  String(format: "%@", obj)
//                                    }else{
//                                        
//                                        cell.lbl_Des1.text =  String(format: "%@, %@ ", cell.lbl_Des1.text!, obj )
//                                    }
//                                }
//                            }else{
//                                cell.lbl_Des1_W.constant = 0
//                                
//                            }
//                        }
//                    }
//                }
                self.manageFltCountOfFilterLabel()

            }
            
            navigationController?.pushViewController(fltByActivityVC, animated: true)
            }else{ //Filter By Location
                
                let typeOfHelpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TypeOfHelp") as! TypeOfHelpVC
                
                typeOfHelpVC.cameFmFilterVC = true
                typeOfHelpVC.callBackFmTypOfHelpVC = {(isSltActivityNm : Bool , arrActyNm : [Any]) -> Void in
                    if(isSltActivityNm){
                        
                        
                        cell.lbl_Des1.text = ""
                        if(cell.lbl_Des1.text != ""){
                            cell.lbl_Des1.text =  String(format: "%@, %@ ", cell.lbl_Des1.text!,(arrActyNm[0] as? String)! )
                        }else{
                            cell.lbl_Des1.text =  String(format: "%@",(arrActyNm[0] as? String)!  )
                        }
                        self.arrOfSltActyNmOrLotn.removeAll()
                        self.arrOfSltActyNmOrLotn.append((arrActyNm[0] as? String)! )
                        self.manageFltCountOfFilterLabel()

                    }
                }

                self.navigationController?.pushViewController(typeOfHelpVC, animated: true)

            }
        }
   
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2000
    }

   
    
    
    func manageFltCountOfFilterLabel(){
  
        if(self.arrOfSltCatNm.count == 0 && self.arrOfSltActyNmOrLotn.count == 0 && self.addedTags.count == 0 ){
            btnApplyFlt.isUserInteractionEnabled = false
            //btnApplyFlt.alpha = 0.5
            btnApplyFlt.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)

            self.lbl_Filter.text = "Filter"
        }else if (self.arrOfSltCatNm.count != 0 && self.arrOfSltActyNmOrLotn.count == 0 && self.addedTags.count == 0){
            btnApplyFlt.isUserInteractionEnabled = true
          //  btnApplyFlt.alpha = 1.0
            btnApplyFlt.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

            self.lbl_Filter.text = "Filter(1)"
            
        }else if (self.arrOfSltCatNm.count != 0 && self.arrOfSltActyNmOrLotn.count != 0 && self.addedTags.count == 0){
            btnApplyFlt.isUserInteractionEnabled = true
           //  btnApplyFlt.alpha = 1.0
            btnApplyFlt.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

            self.lbl_Filter.text = "Filter(2)"
            
        }else if (self.arrOfSltCatNm.count != 0 && self.arrOfSltActyNmOrLotn.count != 0 && self.addedTags.count != 0){
            btnApplyFlt.isUserInteractionEnabled = true
            //btnApplyFlt.alpha = 1.0
            btnApplyFlt.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

            self.lbl_Filter.text = "Filter(3)"
            
        }else if (self.arrOfSltCatNm.count == 0 && self.arrOfSltActyNmOrLotn.count != 0 && self.addedTags.count == 0){
            btnApplyFlt.isUserInteractionEnabled = true
            //btnApplyFlt.alpha = 1.0
            btnApplyFlt.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

            self.lbl_Filter.text = "Filter(1)"
            
        }else if (self.arrOfSltCatNm.count != 0 && self.arrOfSltActyNmOrLotn.count != 0 && self.addedTags.count == 0){
            btnApplyFlt.isUserInteractionEnabled = true
            //btnApplyFlt.alpha = 1.0
            btnApplyFlt.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

            self.lbl_Filter.text = "Filter(2)"
            
        }else if (self.arrOfSltCatNm.count == 0 && self.arrOfSltActyNmOrLotn.count != 0 && self.addedTags.count != 0){
            btnApplyFlt.isUserInteractionEnabled = true
            //btnApplyFlt.alpha = 1.0
            btnApplyFlt.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

            self.lbl_Filter.text = "Filter(2)"
            
        }else if (self.arrOfSltCatNm.count == 0 && self.arrOfSltActyNmOrLotn.count == 0 && self.addedTags.count != 0){
            btnApplyFlt.isUserInteractionEnabled = true
            //btnApplyFlt.alpha = 1.0
            btnApplyFlt.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

            self.lbl_Filter.text = "Filter(1)"
            
        }else if (self.arrOfSltCatNm.count != 0 && self.arrOfSltActyNmOrLotn.count == 0 && self.addedTags.count != 0){
            btnApplyFlt.isUserInteractionEnabled = true
            //btnApplyFlt.alpha = 1.0
            btnApplyFlt.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

            self.lbl_Filter.text = "Filter(2)"
            
        }else if (self.arrOfSltCatNm.count == 0 && self.arrOfSltActyNmOrLotn.count != 0 && self.addedTags.count != 0){
            btnApplyFlt.isUserInteractionEnabled = true
            //btnApplyFlt.alpha = 1.0
            btnApplyFlt.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

            self.lbl_Filter.text = "Filter(2)"
            
        }
  
    }
}
