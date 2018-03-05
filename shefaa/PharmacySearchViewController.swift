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
class PharmacySearchViewController: UIViewController,UITextFieldDelegate{
    
    fileprivate var closeButton: IconButton!
    fileprivate var moreButton: IconButton!
    fileprivate var mapButton: IconButton!
    
    let refresh = UIRefreshControl()
    let cellid = "PharmacyCell"
    var isSearching = false
    var doctors:[Pharmacy] = []
    var searchresult:[Pharmacy] = []
    
    
    var price = ""
    var specs = ""
    var rate = ""
    
    
    var dropdown:YNDropDownMenu!
    
    let ZBdropDownViews = Bundle.main.loadNibNamed("DropDownViews", owner: nil, options: nil) as? [UIView]
    var vc:PriceVIew!
    var vc2:RateView!
    var vc3:SpecsView!
    var vc4:ZBFilterFeatureView!
    func prin(){
        
        
    }
    
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
        lodingView.frame  = view.frame
        wrongView.frame = view.frame
        emptyView.frame = view.frame
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
        txt.placeholder = NSLocalizedString("Pharmacy ,Medicine or City", comment: "")
        
        return txt
        
    }()
    
    func prepareSearchtextfield(){
        
//        if !UIApplication.isRTL() {
//            searchtextfield.leftViewMode = .always
//            let btn = UIButton()
//            btn.setImage(Icon.cm.moreVertical, for: .normal)
//            searchtextfield.leftView = btn
//            searchtextfield.rightView = nil
//        }else{
//            
//            searchtextfield.rightViewMode = .always
//            let btn = UIButton()
//            btn.setImage(Icon.cm.moreVertical, for: .normal)
//            searchtextfield.rightView = btn
//            searchtextfield.leftView = nil
//        }
        
        let mapbtn = UIButton()
        mapbtn.setImage(UIImage(named:"marker"), for: .normal)
        mapbtn.addTarget(self, action: #selector(showMap), for: .touchUpInside)
        
        view.addSubview(searchtextfield)
        view.addSubview(mapbtn)
        _ = searchtextfield.anchor8(view, topattribute: .top, topConstant: 40, leftview: view, leftattribute: .leading, leftConstant: 8, bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: -40, widthConstant: 0, heightConstant: 40)
        _ = mapbtn.anchor8(view, topattribute: .top, topConstant: 40, leftview: searchtextfield, leftattribute: .trailing, leftConstant: 1, bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        prepareSearchtextfield()
        prepareView()
        prepareMoreButton()
        prepareSearchBar()
        prepareViewState()
        prepareFiltter()
        loadData()
        
        
    }
    
    func prepareView(){
        self.navigationController?.navigationBar.barTintColor = UIColor().mainColor()
        
        view.addSubview(tableView)
        refresh.tintColor = .blue
        refresh.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: .valueChanged)
        tableView.addSubview(refresh)
        
        
        _ = tableView.anchor8(searchtextfield, topattribute: .bottom, topConstant: 8, leftview: view, leftattribute: .leading, leftConstant: 0, bottomview: view, bottomattribute: .bottom, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let nib = UINib(nibName: cellid , bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid )
        self.searchtextfield.returnKeyType = .search
        self.searchtextfield.delegate = self
        self.searchtextfield.addTarget(self, action: #selector(typing), for: .editingChanged)
        self.searchtextfield.clearIconButton?.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
        //self.searchBarController?.searchBar.textField.placeholder = NSLocalizedString("Name ,Country or City", comment: "")
        
    }
    
    func prepareFiltter(){
        
        let ZBdropDownViews = Bundle.main.loadNibNamed("DropDownViews", owner: nil, options: nil) as? [UIView]
        vc  = ZBdropDownViews?[0] as! PriceVIew
        vc2 = ZBdropDownViews?[1] as! RateView
        vc3 = ZBdropDownViews?[2] as! SpecsView
        
        vc.okBtn.addTarget(self, action: #selector(handlePriceFiltter), for: .touchUpInside)
        vc.cancelBtn.addTarget(self, action: #selector(handlePriceCancel), for: .touchUpInside)
        
        
        vc2.okBtn.addTarget(self, action: #selector(handleRateFiltter), for: .touchUpInside)
        vc2.cancelBtn.addTarget(self, action: #selector(handleRateCancel), for: .touchUpInside)
        
        
        vc3.okBtn.addTarget(self, action: #selector(handleSpecsFiltter), for: .touchUpInside)
        vc3.cancelBtn.addTarget(self, action: #selector(handleSpecsCancel), for: .touchUpInside)
        
        
        let views:[UIView] = [vc2]
        
        let FFA409 = UIColor(colorLiteralRed: 255/255, green: 164/255, blue: 9/255, alpha: 1.0)
        
        dropdown = YNDropDownMenu(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 38) , dropDownViews: views, dropDownViewTitles: [NSLocalizedString("Rate", comment: "")])
        
        dropdown.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_sel"), disabled: UIImage(named: "arrow_dim"))
        dropdown.setLabelColorWhen(normal: .black, selected: FFA409, disabled: .gray)
        dropdown.setLabelFontWhen(normal: .systemFont(ofSize: 12), selected: .boldSystemFont(ofSize: 12), disabled: .systemFont(ofSize: 12))
        
        dropdown.backgroundBlurEnabled = true
        
        dropdown.bottomLine.isHidden = false
        // Add custom blurEffectView
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        dropdown.blurEffectView = backgroundView
        dropdown.blurEffectViewAlpha = 0.7
        
        view.addSubview(dropdown)
        
    }
    
    
    func handlePriceFiltter(){
        price = (vc.priceTxt.text?.trimmed)!
        dropdown.alwaysSelected(at: 0)
        loadData()
    }
    
    func handlePriceCancel(){
        price = ""
        dropdown.normalSelected(at: 0)
        loadData()
    }
    
    
    func handleRateFiltter(){
        rate = "\(vc2.rateView.rating * 20)"
        dropdown.alwaysSelected(at: 0)
        loadData()
    }
    
    func handleRateCancel(){
        rate = ""
        dropdown.normalSelected(at: 0)
        loadData()
    }
    
    
    func handleSpecsFiltter(){
        specs = ""
        dropdown.alwaysSelected(at: 2)
        loadData()
    }
    
    func handleSpecsCancel(){
        specs = ""
        dropdown.normalSelected(at: 2)
        loadData()
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
            search(name: name.trimmed)
        }
        
        tableView.reloadData()
    }
    
    func search(name:String){
        
        searchresult = doctors.filter { result in
            return ((result.pharmacy_name?.lowercased().contains(name.lowercased()))! || (result.city?.lowercased().contains(name.lowercased()))! || (result.country?.lowercased().contains(name.lowercased()))! || (result.street?.lowercased().contains(name.lowercased()))! ||  (result.medicine_name?.lowercased().contains(name.lowercased()))!)
        }
        tableView.reloadData()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.loadData()
        refreshControl.endRefreshing()
    }
    
    
    func loadData(){
        self.view.endEditing(true)
        loding()
        if(!dropdown.isHidden){
            dropdown.hideMenu()
        }
        let url = Globals.mainUrl + "/api/search_medicine_service?field_rate_rating=\(rate)&language=en" + Globals.api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        Alamofire.request(url).responseJSON { response in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let res = Pharmacy.modelsFromDictionaryArray(array: JSON as! NSArray)
                self.doctors = res
                self.initilze()
                if self.doctors.count == 0{
                    self.empty()
                }
                self.tableView.reloadData()
            }else{
                self.error()
            }
        }
        
        
    }
    
    
}


extension PharmacySearchViewController{
    
    
    fileprivate func prepareCloseButton() {
        self.closeButton = IconButton(image: Icon.cm.close)
        self.closeButton.addTarget(self, action: #selector(self.handelClose), for: .touchUpInside)
    }
    
    fileprivate func prepareMoreButton() {
        self.moreButton = IconButton(image: Icon.cm.moreVertical)
        self.mapButton  = IconButton(image: UIImage(named:"marker"))
        self.mapButton.addTarget(self, action: #selector(showMap), for: .touchUpInside)
    }
    
    func showMap(){
        let vc = PharmacyMapViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    fileprivate func prepareSearchBar() {
        let btn = UIBarButtonItem(image: Icon.cm.arrowBack, style: .plain, target: self, action: #selector(handelClose))
        
        self.searchBarController?.navigationItem.backBarButtonItem = btn
        self.searchBarController?.searchBar.leftViews = [self.moreButton]
        self.searchBarController?.searchBar.rightViews = [self.mapButton]
    }
    
    
    func handelClose(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension PharmacySearchViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching == true {
            return self.searchresult.count
        }
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid , for: indexPath) as! PharmacyCell
        if self.isSearching == true {
            cell.doctor = searchresult[indexPath.row]
        }else{
            cell.doctor  = doctors[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(135)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doctor:Pharmacy!
        if isSearching == true{
            doctor = searchresult[indexPath.row]
        }
        else{
            doctor = doctors[indexPath.row]
        }
        let vc = PharmacyProfileViewController()
        vc.pharmacy = doctor
        vc.title = doctor.pharmacy_name!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

