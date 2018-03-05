//
//  SearchViewController.swift
//  FastFood
//
//  Created by Nour  on 1/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
import Alamofire
import YNDropDownMenu
import DropDown

class PharmacyHomeViewController: UIViewController,UITextFieldDelegate{
    
    fileprivate var closeButton: IconButton!
    fileprivate var moreButton: IconButton!
    fileprivate var mapButton: IconButton!
    
   
    
    let cellid = "typecell"
    var isSearching = false
    var medicines:[medicine] = []
    var searchresult:[medicine] = []
    
    var Spex:[String] = []
    
    var price = ""
    var rate = ""
    var specs = ""
    
  
    
    
    
    lazy var tableView:UITableView={
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.keyboardDismissMode = .interactive
        return table
    }()
    
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
        lodingView.frame  = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 0)
        wrongView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 0)
        emptyView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 0)
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
    
    
    
    
    
    var searchtextfield:TextField = {
        
        let txt = TextField()
        txt.placeholder = NSLocalizedString("Medicine name , id", comment: "")
        
        return txt
        
    }()
    
    func prepareSearchtextfield(){
        
        searchtextfield.leftViewMode = .always
    
        
        
        view.addSubview(searchtextfield)
       
        _ = searchtextfield.anchor8(view, topattribute: .top, topConstant: 0, leftview: view, leftattribute: .leading, leftConstant: 16, bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: -16, widthConstant: 0, heightConstant: 40)
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
     //   prepareNavgationBar()
        prepareSearchtextfield()
        prepareCloseButton()
        prepareView()
        prepareBackBtn()
        prepareViewState()
        
        //loadData()
        self.navigationController?.navigationBar.barTintColor = UIColor().mainColor()
        prepareSearchBar()
        
    }
    
    func prepareView(){
        
        self.title = NSLocalizedString("Medicines", comment: "")
        self.navigationItem.titleLabel.textColor = .white
        
        self.edgesForExtendedLayout = []
        view.addSubview(tableView)
        
        
        _ = tableView.anchor8(searchtextfield, topattribute: .bottom, topConstant: 8, leftview: view, leftattribute: .leading, leftConstant: 0, bottomview: view, bottomattribute: .bottom, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let nib = UINib(nibName: cellid , bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell" )
        self.searchtextfield.returnKeyType = .search
        self.searchtextfield.delegate = self
        self.searchtextfield.addTarget(self, action: #selector(typing), for: .editingChanged)
        self.searchtextfield.clearIconButton?.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
       // self.searchBarController?.searchBar.textField.placeholder = NSLocalizedString("Medicine name", comment: "")
        
        
    }
    
    
    func prepareBackBtn(){
        print("adasds")
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    func clear(){
        self.isSearching = false
        tableView.reloadData()
    }
    func endEdit(){
        let name = (self.searchtextfield.text)!
        if name.isEmpty(){
            self.isSearching = false
        }
        tableView.reloadData()
    }
    
    
    
    func typing(){
        let name = (self.searchtextfield.text)!
        if name.isEmpty(){
            self.isSearching = false
        }else{
            self.isSearching  = true
            search(name: name)
        }
        
        tableView.reloadData()
    }
    
    func search(name:String){
        
        searchresult = medicines.filter { result in
            return ((result.medicine_name!.lowercased().contains(name.lowercased()))||(result.batch_ID?.lowercased().contains(name.lowercased()))!)
        }
        tableView.reloadData()
        
    }
    
    
    
    
    func loadData(){
        print("load")
        self.view.endEditing(true)
        loding()
       
        guard let user =  Globals.user else{
            return
        }
        let uid = (user.user?.uid!)!
        let url = Globals.baseUrl + "/api-medicine-amount?uid=\(uid)&sess_name=\(user.session_name!)&sess_id=\(user.sessid!)&token=\(user.token!)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        
        Alamofire.request(url).validate().responseJSON { response in
            print(response.result.value)
            
            switch response.result {
            case .success :
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let res = medicine.modelsFromDictionaryArray(array: JSON as! NSArray)
                self.medicines = res
                self.initilze()
                if self.medicines.count == 0{
                    self.empty()
                }
                
                self.tableView.reloadData()
            }else{
                self.error()
                }
            
            case .failure :
                self.error()
                
            }
            
        }
    }
    
 
    
    func prepareNavgationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
}


extension PharmacyHomeViewController{
    
    
    fileprivate func prepareCloseButton() {
        self.closeButton = IconButton(image: Icon.cm.close)
        closeButton.image = closeButton.image?.withRenderingMode(.alwaysOriginal)
        self.closeButton.addTarget(self, action: #selector(self.handelClose), for: .touchUpInside)
    }
    
    
    
    
    
    fileprivate func prepareSearchBar() {
         self.moreButton = IconButton(image: Icon.cm.moreVertical)
        self.searchBarController?.searchBar.leftViews = [self.moreButton]
        
    }
    

    
    func handelClose(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}

extension PharmacyHomeViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching == true {
            return self.searchresult.count
        }
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) as! typecell
        if self.isSearching == true {
            cell.title.text = searchresult[indexPath.row].medicine_name!
            cell.subtitle.text = "ID : \(searchresult[indexPath.row].batch_ID!)"
        }else{
            cell.title.text = medicines[indexPath.row].medicine_name!
            cell.subtitle.text = "ID : \(medicines[indexPath.row].batch_ID!)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let medec:medicine!
        if isSearching == true{
            medec = searchresult[indexPath.row]
        }
        else{
            medec = medicines[indexPath.row]
        }
        
            let vc =  UIStoryboard.viewController(identifier: "updateMedicineTableViewController") as! updateMedicineTableViewController
            vc.med = medec
        if let name =  medec.medicine_name {
            vc.title = name
        }
       self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

