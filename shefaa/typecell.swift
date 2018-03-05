
//
//  typecell.swift
//  shefaa
//
//  Created by Nour  on 7/26/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class typecell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
