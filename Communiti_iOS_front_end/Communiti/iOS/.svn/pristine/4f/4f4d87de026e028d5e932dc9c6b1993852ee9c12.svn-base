//
//  EnterUserNameVC.swift
//  Communiti
//
//  Created by mac on 18/07/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class EnterUserNameVC: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var firstAnimatedView: UIView!
    @IBOutlet weak var secoundAnimatedView: UIView!
    @IBOutlet weak var btnContinue: UIButton!

    @IBOutlet weak var txtFldNm: UITextField!

    @IBOutlet var alert_H: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.setUpMethod()
        // Do any additional setup after loading the view.
    }
    func setUpMethod(){
        self.alert_H.constant = 0
        self.btnContinue.isEnabled = false
        btnContinue.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
   
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired
                self.firstAnimatedView.isHidden = false

            }
        
 

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // change 2 to desired
            self.secoundAnimatedView.isHidden = false
            
        }
        
    }
    
   
    @IBAction func btnContinueAction(_ sender: Any) {
        
        editEmailAndNameAndUserImgService(secNm: self.txtFldNm.text)
      
    }
    
    //===========================
    //MARK:- TXTField Delate
    //===========================
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let trimmStr  = result.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(trimmStr.count >= 5 ){
            self.btnContinue.isEnabled = true
            self.btnContinue.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

        }else{
            self.btnContinue.isEnabled = false
            btnContinue.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         self.txtFldNm.resignFirstResponder()
         return true;

    }
    
    
    
    func editEmailAndNameAndUserImgService( secNm :String?){
        
        showLoader(view: windowController().view)
      
        let trimmedSecNm = secNm?.trimmingCharacters(in: .whitespacesAndNewlines)
        let secname : String?
        if trimmedSecNm != "" {
            let index = trimmedSecNm?.index ((trimmedSecNm?.startIndex)!, offsetBy: 0)
            let firstChar : Character = (trimmedSecNm![index!])
            secname = firstChar == "@" ? trimmedSecNm :  String(format: "@%@",trimmedSecNm!)
        }else{
            secname = ""
        }
        
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "email" :   "",
                                 "userName" : secname ?? "",
                                 "pImg" :  ""]
        
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.editUserProfile, callBack: { [weak self] (response:Any ,isError:Bool) in
            guard let weakSelf = self else { return }
            
            killLoader()
            if(!isError){
                var dictResponse = response as! [String : Any]
    
                if(dictResponse["success"] as! Bool){
                    DispatchQueue.main.async {
                        print(response)
                            weakSelf.txtFldNm.text = secname
                            var dict = getUserData()
                            dict["usr_username"] = secname
                            setUserData(userData: dict)
                            let selectProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SLTPROFILEVC") as! SelectProfileVC
                        weakSelf.navigationController?.pushViewController(selectProfileVC, animated: true)
                    }
                }else{
                    
                    if(dictResponse["message"] as! String == "User name already exist."){
                        
                        UIView.animate(withDuration: 2.0, delay: 1.0 , animations: {
                            weakSelf.alert_H.constant = 35
                            
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired
                            weakSelf.alert_H.constant = 0
                            
                        }
                    }
                 
                    
                  }
              
            }else{
            
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }


}
