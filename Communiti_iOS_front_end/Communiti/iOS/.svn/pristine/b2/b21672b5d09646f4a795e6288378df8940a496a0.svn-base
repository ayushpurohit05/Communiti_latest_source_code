//
//  AddRequestVC.swift
//  Community
//
//  Created by Hatshit on 30/11/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper


class AddRequestVC: UIViewController {
    
    //MARK: ** Properties **
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgViewOfHive: UIImageView!
    @IBOutlet weak var lbl_NameOfHive: UILabel!
    @IBOutlet weak var lbl_DesOfHive: UILabel!
    @IBOutlet weak var imgViewOfHelp: UIImageView!
    @IBOutlet weak var lbl_NameOfHelp: UILabel!
    @IBOutlet weak var lbl_DescOfHelp: UILabel!
    
 
    var idOfHiveCat : String!
    var idOfHelpCat : String!
    var arrOFShowData = [CountryList]()
    var callBack: ((Bool) -> Void)?
    
    //================= Future Use HR Section  ===========
    @IBOutlet var containerVw_H: NSLayoutConstraint!
    @IBOutlet var bgView_H: NSLayoutConstraint!
    @IBOutlet var HelpReqVW_H: NSLayoutConstraint!
    //====================================================


    //MARK: ** View Life Cycle **
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
           //print(touch.view ?? "")
            
             self.view.removeFromSuperview()
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.removeHrSection()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
//================= Future Use HR Section  =============================
    func removeHrSection(){
        
        self.HelpReqVW_H.constant = 0
        self.bgView_H.constant = 140
        self.containerVw_H.constant = 140
    }
//===============================================
    
    private func setUpView(){
        
        self.bgView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.bgView.frame = CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height)
                        // self.view.backgroundColor = UIColor.black
                        // self.view.alpha = 0.5
                        self.bgView.alpha = 1
        }, completion: { (finished) -> Void in
            // ....
        })
    }
    
    //MARK: ** Button Actions **
    @IBAction func btnActionMethod(_ sender: UIButton) {
//================= Future Use HR Section  =============================

//
//        if( sender.tag == 0){
//
//            APP_Delegate().reqType = true
//            APP_Delegate().isEditHiveFld = false
//        }else{
//            //APP_Delegate.delegate.reqType = false
//            APP_Delegate().reqType = false
//            APP_Delegate().isEditHelpFld = false
//        }
//        callBack!(true)
        //=============================================
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.view.removeFromSuperview()
    }

}//END
