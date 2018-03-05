//
//  UIButton.swift
//  shefaa
//
//  Created by Nour  on 3/24/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit


extension UIButton{

    
    func centerVerticallyWithPadding(padding:CGFloat){
    
        let imageSize = self.imageView?.frame.size
        let titleSize = self.titleLabel?.frame.size
        
        let totalHeight:CGFloat = ((imageSize?.height)! + (titleSize?.height)! + padding)
        
        self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - (imageSize?.height)!), left: 0, bottom: -(titleSize?.width)!, right: 0)
        
        self.titleEdgeInsets = UIEdgeInsets(top: -(imageSize?.width)!, left: 0 , bottom: -(totalHeight - (titleSize?.height)!), right: 0)
        
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: (titleSize?.height)!, right: 0)
        
    }
    
    func centerVertically()
    {
    let kDefaultPadding:CGFloat = 6.0;
    
    self.centerVerticallyWithPadding(padding: kDefaultPadding)
    }
    
    
    

}





