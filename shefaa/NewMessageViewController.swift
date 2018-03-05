
//
//  NewMessageViewController.swift
//  shefaa
//
//  Created by Nour  on 8/16/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
import Alamofire
import SCLAlertView

class NewMessageViewController: UIViewController ,UITextFieldDelegate,UITextViewDelegate{

    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var toTxt: TextField!
    @IBOutlet weak var subject: TextField!
    
    @IBOutlet weak var msgBodyTxt: TextView!
    
    let progressHUD = ProgressHUD(text: "")
    var toname:String?
    var toId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let name =  toname {
            toTxt.text = name
        }
        
        subject.delegate = self
        msgBodyTxt.delegate = self
        self.view.addSubview(progressHUD)
        progressHUD.frame = view.frame
        progressHUD.hide()
        
    }
    
    func showAlert(title:String,msg:String,style:SCLAlertViewStyle){
        
        SCLAlertView().showTitle(
            title, // Title of view
            subTitle: msg, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: NSLocalizedString("OK", comment: ""), // Optional button value, default: ""
            style: style, // Styles - see below.
            colorStyle: 0x54BEC0,
            colorTextButton: 0xFFFFFF
        )
        
    }

    @IBAction func sendMsg(_ sender: UIButton) {
        let subj = subject.text?.trimmed
        
        
      
        let body = msgBodyTxt.text
        
        if subj?.characters.count == 0 {
            showAlert(title:"",msg: NSLocalizedString("Please enter a subject", comment: ""),style:.notice )
                return
        }
//
//        if body?.characters.count == 0{
//            showAlert(msg: "Message boady is empty !!")
//            return
//        }
        
        
        guard let to = toId else {
            return
        }
        guard let user = Globals.user else {
            return
        }
        
        ////send-new-pm?recipients_ids=5,39,43&subject=how are you doctors&body=hello, i am manager. &sess_id=uZ1V82xwt5HvfWBc- yikNyB888NjW0wgH2DxGfcLEn8&sess_name=SESS874240563f4c bd169c6b1135d378031d&token=8iIz3gcUXtrdD2y_5MzXJ- YMixnaPorSAZtx8pnTS2g
        
        progressHUD.show()
        
        let url = Globals.baseUrl + "/send-new-pm?recipients_ids=\(to)&subject=\(subj!)&body=\(body!)&sess_name=\(user.session_name!)&sess_id=\(user.sessid!)&token=\(user.token!)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        Alamofire.request(url).responseJSON { response in
            print(response.response)
            self.progressHUD.hide()
            switch response.result{
            case .success:
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    self.showAlert(title: "", msg:NSLocalizedString("Message sent successfully", comment: "") , style: .success)

                     self.navigationController?.popViewController(animated: true)
                }
                break
            case .failure(let error):
              
                self.showAlert(title:NSLocalizedString("Massege send faild", comment: "") , msg: NSLocalizedString("Try again later", comment: ""), style: .error)
                print(error)
                break
            }
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("dfsf")
        textField.resignFirstResponder()
        msgBodyTxt.becomeFirstResponder()
        //view.endEditing(true)
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    

}
