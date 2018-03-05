//
//  updateMedicineTableViewController.swift
//  shefaa
//
//  Created by Nour  on 8/15/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
class updateMedicineTableViewController: UITableViewController {

    @IBOutlet weak var medId: UILabel!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var remining: UILabel!
    
    var med:medicine?
    let progressHUD = ProgressHUD(text: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = med?.batch_ID {
            medId.text = id
        }
        if let amount = med?.amount {
            Amount.text = amount
        }
        
        if let rem = med?.remainingamount {
            remining.text = rem
        }
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        self.tableView.addSubview(progressHUD)
        
      //  _ = progressHUD.anchor(tableView.topAnchor, left: tableView.leadingAnchor, bottom: tableView.bottomAnchor, right: tableView.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        progressHUD.frame = UIScreen.main.bounds
        progressHUD.hide()

    }

    
    @IBAction func updateAmount(_ sender: UIButton) {
        
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 10)!,
            showCloseButton: false
            
        )
        
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField(NSLocalizedString("Enter new amount", comment: ""))
        txt.keyboardType = .numberPad
        alert.addButton(NSLocalizedString("Save", comment: "") ) {
            print("Text value: \(txt.text)")
            if  let value = Int(txt.text!) {
                    self.remining.text = "\(value)"
                    self.tableView.reloadData()
            }
        }
        alert.addButton(NSLocalizedString("Cancel", comment: "")){}
        //alert.showEdit("", subTitle: NSLocalizedString("Change amount", comment: ""))
        alert.showEdit("", subTitle: NSLocalizedString("Change amount", comment: ""), closeButtonTitle: NSLocalizedString("Camcel", comment: ""), duration: 0, colorStyle: 0x54BEC0, colorTextButton: 0xffffff, circleIconImage: nil, animationStyle: .noAnimation)
//        
//        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
//        
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
//            alert -> Void in
//            
//            let firstTextField = alertController.textFields![0] as UITextField
//            
//            if  let value = Int(firstTextField.text!) {
//                    self.remining.text = "\(value)"
//                    self.tableView.reloadData()
//            }else{
//            
//                alertController.dismiss(animated: true, completion: { 
//                    let alert = UIAlertController(title: "", message: "Enter a vaild number", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
//                        (action : UIAlertAction!) -> Void in
//                        
//                    }))
//                   self.present(alert, animated: true, completion: nil)
//                })
//            }
//        })
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
//            (action : UIAlertAction!) -> Void in
//            
//        })
//        
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Remaining amount"
//            textField.keyboardType = .numberPad
//        }
//        
//        
//        alertController.addAction(saveAction)
//        alertController.addAction(cancelAction)
//        
//        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func update(_ sender: UIButton) {
            print("ok")
        
            guard let user =  Globals.user else{
                return
            }
        progressHUD.show()
        
        
            
        guard let uid = user.user?.uid else{
            return
        }
        
        guard let bid = med?.batch_ID else{
            return
        }
        guard let rem = remining.text else{
            return
        }
        
            let url = Globals.baseUrl + "/update-amount?sess_name=\(user.session_name!)&sess_id=\(user.sessid!)&token=\(user.token!)&uid=\(uid)&bid=\(bid)&remain=\(rem)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            print(url)
            
            Alamofire.request(url).responseJSON { response in
                print(response.response)
                self.progressHUD.hide()
                switch response.result{
                case .success:
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                 _ =   self.navigationController?.popViewController(animated: true)
                }
                    break
                case .failure(let error):
                    print(error)
                break
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}
