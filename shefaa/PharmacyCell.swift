//
//  PharmacyCell.swift
//  shefaa
//
//  Created by Nour  on 3/24/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Cosmos
class PharmacyCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var specializationLbl: UILabel!
    @IBOutlet weak var CityLbl: UILabel!
    
    @IBOutlet weak var medName: UILabel!
    @IBOutlet weak var PharmacyName: UILabel!
    @IBOutlet weak var Adress: UILabel!
    
    @IBOutlet weak var rateView: CosmosView!
    
    var doctor:Pharmacy?{
        
        didSet{
            
            guard let doctor = doctor else{
                return
            }
            
            
            nameLbl.text = doctor.pharmacy_name!
            specializationLbl.text = doctor.medicine_name!
            CityLbl.text = "\(doctor.country!) ,\(doctor.city!) ,\(doctor.street!)"
            if let _ = doctor.rate?.average {
            
                let rate = Double((doctor.rate?.average)!)! / 10
                rateView.rating = rate
            }
            
            if let cnt = doctor.rate?.count{
            rateView.text = cnt
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        medName.text = NSLocalizedString("Medicine:", comment: "")
//        PharmacyName.text = NSLocalizedString("Pharmacy:", comment: "")
        Adress.text = NSLocalizedString("Address:", comment: "")
        rateView.settings.updateOnTouch = false
        rateView.settings.fillMode = .half
    }
    
}
