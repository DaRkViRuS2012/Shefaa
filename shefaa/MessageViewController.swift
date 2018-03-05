//
//  MessageViewController.swift
//  shefaa
//
//  Created by Nour  on 8/17/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
import Alamofire
class MessageViewController: UIViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    
    var msg:Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let msg = msg else{
            return
        }
        
        if let d = msg.timestamp {
            self.dateLbl.text = d
        }
        
        if let body = msg.body{
            textView.text = body
        }
        
        if let author = msg.author?.name {
            self.title  = author
        }
        self.navigationItem.titleLabel.textColor = .white
        prepareMessageBtn()
        markasRead()
    }
    
    func prepareMessageBtn(){
        
        let btn  = UIBarButtonItem(image: Icon.email, style: .plain, target: self, action: #selector(newMsg))
        self.navigationItem.rightBarButtonItem = btn
    }
    
    func newMsg(){
        let vc = UIStoryboard.viewController(identifier: "NewMessageViewController") as! NewMessageViewController
        vc.navigationItem.titleLabel.textColor = .white
        vc.title = NSLocalizedString("Reply", comment: "")
        vc.toname = msg?.author?.name
        vc.toId  = msg?.author?.uid
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func markasRead(){
        
        //markasread-pm?message_id=27&sess_id=uZ1V82xwt5HvfWBc- yikNyB888NjW0wgH2DxGfcLEn8&sess_name=SESS874240563f4cbd169 c6b1135d378031d&token=8iIz3gcUXtrdD2y_5MzXJ- YMixnaPorSAZtx8pnTS2g
        guard let id = msg?.mid else{
            return
        }
        
        guard let user = Globals.user else{
        
            return
        }
        
        
        let url = Globals.baseUrl + "/markasread-pm?message_id=\(id)&rec=\(user.user?.uid)&sess_name=\(user.session_name!)&sess_id=\(user.sessid!)&token=\(user.token!)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        Alamofire.request(url).responseJSON { response in
            print(response.response)
            switch response.result{
            case .success:
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }

    
    }


}
