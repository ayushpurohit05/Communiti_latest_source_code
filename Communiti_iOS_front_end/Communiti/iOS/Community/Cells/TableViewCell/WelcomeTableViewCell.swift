//
//  WelcomeTableViewCell.swift
//  Communiti_App
//
//  Created by Navjot  on 11/24/17.
//  Copyright © 2017 Aplite_info. All rights reserved.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var img_View: UIImageView!
    @IBOutlet weak var locartionImage: UIImageView!
    var isSlted: Bool!


    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpCell(countryInfo: CountryList) {
        countryLbl.text =  String(format: "%@, %@", countryInfo.loc_name!, countryInfo.loc_country!)
        tintColor = UIColor.green  // to give chekmark green color
        img_View.isHidden = true


    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
