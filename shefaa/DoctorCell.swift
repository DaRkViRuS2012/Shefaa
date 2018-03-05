//
//  DoctorCell.swift
//  shefaa
//
//  Created by Nour  on 3/24/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Cosmos

class DoctorCell: UITableViewCell {

    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var specialization: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var specializationLbl: UILabel!
    @IBOutlet weak var CityLbl: UILabel!
    @IBOutlet weak var CostLbl: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    
    var doctor:Doctor?{
    
        didSet{
        
            guard let doctor = doctor else{
            return
            }
            
            nameLbl.text = doctor.name!
            if let _ = doctor.country , let _ = doctor.city {
            CityLbl.text = "\(doctor.country!) ,\(doctor.city!)"
            
            }
            if let _ = doctor.cost{
                CostLbl.text = doctor.cost!
            }
            var st:String = ""
            for sp in doctor.doctor_specialization! {
                st += "\(sp) "
            }
            specializationLbl.text = st
            if let _ = doctor.rate?.average{
                let rate = Double((doctor.rate?.average)!)! / 20
            rateView.rating = rate
            rateView.text = "\(rate)"
            }
            if let _ = doctor.rate?.count {
            rateView.text = doctor.rate?.count
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        price.text = NSLocalizedString("Price", comment: "") + ":"
     //   name.text = NSLocalizedString("Name:", comment: "")
        adress.text = NSLocalizedString("Address:", comment: "")
        specialization.text = NSLocalizedString("Specialization", comment: "") + ":"
        rateView.settings.fillMode = .half
        rateView.settings.updateOnTouch = false
    }

}
