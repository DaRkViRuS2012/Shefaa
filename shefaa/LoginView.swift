//
//  LoginView.swift
//  FastFood
//
//  Created by Nour  on 1/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material

class LoginView: UIView {
    
    
    var ratio = 1.0
    var count = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        ratio = Double(UIScreen.main.bounds.width / CGFloat(750))
        setupViews()
    }
    
    func injected() {
        setupViews()
        print("I've been injected: \(self)")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let logo:UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
        
    }()
    
    
    let backgroundImage:UIImageView={
    
        let iv = UIImageView(image: UIImage(named: "BG-6"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let emailTextField:TextField = {
        let tf = TextField()
        tf.placeholder =  NSLocalizedString("Username", comment: "")
        tf.placeholderActiveColor = .black
        tf.textColor = .white
        tf.detailColor = Color.white
        tf.placeholderNormalColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        tf.rightViewMode = .always
        let imageview = UIImageView(image: UIImage(named: "email")?.resize(toWidth: 15)?.resize(toHeight: 15))
        imageview.tintColor = .white
        tf.rightView = imageview
        return tf
    }()
    
    
    let passTextField:TextField = {
        let tf = TextField()
        tf.placeholder = NSLocalizedString("Password", comment: "")
        tf.detailColor = Color.white
        tf.placeholderActiveColor = .black
        tf.placeholderNormalColor = .white
        tf.isSecureTextEntry = true
        tf.keyboardType = .default
        tf.textColor = .white
        tf.returnKeyType = .done
        tf.rightViewMode = .always
        let imageview = UIImageView(image: UIImage(named: "key")?.resize(toWidth: 15)?.resize(toHeight: 15))
        imageview.tintColor = .white
        tf.rightView = imageview
        //tf.isVisibilityIconButtonAutoHandled = true
        tf.isVisibilityIconButtonEnabled = true
        return tf
    }()
    
    
    let forgetBtn:UIButton = {
        
        
        let btn = UIButton()
        btn.setTitle(NSLocalizedString("Forget Password?", comment: ""), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor().mainColor(), for: .normal)
        return btn
        
    }()
    
//    let loginBtn:FlatButton = {
//        let btn = FlatButton()
//        btn.setTitle("Sign in", for: .normal)
//        btn.setTitleColor(UIColor().mainColor(), for: .normal)
//      //  btn.setTitleColor(.white, for: .normal)
//        
//        btn.backgroundColor =  .white
//        btn.layer.masksToBounds = true
//        btn.layer.cornerRadius = 10
//        return btn
//    }()
//    
    
    
    let signinBtn:FlatButton = {
    let btn = FlatButton()
    btn.setTitle(NSLocalizedString("Sign in", comment: ""), for: .normal)
    btn.setTitleColor(UIColor().mainColor(), for: .normal)
    btn.backgroundColor = .white
    btn.layer.masksToBounds = true
    btn.layer.cornerRadius = 10
        
    return btn
    }()
    
    
    let label :UILabel = {
        
        let lb = UILabel()
        lb.tag = -1
        lb.text = NSLocalizedString("DON’T HAVE AN ACCOUNT?", comment: "")
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 12)
        
        return lb
        
    }()
    
    let signupBtn:UIButton = {
        
        let btn = UIButton()
        btn.setTitle(NSLocalizedString("SIGN UP", comment: ""), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.backgroundColor = .clear
        return btn
        
    }()
    
    
    func setupViews(){
        
        
      
        
        addSubview(backgroundImage)
        addSubview(logo)
        addSubview(emailTextField)
        addSubview(passTextField)
        //addSubview(loginBtn)
        addSubview(signupBtn)
  
        
        
        
        addSubview(signinBtn)
        
        
        _ = backgroundImage.anchor8(self, topattribute: .top, topConstant: 0, leftview: self, leftattribute: .leading, leftConstant: 0, bottomview: self, bottomattribute: .bottom, bottomConstant: 0, rightview: self, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    
            
            _ = logo.anchor8(nil, topattribute: nil, topConstant: 0, leftview: nil, leftattribute: nil, leftConstant: 0, bottomview: emailTextField , bottomattribute: .top, bottomConstant: -100, rightview: nil, rightattribute: nil, rightConstant: 0, widthConstant: CGFloat(170.0 * ratio), heightConstant: CGFloat(170.0 * ratio))
            
   
            logo.CenterX(self, Constant: 0)
   
        
        if #available(iOS 9.0, *) {
            _ = emailTextField.anchor( nil, left: leadingAnchor, bottom: passTextField.topAnchor, right: trailingAnchor, topConstant: 0, leftConstant: CGFloat(60 * ratio), bottomConstant: 40, rightConstant: CGFloat(60 * ratio), widthConstant: 0, heightConstant: CGFloat(50))
        } else {
            _ = emailTextField.anchor8(nil, topattribute: nil, topConstant: 0, leftview: self, leftattribute: .leading,
                                       leftConstant: CGFloat(60 * ratio), bottomview: nil, bottomattribute: nil, bottomConstant: -40, rightview: self, rightattribute: .trailing, rightConstant: -CGFloat(60 * ratio), widthConstant: 0, heightConstant: CGFloat(50))
        }
        emailTextField.CenterY(self, Constant: 0)
        
        
        
        
        
        
        if #available(iOS 9.0, *) {
            _ = passTextField.anchor(nil, left: leadingAnchor, bottom: nil, right: trailingAnchor , topConstant: 0, leftConstant: CGFloat(60 * ratio), bottomConstant: 0, rightConstant: CGFloat(60 * ratio), widthConstant: 0, heightConstant: CGFloat(50))
        } else {
            _ = passTextField.anchor8(emailTextField , topattribute: .bottom, topConstant: 32, leftview: self, leftattribute: .leading, leftConstant: CGFloat(60 * ratio), bottomview: nil, bottomattribute: nil,
                                      bottomConstant: 0, rightview: self, rightattribute: .trailing, rightConstant: -CGFloat(60 * ratio), widthConstant: 0, heightConstant: CGFloat(50))
            
        }
        
    
    
            _ = signinBtn.anchor8(passTextField, topattribute: .bottom, topConstant: 60, leftview: self, leftattribute: .leading, leftConstant: CGFloat(60 * ratio), bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: self, rightattribute: .trailing, rightConstant: -CGFloat(60 * ratio), widthConstant: 0, heightConstant: 50)
    
        
        
        
        
        if !UIApplication.isRTL(){
            addSubview(label)
            _ = label.anchor(signinBtn.bottomAnchor, left: leadingAnchor, bottom: nil, right: nil , topConstant: 40, leftConstant: CGFloat(170 * ratio), bottomConstant: 0, rightConstant: CGFloat(245 * ratio), widthConstant: 0, heightConstant: CGFloat(20 * ratio))
            
            _ = signupBtn.anchor(signinBtn.bottomAnchor, left: label.trailingAnchor, bottom: nil, right: nil, topConstant: CGFloat(40), leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: CGFloat(20 * ratio))
            
        }else{
            signupBtn.setTitle("انشاء حساب جديد", for: .normal)
            signupBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
              _ = signupBtn.anchor(signinBtn.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: CGFloat(20), leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: CGFloat(20 * ratio))
            signupBtn.CenterX(self, Constant: 0)
        }
        
        
        
        
        //
        //
        //
        
                
    }
    
    
    
    
}
