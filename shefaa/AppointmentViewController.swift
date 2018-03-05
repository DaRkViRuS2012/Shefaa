//
//  AppointmentViewController.swift
//  shefaa
//
//  Created by Nour  on 4/16/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire
import SwiftyJSON
import Material
import SCLAlertView
class AppointmentViewController: UIViewController,CVCalendarMenuViewDelegate,CVCalendarViewDelegate{

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var urgentswitch: UISwitch!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let cellId = "CellId"
    
    
    let progressHUD = ProgressHUD(text: "")
    
    var selecteddate = ""
    var time = ""
    var doctor:Doctor?
    var times  = Array<String>()
    
    struct Colors {
        static let selectedText = UIColor.white
        static let text = UIColor.black
        static let textDisabled = UIColor.gray
        static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
        static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
        static let sundaySelectionBackground = sundayText
    }
    
   // var menuView:CVCalendarMenuView!
    //var calendarView:CVCalendarView!
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    var selectedDay:DayView!
    
    var currentCalendar: Calendar?
    
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .saturday
    }
    
    override func awakeFromNib() {
        _ = 480 // (UTC+08:00)
        currentCalendar = Calendar.init(identifier: .gregorian)
        
    }
    
    
    
    
    func prepareCalendar(){
        
      
        
        // Appearance delegate [Unnecessary]
        self.calendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self
        
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
       // calendarView.toggleViewWithDate(Date())
    //    selectedDay.date = calendarView.presentedDate
        
        
       
    }

    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return .blue
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return true
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
        changeDate()
        //loadData()
    }
    
    func changeDate(){

        let date = selectedDay.date
        let year  = "\(date!.year)"
        let month = (date!.month < 10) ? "0\(date!.month)" : "\(date!.month)"
        let day = (date!.day < 10) ? "0\(date!.day)" : "\(date!.day)"
        selecteddate = "\(year)-\(month)-\(day)"
        print(selecteddate)
        self.title = selecteddate
        loadData()
    }

    var days:[Clinic_open_hours]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("New Appointment", comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor().mainColor()
        self.navigationItem.titleLabel.textColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.loadingView.isHidden = true
        self.emptyView.isHidden = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        //prepareCalendar()
        
        self.view.addSubview(progressHUD)
        
        _ = progressHUD.anchor(view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
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
    
    
    
    func loadData(){
        if let day = selectedDay{
        if let date = day.date{
        loadingView.isHidden = false
        emptyView.isHidden = true
        tableView.isHidden = true
        doneBtn.isEnabled = false
        let year  = "\(date.year)"
        let month = (date.month < 10) ? "0\(date.month)" : "\(date.month)"
        let day = (date.day < 10) ? "0\(date.day)" : "\(date.day)"
        selecteddate = "\(year)-\(month)-\(day)"
        let id = (doctor?.doctor_id)!
        let url = Globals.baseUrl + "/get-available-times?doctor_id=\(id)&date=\(selecteddate)"
        print(url)
        Alamofire.request(url).responseJSON { response in
           print(response.request)
           print(response.response)
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                self.loadingView.isHidden = true
                self.tableView.isHidden = false
                 self.times = (Times(dictionary: JSON as! NSDictionary)?.availableTimes)!
                self.times = self.times.filter({$0 != "booked"})
                if self.times.count == 0{
                    self.emptyView.isHidden = false
                     self.doneBtn.isSelected = false
                }
                
                 self.tableView.reloadData()
            }else{
                    self.tableView.isHidden = true
                    self.loadingView.isHidden = true
                    self.emptyView.isHidden = false
              self.doneBtn.isSelected = false
            }
        }
        }
        }
    
    }
  
    
    @IBAction func regularAppointment(_ sender: UIButton) {
        
        
        makeAppointment(date: selecteddate, time: time,reasone:"", urgent: 0)
        
        
    }
    
    
    func handelUrgentAppointment(){
    
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4 * 360)
        let picker = DateTimePicker.show(minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = NSLocalizedString("Done", comment: "")
        picker.todayButtonTitle = NSLocalizedString("Today", comment: "")
        picker.is12HourFormat = false
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //   picker.isDatePickerOnly = true
         picker.cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.locale =   Locale(identifier: "en_US")
            let date1  = formatter.string(from: date)
            print(date1)
            //self.item.title = formatter.string(from: date)
            formatter.dateFormat = "HH:MM"
            let time = formatter.string(from: date)
            print(time)
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 10)!,
                showCloseButton: false
                
            )
            
            
            let alert = SCLAlertView(appearance: appearance)
            let txt = alert.addTextField(NSLocalizedString("Urgent appointment reasone", comment: ""))
            txt.keyboardType = .numberPad
            alert.addButton(NSLocalizedString("OK", comment: "") ) {
                print("Text value: \(txt.text)")
                if  let value = txt.text {
                    self.makeAppointment(date: date1, time: time,reasone: value, urgent: 1)
                }
            }
            alert.addButton(NSLocalizedString("Cancel", comment: "")){}
            //alert.showEdit("", subTitle: NSLocalizedString("Change amount", comment: ""))
            alert.showEdit("", subTitle: NSLocalizedString("Urgent appointment reasone", comment: ""), closeButtonTitle: NSLocalizedString("Camcel", comment: ""), duration: 0, colorStyle: 0x54BEC0, colorTextButton: 0xffffff, circleIconImage: nil, animationStyle: .noAnimation)
           
    
        }
    
    }
    
    
    @IBAction func urgentAppoitment(_ sender: UISwitch) {
        
        if urgentswitch.isOn{
            
      showTerms()
            

            urgentswitch.isOn = false
            
            
            
        }
        
    }
    

    
    func showTerms(){
        
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 12)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 10)!,
            showCloseButton: false
            
        )
        
       let alert =  SCLAlertView(appearance: appearance)
        alert.addButton(NSLocalizedString("OK", comment: ""), action: {
            self.handelUrgentAppointment()
        })
        
        alert.showInfo(NSLocalizedString("Whay choose urgent appointment?", comment: ""), subTitle: NSLocalizedString("This option is used only in emergencies We will notify you if this appointment is approved If it is not necessary you can book a regular appointment at the doctor's available times", comment: ""), closeButtonTitle: "", duration: 0, colorStyle: 0x54BEC0, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .noAnimation)
    
    }
    
    func showAlert(){
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 10)!,
            showCloseButton: false
            
        )
        
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField(NSLocalizedString("Urgent appointment reasone", comment: ""))
        txt.keyboardType = .numberPad
        alert.addButton(NSLocalizedString("Save", comment: "") ) {
            print("Text value: \(txt.text)")
            if  let value = Int(txt.text!) {
                
            }
        }
        alert.addButton(NSLocalizedString("Cancel", comment: "")){}
        //alert.showEdit("", subTitle: NSLocalizedString("Change amount", comment: ""))
        alert.showEdit("", subTitle: NSLocalizedString("Change amount", comment: ""), closeButtonTitle: NSLocalizedString("Camcel", comment: ""), duration: 0, colorStyle: 0x54BEC0, colorTextButton: 0xffffff, circleIconImage: nil, animationStyle: .noAnimation)
    
    
    }
    
    func makeAppointment(date:String,time:String,reasone:String,urgent:Int){
        
        progressHUD.show()
        let url = Globals.baseUrl + "/validate-book-appointment?doctor_id=\(doctor!.doctor_id!)&patient_id=\(Globals.user!.user!.uid!)&date=\(date)&time=\(time)&urgent=\(urgent)&urgent_cause=\(reasone)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            print(response)
            self.progressHUD.hide()
            switch response.result{
            case .success:
        
            if let data = response.result.value {
                print("JSON: \(data)")
                let dic = data as! NSDictionary
                if let status = dic["Book-statue"] as? String{
                    
                    self.showAlert(title: "", msg:NSLocalizedString(status, comment: "") ,style:.success)
                    
                    self.loadData()
                }
            }else{
                self.showAlert(title: NSLocalizedString("No Internet", comment: ""), msg: NSLocalizedString("check your connection and try again", comment: ""),style:.warning)
                }
            case .failure:
                  self.showAlert(title: NSLocalizedString("No Internet", comment: ""), msg: NSLocalizedString("check your connection and try again", comment: ""),style:.warning)
            }
        }
    }
    
    
  
}



extension AppointmentViewController:UITableViewDelegate,UITableViewDataSource{


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = times[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        time = times[indexPath.row]
        doneBtn.isEnabled = true
    }

}
