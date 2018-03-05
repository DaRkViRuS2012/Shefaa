//
//  LoadingView.swift
//  Example
//
//  Created by Alexander Schuch on 29/08/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit
//import StatefulViewController
import Material

class LoadingViewCustom: BasicPlaceholderView, StatefulPlaceholderView {
    let label:UILabel = {
        let l = UILabel()
        l.text =  NSLocalizedString("Loading...", comment: "")
        l.font = Font.systemFont(ofSize: 18)
        l.textColor = Color.blue.lighten1
        return l
    }()
    
    let container:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor.white
        centerView.addSubview(container)
        container.addSubview(label)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Color.blue.lighten1
        container.addSubview(activityIndicator)
        
        _ = container.anchor8(nil, topattribute: .top, topConstant: 0, leftview: nil, leftattribute: nil, leftConstant: 0, bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: nil, rightattribute: nil, rightConstant: 0, widthConstant: 300, heightConstant: 300)
        container.Center(centerView)
        
        
        
        
        //
        //		let views = ["label": label, "activity": activityIndicator]
        //		let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[activity]-[label]-|", options: [], metrics: nil, views: views)
        //		let vConstraintsLabel = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views)
        //		let vConstraintsActivity = NSLayoutConstraint.constraints(withVisualFormat: "V:|[activity]|", options: [], metrics: nil, views: views)
        //
        //		centerView.addConstraints(hConstraints)
        //		centerView.addConstraints(vConstraintsLabel)
        //		centerView.addConstraints(vConstraintsActivity)
    }
    
    
    func placeholderViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    }
    
}
