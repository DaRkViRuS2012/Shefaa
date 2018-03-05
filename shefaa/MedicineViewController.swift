//
//  MedicineViewController.swift
//  shefaa
//
//  Created by Nour  on 8/29/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Alamofire
class MedicineViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    var cellid = "MedicineandPotionCell"
    
    var id = ""
    var medicines:[MedicinePotion] = []
    
    
    var tableView:UITableView = {
        var tb = UITableView()
        
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        prepareViewState()
        prepareTableView()
        loadData()
    }

    func prepareView(){
    
        self.view.addSubview(tableView)
        _ = tableView.anchor8(view, topattribute: .top, topConstant: 0, leftview: view, leftattribute: .leading, leftConstant: 0, bottomview: view, bottomattribute: .bottom, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    
    }
    
    
    func prepareTableView(){
        let nib = UINib(nibName: cellid, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func loadData(){
    
    //http://shefaaonline.net/api/show_prescription_service_medicine?nid=850
    
        loding()
        guard let user =  Globals.user else{
            return
        }
        
        let uid = (user.user?.uid!)!
        print(uid)
        
        
        let url = Globals.baseUrl + "/api/show_prescription_service_medicine?nid=\(id)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        
        Alamofire.request(url).validate().responseJSON { response in
            print(response.response)
            switch (response.result){
            case .success :
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let res = MedicinePotion.modelsFromDictionaryArray(array: JSON as! NSArray)
                    self.medicines = res
                    self.initilze()
                    if self.medicines.count == 0{
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! MedicineandPotionCell
        cell.medicine = medicines[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
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
    
    

    
}
