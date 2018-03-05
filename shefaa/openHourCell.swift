//
//  openHourCell.swift
//  shefaa
//
//  Created by Nour  on 4/16/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class openHourCell: UITableViewCell {

    
    
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    let days:[String:String] = ["0":"Sunday","1":"Monday","2":"Tuesday","3":"Wednsday","4":"Thersday","5":"Friday","6":"Saturday"]
    
    
    var date:Clinic_open_hours?{
    
        didSet{
        
            guard let date = date else{
                return
            }
            if let day = date.day {
                dayLbl.text = NSLocalizedString(days[day]!, comment: "")
            }else{
            dayLbl.text = ""
            }
            var start = ""
            var end = ""
            if ((date.starthours?.characters.count)! == 3){
                
                start = "0\(date.starthours![0]):\(date.starthours![1])\(date.starthours![2])"
            }else if (date.starthours?.characters.count)! == 4 {
               start = "\(date.starthours![0])\(date.starthours![1]):\(date.starthours![2])\(date.starthours![3])"
            }
            
            
            if ((date.endhours?.characters.count)! == 3){
                
                end = "0\(date.endhours![0]):\(date.endhours![1])\(date.endhours![2])"
            }else if (date.endhours?.characters.count)! == 4{
                end = "\(date.endhours![0])\(date.endhours![1]):\(date.endhours![2])\(date.endhours![3])"
            }
            
            let time = start + "-" + end
            
            timeLbl.text = time
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
