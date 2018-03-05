//
//  MedicineandPotionCell.swift
//  shefaa
//
//  Created by Nour  on 9/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class MedicineandPotionCell: UITableViewCell {

    @IBOutlet weak var potion: UILabel!
    @IBOutlet weak var name: UILabel!
    var medicine:MedicinePotion?{
        didSet{
            guard let  medicine = medicine else{
                return
            }
        
            potion.text = medicine.potion
            name.text = medicine.medicine
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
