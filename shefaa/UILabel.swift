//
//  UILabel.swift
//  shefaa
//
//  Created by Nour  on 3/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

extension UILabel {

    override open func layoutSubviews() {
        if self.tag < 0 {
            if UIApplication.isRTL() {
            if self.textAlignment == .right {
            return
            }
        } else {
            if self.textAlignment == .left {
        return
    }}}
    // if not align it based on the Direction , check first if the tag is less than 0 (which means we want this label to be directional not for example centered)
        if self.tag < 0 {
        if UIApplication.isRTL() {
            self.textAlignment = .right
            } else {
                self.textAlignment = .left
            }}
    }

    
    
}



