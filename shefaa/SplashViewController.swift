//
//  SplashViewController.swift
//  shefaa
//
//  Created by Nour  on 4/15/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Alamofire
import Lottie
class SplashViewController: UIViewController {
    
    
    let userDefulat = UserDefaults.standard
    let progressHUD = ProgressHUD(text: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(progressHUD)
        
        _ = progressHUD.anchor(view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        loadData()
    }
    
    
    func loadData(){
        Globals.messegesNum = "0"
        if let username = userDefulat.string(forKey: "user"),let pass = userDefulat.string(forKey: "pass"){
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
                    switch response.result {
                    case .success:
                        print("Response String: \(response.result.value)")
                        if let _=response.result.value{
                        let url = Globals.baseUrl + "/api/user/login"
                        print(url)
                        let parameter:[String:AnyObject] = ["username":username as AnyObject,"password":pass as AnyObject]
                        var request = URLRequest(url: URL(string: url)!)
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.setValue(response.result.value!, forHTTPHeaderField: "X-CSRF-Token")
                        
                        request.httpBody = try! JSONSerialization.data(withJSONObject: parameter)
                       // request.timeoutInterval = 5
                        let manager = Alamofire.SessionManager.default
                        manager.session.configuration.timeoutIntervalForRequest = 50
                        
                        manager.request(request)
                            .responseJSON { response in
                                print("Request: \(response.request)")
                                print("Request: \(response.result.value)")
                                print("Response: \(response.response)")
                                print("Error: \(response.error)")
                                switch (response.result) {
                                case .success:
                                    if let JSON = response.result.value {
                                        print("JSON: \(JSON)")
                                        let user = User(dictionary: JSON as! NSDictionary)
                                        self.userDefulat.set(username, forKey: "user")
                                        self.userDefulat.set(pass, forKey: "pass")
                                        Globals.user = user
                                        Globals.isLogedin = true
                                        self.loadview()
                                    }else{
                                        self.faild()
                                    }
                                    
                                    break
                                case .failure(let error):
                                    if error._code == NSURLErrorTimedOut {
                                        print("time out")
                                    }
                                    print("\n\nAuth request failed with error:\n \(error)")
                                    self.faild()
                                    break
                                }
                            }
                        }else{
                        self.faild()
                        
                        }
                                case .failure(let error):
                                if error._code == NSURLErrorTimedOut {
                                    //HANDLE TIMEOUT HERE
                                }
                                print("\n\nAuth request failed with error:\n \(error)")
                                self.faild()
                    }
            }
            
        }else{
        self.faild()
        }
        
    }
    
  
    
    func faild(){
        Globals.user = nil
        Globals.isLogedin = false
        self.loadWindow()
    
    
    }
    
    func loadWindow(){
        self.perform(#selector(loadview), with: nil, afterDelay: 0.01)
    }
    
    func loadview(){
        
        
        let vc = UINavigationController(rootViewController:LoginViewController())
        
        self.present(vc, animated: true, completion: nil)
    }
    
}

