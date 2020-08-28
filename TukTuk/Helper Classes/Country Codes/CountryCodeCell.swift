//
//  CountryCodeViewController.swift
//  TukTuk
//
//  Created by Harjot Bharti on 18/02/20.
//  Copyright © 2020 TukTuk Inc. All rights reserved.
//

import UIKit

class CountryCodeCell: UITableViewCell {

    @IBOutlet var countryCodeLbl: UILabel!
    @IBOutlet var countryNameLbl: UILabel!
    @IBOutlet var countryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        countryImage.layer.cornerRadius = 4
        countryImage.layer.masksToBounds = false
        countryImage.layer.shadowOffset = CGSize(width: CGFloat(1.5), height: CGFloat(1.5))
        countryImage.layer.shadowRadius = 5
        countryImage.layer.shadowOpacity = 0.3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
    }

}
