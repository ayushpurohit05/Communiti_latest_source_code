//
//  SideMenuVC.swift
//  Community
//
//  Created by Hatshit on 01/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //==============================
    // this code only fpr side view
    //==============================
    
     func OpneSideView() {
        let sliderView = SliderView.instanceFromNib() as! SliderView;
        sliderView.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        sliderView.setUpOfTableview()
        
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        
                        sliderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        
                        
                        
        }, completion: { (finished) -> Void in
            // ....
        })
        self.view.addSubview(sliderView)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
