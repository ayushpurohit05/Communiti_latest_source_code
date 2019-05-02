//
//  Define.swift
//  Swift_Demo
//
//  Created by Hemant Pandagre on 02/09/17.
//  Copyright © 2017 Hemant Pandagre. All rights reserved.
//

import Foundation
import UIKit


let login = "login"

// User Detail
let userLName = "usr_lname"


class Constants {
    
    //Screen size
    static let mainScreenWidth : CGFloat = UIScreen.main.bounds.width
    static let mainScreenHeight : CGFloat = UIScreen.main.bounds.height
    
    // Check Device IPHONE
    static let kIphone_4s : Bool =  (UIScreen.main.bounds.size.height == 480)
    static let kIphone_5 : Bool =  (UIScreen.main.bounds.size.height == 568)
    static let kIphone_6 : Bool =  (UIScreen.main.bounds.size.height == 667)
    static let kIphone_6_Plus : Bool =  (UIScreen.main.bounds.size.height == 736)
    

    //Objects of Storyboard
    static let storyBoard  : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    static let storyBoard2 : UIStoryboard = UIStoryboard(name: "Main2", bundle:nil)
    static let storyBoard3 : UIStoryboard = UIStoryboard(name: "Main3", bundle:nil)
    static let storyBoard4 : UIStoryboard = UIStoryboard(name: "Main4", bundle:nil)
    static let storyBoard5 : UIStoryboard = UIStoryboard(name: "Main5", bundle:nil)

}
