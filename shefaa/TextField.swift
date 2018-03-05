//
//  TextField.swift
//  KhalefaLab
//
//  Created by Nour  on 3/8/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

extension UITextField {

    func isEmpty()-> Bool{
    
        return (self.text?.characters.count)! == 0
    }

}


extension String {


    func isEmpty()-> Bool{
    
        return self.characters.count == 0
    }

}
