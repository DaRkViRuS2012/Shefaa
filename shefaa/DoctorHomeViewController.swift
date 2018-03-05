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
import SwiftyJSON
import SCLAlertView

class DoctorHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var stateSegment: UISegmentedControl!
    
    @IBOutlet weak var buttonsViewHeightConstraint: NSLayoutConstraint!
    fileprivate var menuButton: IconButton!
    fileprivate var searchButton: IconButton!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var urgentswitch: UISwitch!
    
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var approvedBtn: UIButton!
    
    @IBOutlet weak var notApprovedBtn: UIButton!
    
    
    
    var approved :Bool = true
    
    var appointments:[Appointment] = []
    var fillterdappointments:[Appointment] = []
    let mainColor = UIColor(red: 84/255, green: 193/255, blue: 188/255, alpha: 1)
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale =   Locale(identifier: "en_US")//   NSLocale(localeIdentifier: "en_US") as Locale!
        return formatter
    }()
    
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    
    
    func filter(){
        
        
        let d = self.calendar.selectedDate
        let date = dateFormatter.string(from: d!)
        print("date : \(date)")
        self.fillterdappointments = self.appointments.filter({
            var d: [String] = ($0.appointmentDate?.components(separatedBy: " "))!
            //   print(d[0])
            return  d[0] == date && (( $0.urgentappointment == "yes" && !urgentswitch.isOn && (($0.approved == "1" && approved)||($0.approved == "0" && !approved)))||($0.urgentappointment == "no" && urgentswitch.isOn))
            
        })
        print(fillterdappointments.count)
        if(fillterdappointments.count == 0){
            self.empty()
        }else{
            self.initilze()
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    
    func loadData(){
        print("load")
        self.view.endEditing(true)
        //loding()
        self.loding()
        
        
        guard let user =  Globals.user else{
            return
        }
        
        let uid = (user.user?.uid!)!
        print (uid)

        //http://shefaaonline.net/api-appointment?doctor_id=102
        let id = Globals.user!.user!.uid!
        let url = Globals.baseUrl + "/api-appointment?doctor_id=\(id)&sess_name=\(user.session_name!)&sess_id=\(user.sessid!)&token=\(user.token!)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        
        Alamofire.request(url).validate().responseJSON { response in
            print(response)
            switch (response.result) {
            case .success:
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let res = Appointment.modelsFromDictionaryArray(array: JSON as! NSArray)
                    self.appointments = res
                    //self.initilze()
                    // if self.doctors.count == 0{
                    //    self.empty()
                    // }
                    // self.loadSpex()
                    
                    self.filter()
                    
                }else{
                    //   self.error()
                    self.error()
                }
            case .failure:
                self.error()
                
                
            }
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Color.blue.darken2
        self.navigationController?.navigationBar.tintColor = .white
        prepareView()
        
        prepareRefreshBtn()
        //  prepareMenuButton()
        //  prepareNavigationItem()
    }
    
    
    @IBAction func urgentSwitchValueChanged(_ sender: UISwitch) {
        if urgentswitch.isOn == true{
            self.buttonsViewHeightConstraint.constant = 0
            
        }
        else{
            self.buttonsViewHeightConstraint.constant = 50
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (state) in
            
        })
        
        filter()
    }
    
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.image = menuButton.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
    }
    
    
    @objc
    fileprivate func handleMenuButton() {
        if(!UIApplication.isRTL()){
            navigationDrawerController?.toggleLeftView()
        }
        else{
            
            navigationDrawerController?.toggleRightView()
        }
    }
    
    fileprivate func prepareNavigationItem() {
        
        if(!UIApplication.isRTL()){
            navigationItem.leftViews = [menuButton]
        }
        else{
            navigationItem.rightViews = [menuButton]
        }
        
    }
    
    
    func prepareRefreshBtn(){
        
        let btn  = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(loadData))
        self.navigationItem.rightBarButtonItem = btn
    }
    
    
    
    func prepareView(){
        stateSegment.removeBorders()
        self.navigationController?.navigationBar.barTintColor = UIColor().mainColor()
        //let ratio = Double(self.view.width / 750)
        self.title =  NSLocalizedString("Appointments", comment: "")
        self.navigationItem.titleLabel.textColor = .white
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let nib = UINib(nibName: "AppointementCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.tableFooterView = UIView()
        self.prepareViewState()
        
    }
    
    deinit {
        print("\(#function)")
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        filter()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillterdappointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AppointementCell
        cell.appointment = fillterdappointments[indexPath.row]
        return cell
        
    }
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appointment = fillterdappointments[indexPath.row]
        
        let vc = UIStoryboard.viewController(identifier: "AppointmentDetails") as! Appointmentdetails
        vc.appointment = appointment
        vc.title = NSLocalizedString("Appointment Details", comment: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func approvedAppointments(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0){
            self.approved = true
        }else{
            self.approved = false
        }
        
        filter()
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
        _ = lodingView.anchor8(buttonsView, topattribute: .bottom, topConstant: 5, leftview: view, leftattribute: .leading, leftConstant: 0, bottomview: view, bottomattribute: .bottom, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //  lodingView.frame = tableView.frame
        
        emptyView.detailTextLabel.isHidden = true
        emptyView.textLabel.text = NSLocalizedString("No Appointments", comment: "")
        
        _ = wrongView.anchor8(buttonsView, topattribute: .bottom, topConstant: 5, leftview: view, leftattribute: .leading, leftConstant: 0, bottomview: view, bottomattribute: .bottom, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //    wrongView.frame = tableView.frame
        _ = emptyView.anchor8(buttonsView, topattribute: .bottom, topConstant: 5, leftview: view, leftattribute: .leading, leftConstant: 0, bottomview: view, bottomattribute: .bottom, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //emptyView.tapGestureRecognizer.addTarget(self, action: #selector(loadData))
        //emptyView.frame = tableView.frame
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
    
    
    
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        loadData()
    }
    
    
    
}

