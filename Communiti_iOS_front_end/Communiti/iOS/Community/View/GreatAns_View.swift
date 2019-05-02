//
//  GreatAns_View.swift
//  Community
//
//  Created by Hatshit on 28/11/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper

class GreatAns_View: UIView {

    @IBOutlet weak var lbl_ChangeColor: UILabel!
    @IBOutlet weak var alert_View: UIView!
    @IBOutlet weak var bg_View: UIView!
    var HowKMPointsWorksCallBack: ((Bool) -> Void)?

    
    class func instanceFromNib() -> UIView {
      return UINib(nibName: "GreatAns_View", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @IBAction func btnActionMethod(_ sender: Any) {
        DispatchQueue.main.async {

          self.killViewWithAnimation(view: self)
        }
    }
    
    @IBAction func WhatsAreKmPointsAction(_ sender: Any) {
        if self.HowKMPointsWorksCallBack != nil {
           self.HowKMPointsWorksCallBack!(true)
        }
    }
    func setUpOfLbl(){
        
        let strNumber: NSString = lbl_ChangeColor.text! as NSString // you must set your
        let range = (strNumber).range(of: "15 Karma Points")
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
         let color = UIColor.init(red: 183/255, green: 117/255, blue: 1/255, alpha: 1.0)
        attribute.addAttribute(NSForegroundColorAttributeName, value: color , range: range)
        lbl_ChangeColor.attributedText = attribute


    }
    
    
    func killViewWithAnimation(view : UIView){
        UIView.animate(withDuration: 0.1,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.bg_View.alpha = 0;
                        self.alert_View.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: {(isCompleted) in
             self.removeFromSuperview()
        }) 
    }
    
    
//================================
// Call Service For Great Ans
//================================
    func greatAndUnGreatAnsMethod(controller : UIViewController, ans_Id : String , callBack : @escaping ( Bool ) -> Void ){
        
        /*
         1.usrToken->user token
         2.ansId->comment id
         3.kudoId->kudoId
         4.kudoCmnt->kudoCmnt
         */
 
            let dict : Dictionary =  ["usrToken" : getUserData()["usr_token"],
                                          "ansId" : ans_Id ,
                                          "kudoId" : "",
                                          "kudoCmnt" : ""]
            
            ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.greatAndUnGreatAns, callBack: { (response:Any ,isError:Bool) in
                
               
                
                if(!isError){
                    let dictResponse = response as! NSDictionary
                    if(dictResponse["success"] as! Bool){
                        let resultData = dictResponse["data"] as Any
                        //print("RESPONSE ==",resultData)
                        
                        DispatchQueue.main.async {
                        if(dictResponse["message"] as! String == "Like successfully."){
                            callBack(true)
                        }else{
                            callBack(false)

                        }
                
                     }
                        
                    }else{
                        
                        ShowError(message: dictResponse["message"]  as! String, controller: controller)
                        
                    }
                    
                }else{
                    
                    ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: controller, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                    })
                    
                }
            })
      
        
        
    }
    
}
