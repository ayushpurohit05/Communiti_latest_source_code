//
//  EndReqAlert.swift
//  Community
//
//  Created by Hatshit on 12/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class EndReqAlert: UIView {

    @IBOutlet weak var bg_View: UIView!
    @IBOutlet weak var alert_View: UIView!
    var HowKMPointsWorksCallBack: ((Bool) -> Void)?


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
        return UINib(nibName: "EndReqAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
    }
    
    @IBAction func btnWhatKrmPointsAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.removeFromSuperview()
            if self.HowKMPointsWorksCallBack != nil {
               self.HowKMPointsWorksCallBack!(true)
            }
        }
    }
    
    @IBAction func btnActionMethod(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.killViewWithAnimation(view: self)
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
