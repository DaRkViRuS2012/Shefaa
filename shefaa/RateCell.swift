//
//  RateCell.swift
//  shefaa
//
//  Created by Nour  on 4/16/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Cosmos
class RateCell: UITableViewCell {

    @IBOutlet weak var rateView: CosmosView!
    
    
    var rate:Rate?{
        didSet{
            
            guard let rate = rate else{
                return
            }
            
            
            if let _ = rate.user {
                rateView.rating = Double(rate.user!)! / 20
            }
            if let _ = rate.count{
                rateView.text = rate.count!
            }
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
