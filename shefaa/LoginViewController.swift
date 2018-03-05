//
//  LoginViewController.swift
//  FastFood
//
//  Created by Nour  on 1/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView
import SafariServices

class LoginViewController: UIViewController,UITextFieldDelegate,SFSafariViewControllerDelegate {

    
    let userDefulat = UserDefaults.standard
    let signupUrl  = "http://shefaaonline.net/user/register"
    let loginview = LoginView()
    let progressHUD = ProgressHUD(text: "")
    var safariVC:SFSafariViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.edgesForExtendedLayout = []
        if(Globals.isLogedin == true)
        {
            ShowHomeViewController()
        }
        setupViews()
        addKeyboardobserver()
        prepareNavgationBar()
    }
    
    func startloding(){
        progressHUD.isHidden = false
    }
    func stoploading(){
        progressHUD.isHidden = true
    }
    
    
    func injected() {
        setupViews()
        print("I've been injected: \(self)")
    }
    
     func dismis() {
    
        //let presentingViewController = self.presentingViewController
        self.dismiss(animated: false, completion: {
                self.ShowHomeViewController()
        })
        
    }
    
        func dismisss(){
        
            let presentingViewController = self.presentingViewController
            self.dismiss(animated: false, completion: {
                presentingViewController!.dismiss(animated: true, completion: {})
            })
        }
    
    func ShowHomeViewController(){
      

        
            print("patient")
            let homeViewController = HomeViewController()
            if(!UIApplication.isRTL()){
                let vc = AppNavigationDrawerController(rootViewController: UINavigationController(rootViewController: homeViewController), leftViewController: LeftViewController(), rightViewController: nil)
                present(vc, animated: true, completion: nil)
                return
            }
            else
            {
                
                let vc = AppNavigationDrawerController(rootViewController: UINavigationController(rootViewController: homeViewController), leftViewController: nil, rightViewController: LeftViewController())
                present(vc, animated: true, completion: nil)
                return
        }
    }
        
    func setupViews(){
        
        safariVC?.delegate = self
        
        
    //  self.navigationController?.navigationBar.isTranslucent = true
        
      view.backgroundColor = .white
     
    //  self.title = NSLocalizedString("Sign in", comment: "")
      self.navigationItem.titleLabel.textColor = .white
        
      loginview.emailTextField.tag   = 1
      loginview.passTextField.tag    = 2
        
      loginview.emailTextField.delegate = self
      loginview.passTextField.delegate = self
        
      loginview.signinBtn.addTarget (self, action: #selector(handelSignin), for: .touchUpInside)
      loginview.signupBtn.addTarget(self, action: #selector(handelSignup), for: .touchUpInside)
      self.view = loginview
      self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard)))
        
        self.view.addSubview(progressHUD)
        
        _ = progressHUD.anchor(view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        progressHUD.hide()
    }
    
    func endEdit() {
        view.endEditing(true)
        print("sadasd")
    }
    
    
    
    
    func creatJson(data:Dictionary<String,AnyObject>) -> String? {
        
        let parameters = NSMutableDictionary()
        
        for (key,value) in data{
            parameters.setValue(value, forKey: key)
        }
        
        do{
            let jsonResult = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
//            jsonData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
//            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            let jsonString = NSString(data: jsonResult, encoding: String.Encoding.utf8.rawValue) as! String
            return jsonString
        } catch {
            return nil
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
    
    
    func handelSignin(){
    
        print("Sign In ....")
        hideKeyboard()
        let username = loginview.emailTextField.text?.trimmed
        let pass = loginview.passTextField.text
        if((username?.isEmpty())!||(pass?.isEmpty())!){
            self.showAlert(title: "", msg:NSLocalizedString("Enter your username and password", comment: "") ,style:.error)
        }else{
       progressHUD.show()
        let urlToken = Globals.baseUrl + "/services/session/token"
            print(urlToken)
        var request1 = URLRequest(url: URL(string: urlToken)!)
        
        request1.httpMethod = "GET"
        request1.timeoutInterval = 50
        request1.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
        let cstorage = HTTPCookieStorage.shared
        if let cookies = cstorage.cookies(for: URL(string: urlToken)!) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
        Alamofire.request(request1)
            .responseString { response in
                print("Response String: \(response.result.value)")
                
                if let _=response.result.value{
                let url = Globals.baseUrl + "/api/user/login"
                let parameter:[String:AnyObject] = ["username":username as AnyObject,"password":pass as AnyObject]
                let parameterString = "username=\(username)&password=\(pass)"
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(response.result.value!, forHTTPHeaderField: "X-CSRF-Token")
                Globals.token = response.result.value!
                request.timeoutInterval = 50
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameter)

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
                            let user = User(dictionary: data as! NSDictionary)
                            self.userDefulat.set(username, forKey: "user")
                            self.userDefulat.set(pass, forKey: "pass")
                            Globals.user = user
                            Globals.isLogedin = true
                            self.ShowHomeViewController()
                        }else{
                            self.stoploading()
                            self.showAlert(title: NSLocalizedString("No Internet", comment: ""), msg: NSLocalizedString("check your connection and try again", comment: ""),style:.warning)
                        }
                    }

                }else{
                    self.stoploading()
                    self.showAlert(title: NSLocalizedString("No Internet", comment: ""), msg:NSLocalizedString("check your connection and try again", comment: ""),style:.warning)
                }
        }
        
        }
      
    }
    
    func handelSignup(){
        hideKeyboard()
//        
//        let vc = UIStoryboard.viewController(identifier: "RegisterViewController") as! RegisterViewController
//        
//        self.present(vc, animated: true, completion: nil)
//    
        
         safariVC = SFSafariViewController(url: NSURL(string: signupUrl)! as URL)
        self.present(safariVC!, animated: true, completion: nil)
    }
    
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }

    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    
    func addKeyboardobserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    
    func keyboardHidden(){
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    
    
    func keyboardShown(notification:NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        print(keyboardHeight)
        
        
        view.frame = CGRect(x: 0, y: -(keyboardHeight / 2), width: view.frame.width, height: view.frame.height)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1{
            return loginview.passTextField.becomeFirstResponder()
        }
        if(textField.tag == 2){
        
            handelSignin()
        }
        
        return true
    }
    
    
    func prepareNavgationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    


}
