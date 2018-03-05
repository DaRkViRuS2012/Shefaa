//
//  MessageCell.swift
//  shefaa
//
//  Created by Nour  on 8/10/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var alarmImage: UIImageView!
    
    
    var message:Message?{
    
        didSet{
            
            guard let message = message else{
            
                return
            }
            if let name = message.author?.name {
                nameLbl.text = name
            }
            if let subject = message.subject{
                messageLbl.text = subject
            }
            
            if message.is_new == "0"{
                alarmImage.isHidden = true
            }else{
                alarmImage.isHidden = false
            }
            
            if let time = message.timestamp{
                dateLbl.text = time
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
