//
//  DoctorProfileViewController.swift
//  shefaa
//
//  Created by Nour  on 3/25/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos
import Material
import Alamofire
import Kingfisher

class DoctorProfileViewController: UITableViewController {


    
    fileprivate var addButton: FabButton!
    fileprivate var audioLibraryMenuItem: MenuItem!
    fileprivate var reminderMenuItem: MenuItem!
    
    @IBOutlet weak var specializationLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!

    @IBOutlet weak var MapView: GMSMapView!
    
    @IBOutlet weak var priceLbl: UILabel!
    var ratio = 0.52
    
    var rateView: CosmosView!
    
    var openHour:[Clinic_open_hours] = []
    
    let titles = ["",NSLocalizedString("Specialization", comment: ""),NSLocalizedString("Address", comment: ""),NSLocalizedString("Price", comment: ""),NSLocalizedString("Open Hours", comment: ""), NSLocalizedString("Rate", comment: ""),NSLocalizedString("Map", comment: "")]
    
    
    var progressHUD = ProgressHUD(text: "")
    
    
    var doctor:Doctor?{
    
    
        didSet{
        
        openHour = (doctor?.clinic_open_hours)!
        tableView.reloadData()
            // print(doctor?.dictionaryRepresentation())
        }
    }
    
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // prepareMenuController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor().mainColor()
        ratio = Double(self.view.width / 750)
        // self.navigationItem.title = doctor?.name!
        self.title = doctor?.name!
        self.navigationItem.titleLabel.textColor = .white
        self.edgesForExtendedLayout = []
      //  prepareAddButton()
      //  prepareAudioLibraryButton()
      //  prepareBellButton()
        prepareTableView()
        prepareMessageBtn()
        
//        self.view.addSubview(progressHUD)
//        progressHUD.translatesAutoresizingMaskIntoConstraints
//    //    _ = progressHUD.anchor(view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//        progressHUD.frame = UIScreen.main.bounds
//       // progressHUD.hide()
    }
    
    
    
    
    
    func prepareMessageBtn(){
        
        let btn  = UIBarButtonItem(image: Icon.email, style: .plain, target: self, action: #selector(newMsg))
        self.navigationItem.rightBarButtonItem = btn
    }
    
    func newMsg(){
        let vc = UIStoryboard.viewController(identifier: "NewMessageViewController") as! NewMessageViewController
        vc.navigationItem.titleLabel.textColor = .white
        vc.title = NSLocalizedString("New Message", comment: "")
        vc.toname = doctor?.name
        vc.toId  = doctor?.doctor_id
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    
    func prepareTableView(){
    
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "profileimage")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "specsCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "addressCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mapCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PriceCell")
        let nib =  UINib(nibName: "openHourCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "openhourCell")
        let nib2 =  UINib(nibName: "RateCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "RateCell")
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section)
        
        if indexPath.section == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileimage", for: indexPath)
        let imageView = UIImageView()
            
            
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("application/json", forHTTPHeaderField: "Content-Type")
                r.setValue(Globals.token, forHTTPHeaderField: "X-CSRF-Token")
                return r
            }
            imageView.tintColor = .black
            
        imageView.layer.masksToBounds = true
        imageView.kf.indicatorType = .activity
            
                if let picture = doctor?.picture{
                let url = URL(string: picture)
                imageView.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "user13"), options: [.requestModifier(modifier)])
                }
            
        
        imageView.contentMode = .scaleAspectFit
        cell.addSubview(imageView)
        cell.backgroundColor = .white
        imageView.frame = CGRect(x: 0, y: 0, width: cell.width, height: cell.height )
        let btn = UIButton()
        cell.addSubview(btn)
            
       _ = btn.anchor8(nil, topattribute: nil, topConstant: 0, leftview: nil, leftattribute: nil, leftConstant: 0, bottomview: cell , bottomattribute: .bottom, bottomConstant: CGFloat(-18 * ratio), rightview: cell, rightattribute: .trailing, rightConstant: CGFloat(-18 * ratio), widthConstant: CGFloat(164 * ratio), heightConstant: CGFloat(164 * ratio))
        btn.setImage(UIImage(named:"add appointement"), for: .normal)
            btn.addTarget(self, action: #selector(normal), for: .touchUpInside)
            
//        let nameLbl = UILabel()
//        nameLbl.text = doctor?.name!
//        cell.addSubview(nameLbl)
//        nameLbl.anchor8(nil, topattribute: nil, topConstant: 0, leftview: cell, leftattribute: .leading , leftConstant: CGFloat(-18 * ratio), bottomview: cell, bottomattribute: .bottom, bottomConstant: CGFloat(-18 * ratio), rightview: btn, rightattribute: .leading, rightConstant: 5, widthConstant: 0, heightConstant: 30)
        return cell
        }
        if indexPath.section == 1{
            print(indexPath.item)
            print("specs")
            let cell = tableView.dequeueReusableCell(withIdentifier: "specsCell", for: indexPath)
            var specs = ""
            
            for spec in (doctor?.doctor_specialization)!{
                specs += " " + spec
            }
            cell.textLabel?.text = specs
            return cell
        }
        if indexPath.section == 2{
            print("address")
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
            var address = ""
            address = (doctor?.country)! + "-" + (doctor?.city)! + "-" + (doctor?.street)!
            cell.textLabel?.text = address
            return cell
        }
        
        if indexPath.section == 3{
            print("price")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath)
            var price = ""
            if let _ = doctor?.cost{
               price = (doctor?.cost)!
            }
            cell.textLabel?.text = price
            return cell
        }
        print("asdasda")
        if indexPath.section == 4{
            print("open")
            let cell = tableView.dequeueReusableCell(withIdentifier: "openhourCell", for: indexPath) as! openHourCell
            cell.date = openHour[indexPath.row]
            return cell
        }
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateCell", for: indexPath) as! RateCell
                cell.rate = doctor?.rate
            cell.rateView.didFinishTouchingCosmos = {rating in
            
                self.rate(value: rating)
            
            }
            return cell
        }
        
        if indexPath.section == 6 {
            print("map")
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath)
            let lat = Double((doctor?.latitude)!)!
            let long =  Double((doctor?.longitude)!)!
            
            let camera = GMSCameraPosition.camera(withLatitude: lat , longitude:long, zoom: 12.0)
            let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width , height: cell.frame.height) , camera: camera)
            let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat, long))
            marker.map = mapView
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
            marker.title = doctor?.name!
            cell.addSubview(mapView)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
 
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
        return openHour.count
        }
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
         return 7
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
        return CGFloat(400 * ratio)
        }
        if indexPath.section == 6{
        return CGFloat(500 * ratio)
        }
        return 50
     }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
        return 0
        }
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
       // headerView.layer.borderColor = UIColor.gray.cgColor
        //headerView.layer.borderWidth = 0.5
        let lineView = UIView()
        lineView.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
        headerView.addSubview(lineView)
        if (section > 0) {
            headerView.backgroundColor = .white
            let label = UILabel()
            label.text = titles[section]
            headerView.addSubview(label)
            _ = label.anchor8(headerView, topattribute: .top, topConstant: 0, leftview: headerView, leftattribute: .leading, leftConstant: 8, bottomview: headerView, bottomattribute: .bottom, bottomConstant: 0, rightview: nil, rightattribute: nil, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            label.textColor = .gray
            _ = lineView.anchor8(nil, topattribute: nil, topConstant: 0, leftview: headerView, leftattribute: .leading, leftConstant: 15, bottomview: headerView, bottomattribute: .bottom, bottomConstant: 0, rightview: headerView, rightattribute: .trailing, rightConstant: -15, widthConstant: 0, heightConstant: 1)
        } else {
            headerView.backgroundColor = UIColor.clear
        }
        return headerView
    }
    
    
    
    
    func rate(value:Double){
        progressHUD.show()
        let r:Int = Int(value * 20.0)
        let url = Globals.mainUrl + "/rate?target=\((doctor?.doctor_id)!)&uid=\((Globals.user?.user?.uid)!)&rate=\(r)&language=en" + Globals.api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        Alamofire.request(url).responseJSON { response in
            self.progressHUD.hide()
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                print ( response.description)
                print(error)
            }
        }
        
    
    }
}



extension DoctorProfileViewController {
    fileprivate func prepareAddButton() {
        addButton = FabButton(image: Icon.cm.add, tintColor: .white)
        addButton.pulseColor = .white
        addButton.backgroundColor = Color.red.base
        addButton.addTarget(self, action: #selector(handleToggleMenu), for: .touchUpInside)
    }
    
    fileprivate func prepareAudioLibraryButton() {
        audioLibraryMenuItem = MenuItem()
        audioLibraryMenuItem.button.image = Icon.cm.pen
        audioLibraryMenuItem.button.tintColor = .white
        audioLibraryMenuItem.button.pulseColor = .white
        audioLibraryMenuItem.button.backgroundColor = Color.green.base
        audioLibraryMenuItem.button.depthPreset = .depth1
        audioLibraryMenuItem.title = "Normal"
        audioLibraryMenuItem.button.addTarget(self, action: #selector(normal), for: .touchUpInside)
    }
    
    fileprivate func prepareBellButton() {
        reminderMenuItem = MenuItem()
        reminderMenuItem.button.image = Icon.cm.bell
        reminderMenuItem.button.tintColor = .white
        reminderMenuItem.button.pulseColor = .white
        reminderMenuItem.button.backgroundColor = Color.red
        reminderMenuItem.button.depthPreset = .depth1
        reminderMenuItem.title = "Urgent"
        reminderMenuItem.button.addTarget(self, action: #selector(urgent), for: .touchUpInside)
    }
    
    func normal(){
        menuController?.closeMenu()
        let vc = UIStoryboard.viewController(identifier: "AppointmentViewController") as! AppointmentViewController
        vc.doctor = doctor
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    func urgent(){
    menuController?.closeMenu()
        let vc = UIStoryboard.viewController(identifier: "AppointmentViewController") as! AppointmentViewController
        vc.doctor = doctor
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    fileprivate func prepareMenuController() {
        guard let mc = menuController as? AppMenuController else {
            return
        }
        
        mc.menu.delegate = self
        mc.menu.views = [addButton, audioLibraryMenuItem, reminderMenuItem]
    }
}

extension DoctorProfileViewController {
    @objc
    fileprivate func handleToggleMenu(button: Button) {
        guard let mc = menuController as? AppMenuController else {
            return
        }
        
        if mc.menu.isOpened {
            mc.closeMenu { (view) in
                (view as? MenuItem)?.hideTitleLabel()
            }
        } else {
            mc.openMenu { (view) in
                (view as? MenuItem)?.showTitleLabel()
            }
        }
    }
}

extension DoctorProfileViewController: MenuDelegate {
    func menu(menu: Menu, tappedAt point: CGPoint, isOutside: Bool) {
        guard isOutside else {
            return
        }
        
        guard let mc = menuController as? AppMenuController else {
            return
        }
        
        mc.closeMenu { (view) in
            (view as? MenuItem)?.hideTitleLabel()
        }
    }
}
