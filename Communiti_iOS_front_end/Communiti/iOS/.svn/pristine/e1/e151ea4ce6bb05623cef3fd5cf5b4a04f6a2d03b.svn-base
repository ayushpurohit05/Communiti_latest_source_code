//
//  BlockView.swift
//  Communiti
//
//  Created by Hemant Pandagre on 31/03/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class BlockView: UIView , UITextViewDelegate {

    
    @IBOutlet weak var bg_View: UIView!
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var alert_View: UIView!
    
    class func instanceFromNib() -> UIView {
      
     
        return UINib(nibName: "BlockView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func setText(title : String?) -> Void {
        //txtView.text = title
        txtView.translatesAutoresizingMaskIntoConstraints = true
        txtView.sizeToFit()
        txtView.isScrollEnabled = false
    }
    

    @IBAction func pressedBlockBtn(_ sender: Any) {
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
        }, completion: {(isCompleted) in
            self.removeFromSuperview()
        })
    }


}
