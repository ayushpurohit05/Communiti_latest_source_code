//
//  HeaderView.swift
//  Subway
//
//  Created by Hemant Pandagre on 02/10/17.
//  Copyright © 2017 Hemant Pandagre. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    var titleString = String()
    var View = UIViewController()
    typealias CompletionBlock = (Bool) -> Void
    var closure: CompletionBlock?
    
    
    init(title : String, controller: UIViewController) {
        super.init(frame: CGRect(x:0, y:0, width:Constants.mainScreenWidth , height:60))
        self.View = controller
        self.titleString = title
        self.addCustomView()
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func addCustomView() {

        //Add ImageView
        let imgVw: UIImageView = UIImageView()
        imgVw.frame = CGRect(x:0, y:0, width:Constants.mainScreenWidth , height:60)
        imgVw.image = UIImage(named:"gradient")
        
        //Title label
        let titleLabel: UILabel = UILabel()
        titleLabel.frame = CGRect(x:0, y:6, width:Constants.mainScreenWidth , height:60)
        titleLabel.text = titleString
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.white
        titleLabel.font = Font.OpenSansLight(fontSize: 20.0)
        
        
        //Add Back Button
        let backButton: UIButton = UIButton()
        backButton.frame = CGRect(x:0, y:5, width:60 , height:60)
        backButton.setImage(UIImage(named: "back_white"), for: UIControlState.normal)
        backButton.addTarget(self, action: NSSelectorFromString("backButtonPressed"), for: .touchUpInside)
        
        
        self.addSubview(imgVw)
        self.addSubview(backButton)
        self.addSubview(titleLabel)
    }
    
    func backButtonPressed() -> Void {
        if (closure != nil){
            closure!(true)
        }
        View.navigationController?.popViewController(animated: true)
    }
}
