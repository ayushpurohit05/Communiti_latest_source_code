//
//  FltByCatCell.swift
//  Community
//
//  Created by Hatshit on 29/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class FltByCatCell: UITableViewCell {

    @IBOutlet weak var imgViewCheckMark: UIImageView!
    @IBOutlet weak var lbl_CatNm: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
