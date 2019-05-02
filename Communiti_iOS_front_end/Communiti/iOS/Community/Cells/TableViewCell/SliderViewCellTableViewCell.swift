//
//  SliderViewCellTableViewCell.swift
//  Community
//
//  Created by Hatshit on 01/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit

class SliderViewCellTableViewCell: UITableViewCell {
    @IBOutlet var lbl_SupportCount: UILabel!
    @IBOutlet weak var lbl_ContantName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
