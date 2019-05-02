//
//  LocationCell.swift
//  Community
//
//  Created by Hatshit on 23/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var lbl_Country: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
