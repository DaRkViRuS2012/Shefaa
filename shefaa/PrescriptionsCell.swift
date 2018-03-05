//
//  PrescriptionsCell.swift
//  shefaa
//
//  Created by Nour  on 4/15/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class PrescriptionsCell: UITableViewCell {

    @IBOutlet weak var PrescriptionLbl: UILabel!
    @IBOutlet weak var doctorLbl: UILabel!
    @IBOutlet weak var medicineLbl: UILabel!
    
    
    
    var prescription:Prescription?{
    
        didSet{
        
            guard let prescription = prescription else {
                return
            }
            
            PrescriptionLbl.text = prescription.title!
            doctorLbl.text = prescription.prec_date
            medicineLbl.text =  prescription.author_Name!
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
