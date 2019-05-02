//
//  StartChatView.swift
//  Community
//
//  Created by Hatshit on 17/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class StartChatView: UIView {
    
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var lbl_Nm: UILabel!
    @IBOutlet weak var imgViewOfOthr: UIImageView!
    @IBOutlet weak var imgViewOfSelf: UIImageView!
    @IBOutlet weak var bg_View: UIView!
    @IBOutlet weak var alert_View: UIView!
    
    var callBackFromStartChatView: ((Bool) -> Void)?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first!
        if (touch.view == bg_View){
            DispatchQueue.main.async {
                self.killViewWithAnimation(view: self)
            }
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "StartChatView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
    }
    
    
    func setUpViewMethod(othrUserImg : String , userName : String){
        if(othrUserImg != ""){
            saveImgIntoCach(strImg: othrUserImg, imageView: self.imgViewOfOthr)
        }else{
           self.imgViewOfOthr.image =  UIImage(named: "user")
        }
        
        
        if(getUserData()["profile_image"] as? String != ""){
            saveImgIntoCach(strImg: getUserData()["profile_image"]! as! String, imageView: self.imgViewOfSelf)
        }else{
            self.imgViewOfSelf.image =  UIImage(named: "user")
        }
        
        self.lbl_Nm.text =  String(format: "You want to help %@", userName)
        self.lbl_Desc.text = String(format: " Chat with %@ to learn more about their request, and start helping them!", userName)
      }
    
    
    
    @IBAction func btnActionMethod(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.killViewWithAnimation(view: self)
            
            if self.callBackFromStartChatView != nil {
                self.callBackFromStartChatView!(true)
            }
            
        }
    }
    
    func killViewWithAnimation(view : UIView){
        UIView.animate(withDuration: 0.1,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.bg_View.alpha = 0;
                        self.alert_View.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                        
        }, completion: { (finished : Bool) -> Void in
            if(finished){
                view.removeFromSuperview()
            }
        })
    }
    

}
