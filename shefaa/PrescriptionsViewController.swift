//
//  PrescriptionsViewController.swift
//  shefaa
//
//  Created by Nour  on 4/15/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Alamofire

class PrescriptionsViewController: UITableViewController {

    
    var prescriptions:[Prescription] = []
    
    let cellId = "CellId"
    
    
    
    var lodingView:LoadingView = {
        let v = LoadingView()
        return v
    }()
    
    var emptyView:EmptyView = {
        let v = EmptyView()
        return v
    }()
    
    var wrongView:ErrorView = {
        let v = ErrorView()
        return v
    }()
    
    
    func prepareViewState(){
        view.addSubview(lodingView)
        view.addSubview(wrongView)
        view.addSubview(emptyView)
        lodingView.frame  = CGRect(x: 0, y: 39, width: self.view.frame.width, height: self.view.frame.height - 40)
        wrongView.frame = CGRect(x: 0, y: 39, width: self.view.frame.width, height: self.view.frame.height - 40)
        emptyView.frame = CGRect(x: 0, y: 39, width: self.view.frame.width, height: self.view.frame.height - 40)
        emptyView.tapGestureRecognizer.addTarget(self, action: #selector(loadData))
        wrongView.tapGestureRecognizer.addTarget(self, action: #selector(loadData))
        initilze()
    }
    
    func initilze(){
        
        lodingView.isHidden = true
        wrongView.isHidden = true
        emptyView.isHidden = true
    }
    
    func loding(){
        lodingView.isHidden = false
        wrongView.isHidden = true
        emptyView.isHidden = true
    }
    
    func error(){
        lodingView.isHidden = true
        wrongView.isHidden = false
        emptyView.isHidden = true
    }
    func empty(){
        
        lodingView.isHidden = true
        wrongView.isHidden = true
        emptyView.isHidden = false
    }
    

    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor().mainColor()
        let nib = UINib(nibName: "PrescriptionsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        prepareViewState()
        loadData()
        self.title = NSLocalizedString("Prescriptions", comment: "")
        self.navigationItem.titleLabel.textColor = .white
        
       // tableView.allowsSelection = false
        // Do any additional setup after loading the view.
    }

    
    
    
    
    func loadData(){
        print("load")
        
        loding()
        guard let user =  Globals.user else{
            return
        }
       
        let uid = (user.user?.uid!)!
        print (uid)
        
    // "http://shefaa.online/api-prescription?sess_name=SESSd027d45fa73fa119741a9e84ef80f829&sess_id=TeRN3cD4QZjb5_cLU-sadn7iI-hxZtyjYrE9nNCdUrs&token=l6rsbU_dJudnYcxapx3zLsCggPwas3GY3g1gThYyNF8&patient_id=1"
        let url = Globals.baseUrl + "/api-prescription?sess_name=\(user.session_name!)&sess_id=\(user.sessid!)&token=\(user.token!)&patient_id=\(uid)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        
        Alamofire.request(url).validate().responseJSON { response in
            print(response.response)
            switch (response.result){
            case .success :
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let res = Prescription.modelsFromDictionaryArray(array: JSON as! NSArray)
                self.prescriptions = res
                self.initilze()
                if self.prescriptions.count == 0{
                    self.empty()
                }
                self.tableView.reloadData()
            }else{
                self.error()
            }
            
            case .failure:
               self.error()
            }
        }
        
    }
    
    func showAlert(title:String,msg:String){
    
    
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescriptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PrescriptionsCell
        cell.prescription = prescriptions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(130)
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.viewController(identifier: "PrescriptionViewController") as! PrescriptionViewController
        vc.prescription = prescriptions[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
