//
//  AppointementCell.swift
//  shefaa
//
//  Created by Nour  on 7/21/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class AppointementCell: UITableViewCell {

    
    
    var appointment:Appointment? {
        
        didSet{
        
            guard let appointment = appointment else {
            return
            }
        
            dateLbl.text = appointment.appointmentDate
            timeLbl.text = appointment.appointmentstarttime
            patientNameLbl.text = appointment.patientName!
            tilteLbl.text = appointment.title
        
        }
    }
    
    
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var patientNameLbl: UILabel!
    @IBOutlet weak var tilteLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
