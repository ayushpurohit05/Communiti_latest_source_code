//
//  WhatsKMVC.swift
//  Community
//
//  Created by Hatshit on 05/03/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class WhatsKMVC: UIViewController {
    
    @IBOutlet var lbl_SuccessCloseHR_H: NSLayoutConstraint!
    

    @IBOutlet var lbl_SuccsCloseHRPoints_H: NSLayoutConstraint!
    
    @IBOutlet var lbl_closeHRWithAplicant_H: NSLayoutConstraint!
    
    @IBOutlet var lbl_CloseHrWithAplicantPoints_H: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_SuccessCloseHR_H.constant = 0
        lbl_SuccsCloseHRPoints_H.constant = 0
        lbl_closeHRWithAplicant_H.constant = 0
        lbl_CloseHrWithAplicantPoints_H.constant = 0

        // Do any additional setup after loading the view.
    }



}
