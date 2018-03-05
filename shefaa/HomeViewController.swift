//
//  HomeController.swift
//  E-MALL
//
//  Created by Nour  on 1/20/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
import Alamofire
import Firebase
import UserNotifications
class HomeViewController: UIViewController,MessagingDelegate,UNUserNotificationCenterDelegate{
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        sendToken(tok: fcmToken)
        Globals.fcmtoken = fcmToken
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    
//    fileprivate var menuButton: UIBarButtonItem!
    fileprivate var searchButton: IconButton!
    
    var ratio = 0.0
    
    var backGroundImage:UIImageView={
    
        let iv = UIImageView(image : UIImage(named: "BG-6"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var doctorLbl:UILabel={
    
        let l = UILabel()
        l.text = NSLocalizedString("Find a Doctor", comment: "")
        l.lineBreakMode = NSLineBreakMode.byWordWrapping
        l.textAlignment = .center
        l.numberOfLines = 1
        l.minimumScaleFactor = 0.5
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
  
    
    var callender:UIButton={
        let b = UIButton()
     //   b.setImage(UIImage(named:"my appointement")?.resize(toWidth: 90), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.layer.masksToBounds = true
        return b
    }()
    
    var PharmacyLbl:UILabel={
        
        let l = UILabel()
        l.text = NSLocalizedString("Find a Pharmacy", comment: "")
        l.lineBreakMode = NSLineBreakMode.byWordWrapping
        l.numberOfLines = 1
        l.textAlignment = .center
        l.minimumScaleFactor = 0.5
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    
    
    lazy var medicineBtn:UIButton={
        let b = UIButton()
     
        
        
     //   b.setImage(UIImage(named:"my medicine")?.resize(toWidth: 90), for: .normal)
        b.imageView?.contentMode = .scaleAspectFill
        return b
    }()
    
    
    var doctorBtn:UIButton = {
        let b = UIButton()
      //  b.setImage(UIImage(named:"doctor-search"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        
        return b
    }()
    
    var PharmacyBtn:UIButton = {
        let b = UIButton()
        //b.setImage(UIImage(named:"pharmacy-search"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFill
        return b
    }()
    
    
    
    override func viewDidLoad() {
        prapareNumofMessage()
        super.viewDidLoad()
        registerPushNotification()
        Messaging.messaging().delegate = self
        view.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor().mainColor()
        self.navigationController?.navigationBar.tintColor = .white
        
        prepareView()
        
        prepareMenuButton()
        prepareNavigationItem()
        
    }
    
    
    func prepareImages(){
    
        
        if(UIApplication.isRTL()){
            PharmacyBtn.setImage(#imageLiteral(resourceName: "pharmacy-1").resize(toHeight: CGFloat(300 * ratio)), for: .normal)
            doctorBtn.setImage(#imageLiteral(resourceName: "doctor-3").resize(toHeight: CGFloat(300 * ratio)), for: .normal)
            callender.setImage(#imageLiteral(resourceName: "appointment").resize(toHeight: CGFloat(300 * ratio)), for: .normal)
            medicineBtn.setImage(#imageLiteral(resourceName: "medicine").resize(toHeight: CGFloat(300 * ratio)), for: .normal)
        }else{
            PharmacyBtn.setImage(#imageLiteral(resourceName: "pharmacy-search").resize(toHeight: CGFloat(300 * ratio)), for: .normal)
            doctorBtn.setImage(#imageLiteral(resourceName: "doctor-search").resize(toHeight: CGFloat(300 * ratio)), for: .normal)
            callender.setImage(#imageLiteral(resourceName: "my appointement").resize(toHeight: CGFloat(300 * ratio)), for: .normal)
            medicineBtn.setImage(#imageLiteral(resourceName: "my medicine").resize(toHeight: CGFloat(300 * ratio)), for: .normal)

            
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prapareNumofMessage()
        prepareImages()
      // prepareImages()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token ?? "")")
            sendToken(tok: token)
            Globals.fcmtoken = token
        }
    }
    
    func prapareNumofMessage(){
        
        guard let user = Globals.user else{
            return
        }
        
        
        let url = Globals.baseUrl + "/count-pm?sess_id=\(user.sessid!)&sess_name=\(user.session_name!)&token=\(user.token!)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            print(response.response)
            switch response.result{
            case .success:
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if let badge = JSON as? String{
                        Globals.messegesNum = badge
                        NotificationCenter.default.post(name: Notification.Name("refresh"), object: nil)

                    }
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        

    
    }
    
    fileprivate func prepareMenuButton() {
        let  menuButton = UIBarButtonItem(image: Icon.cm.menu, style: .plain, target: self, action: #selector(handleMenuButton))
        menuButton.image = Icon.cm.menu
        menuButton.image = menuButton.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        //menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        
//        if(UIApplication.isRTL()){
//            navigationItem.rightBarButtonItems = [menuButton]
//        }
//        else{
            navigationItem.leftBarButtonItems = [menuButton]
///        }
        
    }
    
    
    @objc
    fileprivate func handleMenuButton() {
        print("dfdsfsd")
        if(!UIApplication.isRTL()){
            navigationDrawerController?.toggleLeftView()
        }
        else{
        
        navigationDrawerController?.toggleRightView()
        }
    }
    
    fileprivate func prepareNavigationItem() {
    
      
    }
  
    
    func prepareView(){
 
         ratio = Double(self.view.width / 750)
        self.title = NSLocalizedString("Shefaa", comment: "")
        self.navigationItem.titleLabel.textColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        view.addSubview(backGroundImage)
      //  view.addSubview(doctorLbl)
        view.addSubview(doctorBtn)
        view.addSubview(PharmacyBtn)
        view.addSubview(callender)
        view.addSubview(medicineBtn)
        callender.isHidden  = true
        medicineBtn.isHidden = true
        
       _ = backGroundImage.anchor8(view, topattribute: .top, topConstant: 0, leftview: view, leftattribute: .leading, leftConstant: 0, bottomview: view, bottomattribute: .bottom, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
          doctorBtn.CenterY(view, Constant: CGFloat(-150 * ratio))
         // doctorBtn.CenterX(view, Constant: -CGFloat(108 * ratio))
        
        _ = doctorBtn.anchor8(nil, topattribute: nil, topConstant: 0, leftview: view, leftattribute: .leading, leftConstant: CGFloat(50 * ratio), bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: nil, rightattribute: nil, rightConstant: 0, widthConstant: CGFloat(300 * ratio), heightConstant: CGFloat(300 * ratio))
        
            PharmacyBtn.CenterY(view, Constant: CGFloat(-150 * ratio))
        _ = PharmacyBtn.anchor8(nil, topattribute: nil, topConstant: 0, leftview: nil, leftattribute: .trailing, leftConstant: CGFloat(216 * ratio) , bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(50 * ratio), widthConstant: CGFloat(300 * ratio), heightConstant: CGFloat(300 * ratio))
        
        
        _ = callender.anchor8(doctorBtn, topattribute: .bottom, topConstant: CGFloat(100 * ratio), leftview: view, leftattribute: .leading, leftConstant: CGFloat(50 * ratio), bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: nil, rightattribute: nil, rightConstant: 0, widthConstant: CGFloat(300 * ratio), heightConstant: CGFloat(300 * ratio))
        
        _ = medicineBtn.anchor8(PharmacyBtn, topattribute: .bottom, topConstant: CGFloat(100 * ratio), leftview: nil, leftattribute: .trailing, leftConstant: CGFloat(216 * ratio) , bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: -CGFloat(50 * ratio), widthConstant: CGFloat(300 * ratio), heightConstant: CGFloat(300 * ratio))
        
        if(Globals.user?.isDoctor())!{
            self.callender.isHidden = false
        }
        
        if(Globals.user?.isPharmacy())!{
            self.medicineBtn.isHidden = false
        }
        
        PharmacyBtn.addTarget(self, action: #selector(handlePharmacySearch), for: .touchUpInside)
        
        doctorBtn.addTarget(self, action: #selector(handleDoctorSearch), for: .touchUpInside)
        medicineBtn.addTarget(self, action: #selector(handleMedicen), for: .touchUpInside)
        callender.addTarget(self, action: #selector(handelCallendar), for: .touchUpInside)
    
    }
    
    func handlePharmacySearch(){
        
        let vc = PharmacySearchViewController()
        vc.title = NSLocalizedString("Find a Pharmacy", comment: "")
        vc.navigationItem.titleLabel.textColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleDoctorSearch(){
        
        let vc = DoctorSearchViewController()
        vc.title = NSLocalizedString("Find a Doctor", comment: "")
        vc.navigationItem.titleLabel.textColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func handleMedicen(){
        
        let vc = PharmacyHomeViewController()
        vc.title = NSLocalizedString("Medicines", comment: "")
        vc.navigationItem.titleLabel.textColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    func handelCallendar(){
        let vc = UIStoryboard.viewController(identifier: "DoctorHomeViewController") as! DoctorHomeViewController
        
        vc.title = NSLocalizedString("Find a Doctor", comment: "")
        vc.navigationItem.titleLabel.textColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    func isLogedin()->Bool{
        
        return true
    }
    
    
    func sendToken(tok:String){
    
    
            let cooke = (Globals.user?.session_name)! + "=" + (Globals.user?.sessid)!
            let url = Globals.baseUrl + "/api/push_notifications"
            let parameter:[String:AnyObject] = ["token":tok as AnyObject,"type":"ios" as AnyObject]
        
            let parameterString = "token=\(tok)&type=ios"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(Globals.user?.token, forHTTPHeaderField: "X-CSRF-Token")
            request.setValue(cooke, forHTTPHeaderField: "Cookie")
            request.httpBody =  try! JSONSerialization.data(withJSONObject: parameter)
             
            Alamofire.request(request)
                .responseJSON { response in
                    
                    if let data = response.result.value {
                            print(data)
                    }else{
                        print(" -- - - - - - -error")
                }
    
            }
    }

    
    func registerPushNotification(){
    
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    
    }
    
}



