//
//  ZBDropDownMenu.swift
//  zigbang_ios
//
//  Created by YiSeungyoun on 2017. 2. 13..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import UIKit
import YNDropDownMenu
import Cosmos
import Material

class RateView: YNDropDownView {

    @IBOutlet weak var rateView: CosmosView!
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
    }
    @IBAction func confirmButtonClicked(_ sender: Any) {
        self.alwaysSelected(at: 2)
        
        self.hideMenu()
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
//        self.changeMenu(title: "Changed", at: 1)
//        self.changeMenu(title: "Changed", status: .selected, at: 0)
          self.normalSelected(at: 2)
//        self.alwaysSelected(at: 2)
//        self.alwaysSelected(at: 3)
        self.hideMenu()

    }
    
    override func dropDownViewOpened() {
        print("dropDownViewOpened")
          let rate = (rateView.rating * 2 )
        rateView.text = "\(rate)"
        rateView.didFinishTouchingCosmos = {rating in
            let rate = (rating * 2 )
            self.rateView.text = "\(rate)"
        }
    }
    
    override func dropDownViewClosed() {
        print("dropDownViewClosed")
    }

    func initViews() {
       
    }
    
    
    

}

class PriceVIew: YNDropDownView {
    
    @IBOutlet weak var priceTxt: TextField!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        self.hideMenu()
    }
    
    override func dropDownViewOpened() {
        print("dropDownViewOpened")
        
    }
  
    
    
    override func dropDownViewClosed() {
        print("dropDownViewClosed")
    }
    
    
    func initViews() {
    }
}

class SpecsView: YNDropDownView {
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    @IBOutlet weak var specsListBtn: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
    }
    
    @IBAction func onlyJeonseButtonClicked(_ sender: Any) {
    }
    @IBAction func confirmButtonClicked(_ sender: Any) {
        self.hideMenu()
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.hideMenu()
    }
    func initViews() {
        
    }

}

class ZBFilterFeatureView: YNDropDownView {
    @IBOutlet var builtDateSegmentControl: UISegmentedControl!
    @IBOutlet var householdsSegmentControl: UISegmentedControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        self.hideMenu()
        
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.hideMenu()
        
    }
    func initViews() {
    }


}
