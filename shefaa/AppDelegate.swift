//
//  AppDelegate.swift
//  shefaa
//
//  Created by Nour  on 3/1/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import DropDown
import Material
import UserNotifications

import Firebase

import SCLAlertView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let userDefulat = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //AIzaSyBtV3wkgDkhT8Op4PUi1zcy_m1VmIi79G4
        
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
       Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
    /*    if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
      */
        // [END register_for_notifications]

        
        
        
        
        GMSPlacesClient.provideAPIKey("AIzaSyC60jYpUkCryH7NU2VqDky_cVxxshqxkhM")
        GMSServices.provideAPIKey("AIzaSyC60jYpUkCryH7NU2VqDky_cVxxshqxkhM")
        DropDown.startListeningToKeyboard()
        
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = UIColor().mainColor()
        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
            loadWindow()
        navigationBarAppearace.backItem?.backButton.setTitle(" ", for: .normal)
        navigationBarAppearace.backItem?.backButton.setImage(Icon.cm.arrowBack, for: .normal)
        
  //   L102Localizer.DoTheMagic()
        
        
        
           return true
    }
    
  
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType)
//    }
    
 
    
    func loadWindow(){
    
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let vc = UIStoryboard.viewController(identifier: "Splash")
        vc.edgesForExtendedLayout = []
        self.window?.rootViewController = vc
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(userInfo)")
        
        let dict = userInfo["aps"] as! NSDictionary
        print(dict)
        let d : [String : Any] = dict["alert"] as! [String : Any]
        let body : String = d["body"] as! String
        let title : String = d["title"] as! String
        print("Title:\(title) + body:\(body)")
        self.showAlertAppDelegate(title: title,message:body,buttonTitle:"ok",window:self.window!)
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(userInfo)")
       // print(userInfo)
        let dict = userInfo["aps"] as! NSDictionary
        print(dict)
        let d:[String:Any]  = dict["alert"] as! [String:Any]
       let body : String = d["body"] as! String
       let title : String = d["title"] as! String
        print("Title:\(title) + body: \(body)")
        self.showAlertAppDelegate(title: title,message:body,buttonTitle:"ok",window:self.window!)
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
      //  Messaging.messaging().apnsToken = deviceToken
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(notification.request.content.userInfo)")
        
   //     let dict = notification.request.content.userInfo["aps"] as! NSDictionary
     //   print(dict)
       // let d : [String : Any] = dict["alert"] as! [String : Any]
        let body : String = userInfo["body"] as! String
        let title : String = userInfo["title"] as! String
        print("Title:\(title) + body: \(body)")
        self.showAlertAppDelegate(title: title,message:body,buttonTitle:"ok",window:self.window!)
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("Handle push from foreground\(response.notification.request.content.userInfo)")
        
        let dict = response.notification.request.content.userInfo["aps"] as! NSDictionary
        print(dict)
       let d : [String : Any] = dict["alert"] as! [String : Any]
        let body : String = d["body"] as! String
        let title : String = d["title"] as! String
        print("Title:\(title) + body: \(body)")
        self.showAlertAppDelegate(title: title,message:body,buttonTitle:"ok",window:self.window!)
        
       
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]


extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
    
    
    func showAlertAppDelegate(title: String,message : String,buttonTitle: String,window: UIWindow){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
//        //window.rootViewController?.present(alert, animated: false, completion: nil)
//        (window.rootViewController as! SplashViewController).presentedViewController?.present(alert, animated: false, completion: nil)
//        
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
//        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "confirm"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
//            // continue your work
//            // important to hide the window after work completed.
//            // this also keeps a reference to the window until the action is invoked.
//            topWindow.isHidden = true
//        }))
//        
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 10)!,
            showCloseButton: true
            
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
//        alert.addButton(NSLocalizedString("OK", comment: "") ) {
//        //  topWindow.isHidden = true
//        }
        
        //alert.addButton(NSLocalizedString("Cancel", comment: "")){}
       // alert.showInfo(title, subTitle: message)//("", subTitle: NSLocalizedString("Change amount", comment: ""))
        alert.showInfo(title, subTitle: message, closeButtonTitle: "Ok", duration: 0, colorStyle: 0x54BEC0, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
        
        
        //topWindow.makeKeyAndVisible()
        //topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
    }
    // Firebase ended here
    
    
}

