//
//  RegisterViewController.swift
//  shefaa
//
//  Created by a on 10/12/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
import Alamofire
import SwiftyJSON
import SCLAlertView
class RegisterViewController: UIViewController {

    
    @IBOutlet weak var firstNameTxt: ErrorTextField!
    @IBOutlet weak var lastNameTxt: ErrorTextField!
    @IBOutlet weak var userNameTxt: ErrorTextField!
    
    @IBOutlet weak var emailTxt: ErrorTextField!
    @IBOutlet weak var passwordTxt: ErrorTextField!
    @IBOutlet weak var inviteEmailTxt: ErrorTextField!
    
    @IBOutlet weak var createBtn: RaisedButton!
    
    @IBOutlet weak var gendarSwitch: UISwitch!
    @IBOutlet weak var maleLbl: UILabel!
    @IBOutlet weak var famaleLbl: UILabel!
    
    
    let progressHUD = ProgressHUD(text: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }

    func textDesign(tf:ErrorTextField){
    
        tf.placeholderActiveColor = .black
        tf.textColor = .white
        tf.detailColor = Color.white
        tf.placeholderNormalColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        tf.isErrorRevealed = false
        tf.detailColor = .red
    }
    
    
    func setupViews(){
    
        
        
        textDesign(tf: firstNameTxt)
        textDesign(tf: lastNameTxt)
        textDesign(tf: userNameTxt)
        textDesign(tf: emailTxt)
        textDesign(tf: passwordTxt)
        textDesign(tf: inviteEmailTxt)
        
        
        let ratio = Double(view.frame.width / 750)
        _ = firstNameTxt.anchor8(view, topattribute: .top, topConstant: CGFloat(320 * ratio), leftview: view, leftattribute: .leading, leftConstant: CGFloat(63 * ratio), bottomview: view, bottomattribute: .bottom, bottomConstant: -CGFloat(914 * ratio), rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(373 * ratio), widthConstant: 0, heightConstant: 0)
        
        _ = lastNameTxt.anchor8(view, topattribute: .top, topConstant: CGFloat(320 * ratio), leftview: view, leftattribute: .leading, leftConstant: CGFloat(375 * ratio), bottomview: view, bottomattribute: .bottom, bottomConstant: -CGFloat(914 * ratio), rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(62 * ratio), widthConstant: 0, heightConstant: 0)
        
        
        
        _ = userNameTxt.anchor8(view, topattribute: .top, topConstant: CGFloat(471 * ratio), leftview: view, leftattribute: .leading, leftConstant: CGFloat(63 * ratio), bottomview: view, bottomattribute: .bottom, bottomConstant: -CGFloat(763 * ratio), rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(62 * ratio), widthConstant: 0, heightConstant: 0)
        
        
        _ = emailTxt.anchor8(view, topattribute: .top, topConstant: CGFloat(620 * ratio), leftview: view, leftattribute: .leading, leftConstant: CGFloat(63 * ratio), bottomview: view, bottomattribute: .bottom, bottomConstant: -CGFloat(614 * ratio), rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(62 * ratio), widthConstant: 0, heightConstant: 0)
    
        
        _ = passwordTxt.anchor8(view, topattribute: .top, topConstant: CGFloat(771 * ratio), leftview: view, leftattribute: .leading, leftConstant: CGFloat(63 * ratio), bottomview: view, bottomattribute: .bottom, bottomConstant: -CGFloat(459 * ratio), rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(62 * ratio), widthConstant: 0, heightConstant: 0)
    
        
        _ = inviteEmailTxt.anchor8(view, topattribute: .top, topConstant: CGFloat(924 * ratio), leftview: view, leftattribute: .leading, leftConstant: CGFloat(63 * ratio), bottomview: view, bottomattribute: .bottom, bottomConstant: -CGFloat(310 * ratio), rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(62 * ratio), widthConstant: 0, heightConstant: 0)
        
        
        _ = createBtn.anchor8(view, topattribute: .top, topConstant: CGFloat(1172 * ratio), leftview: view, leftattribute: .leading, leftConstant: CGFloat(63 * ratio), bottomview: view, bottomattribute: .bottom, bottomConstant: -CGFloat(63 * ratio), rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(62 * ratio), widthConstant: 0, heightConstant: 0)
        
        _ = maleLbl.anchor8(view, topattribute: .top, topConstant: CGFloat(1100 * ratio), leftview: view, leftattribute: .leading, leftConstant: CGFloat(63 * ratio), bottomview: view, bottomattribute: .bottom, bottomConstant: -CGFloat(193 * ratio), rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(560 * ratio), widthConstant: 0, heightConstant: 0)

        _ = gendarSwitch.anchor8(view, topattribute: .top, topConstant: CGFloat(1090 * ratio), leftview: maleLbl, leftattribute: .trailing, leftConstant: CGFloat(32 * ratio), bottomview: nil, bottomattribute: .bottom, bottomConstant: -CGFloat(193 * ratio), rightview: nil, rightattribute: .trailing, rightConstant: -CGFloat(62 * ratio), widthConstant: 0, heightConstant: 0)
        
        
        _ = famaleLbl.anchor8(view, topattribute: .top, topConstant: CGFloat(1100 * ratio), leftview: gendarSwitch, leftattribute: .trailing, leftConstant: CGFloat(32 * ratio), bottomview: view, bottomattribute: .bottom, bottomConstant: -CGFloat(193 * ratio), rightview: nil, rightattribute: .trailing, rightConstant: -CGFloat(62 * ratio), widthConstant: 0, heightConstant: 0)

        
        self.view.addSubview(progressHUD)
        
        _ = progressHUD.anchor(view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        progressHUD.hide()
        

    }
    
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func revealeError(textfield:ErrorTextField,state:Bool){
        
        textfield.isErrorRevealed = state
    }
    
   
    func validate() ->Bool{
    
        var state = true
        
        if firstNameTxt.text?.characters.count == 0 {
            revealeError(textfield: firstNameTxt, state: true)
            state = false
        }else{
            revealeError(textfield: firstNameTxt, state: false)
        }
        
        if lastNameTxt.text?.characters.count == 0{
            revealeError(textfield: lastNameTxt, state: true)
            state = false
        }else{
            revealeError(textfield: lastNameTxt, state: false)
        }
        
        if userNameTxt.text?.characters.count == 0{
            revealeError(textfield: userNameTxt, state: true)
            state = false
        }else{
            revealeError(textfield: userNameTxt, state: false)
        }
    
        if !isValidEmail(testStr: emailTxt.text!){
            revealeError(textfield: emailTxt, state: true)
            state = false
        }else{
            revealeError(textfield: emailTxt, state: false)
        }
        
        
        if passwordTxt.text?.characters.count == 0{
            revealeError(textfield: passwordTxt, state: true)
            state = false
        }else{
            revealeError(textfield: passwordTxt, state: false)
        }
//        
//    
//        if inviteEmailTxt.text?.characters.count > 0 {
//            
//        
//        }
    return state
    }
    
    func startloding(){
        progressHUD.isHidden = false
    }
    func stoploading(){
        progressHUD.isHidden = true
    }
    
    
    
    @IBAction func handleRegister(_ sender: UIButton) {
        
        hideKeyboard()
        
        if  !validate(){
            return
        }
        
        progressHUD.show()
        
        let firstname = firstNameTxt.text!
        let lastname = lastNameTxt.text!
        let username = userNameTxt.text!
        let pass = passwordTxt.text!
        let email = emailTxt.text!
        let inviteemail = inviteEmailTxt.text!
        var gendar = "0"
        if gendarSwitch.isOn {
            gendar = "1"
        }
        
        
//            {
//                "name":"services_user_1",
//                "pass":"password",
//                "mail":"services_user_1@example.com",
//                "profile_main":{
//                    "field_first_name":{"und":{"0":{"value":"test first"}}},
//                    "field_last_name":{"und":{"0":{"value":"test last"}}},
//                    "field_gender":{"und":"1"}, (ملاحظة: 0 = male و 1 = female)
//                    "field_invitee_email":{"und":{"0":{"email":"test@gmail.com"}}}
//                }
//        }
//        
        
        
        let url = Globals.baseUrl + "/add-new-user?name=\(username)&p=\(pass)&mail=\(email)&first_name=\(firstname)&last_name=\(lastname)&gender=\(gendar)&invitee=\(inviteemail)"
     

        
        
        
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.timeoutInterval = 50
        
        
        Alamofire.request(request)
            .responseJSON { response in
                
                if let data = response.result.value {
                    self.stoploading()
                    let json = JSON(data)
                    let st = json.rawString()
                    if( st == "[\n  \"Wrong username or password.\"\n]"){
                        self.showAlert(title: "", msg: NSLocalizedString("Wrong username or password", comment: ""),style:.error)
                        return
                    }
                self.dismiss(animated: true, completion: nil)
                }else{
                    self.stoploading()
                    self.showAlert(title: NSLocalizedString("No Internet", comment: ""), msg: NSLocalizedString("check your connection and try again", comment: ""),style:.warning)
                }
        }
        
        
    }
    
    
    func showAlert(title:String,msg:String,style:SCLAlertViewStyle){
        
        SCLAlertView().showTitle(
            title, // Title of view
            subTitle: msg, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: NSLocalizedString("OK", comment: "") , // Optional button value, default: ""
            style: style, // Styles - see below.
            colorStyle: 0x54BEC0,
            colorTextButton: 0xFFFFFF
        )
        
    }
    
    


    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
         let first = NSLayoutConstraint(item: firstNameTxt, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 1)
         NSLayoutConstraint.activate([first])
    }

}


