
//
//  Appointmentdetails.swift
//  shefaa
//
//  Created by Nour  on 7/25/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Alamofire
import Material
import SCLAlertView
class Appointmentdetails: UITableViewController{

    
    var appointment:Appointment?
    let progressHUD = ProgressHUD(text: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Details", comment: "")
        self.navigationItem.titleLabel.textColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor().mainColor()
        
        let nib = UINib(nibName: "typecell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        
        
        
        let updatebtn = UIBarButtonItem(image: UIImage(named:"pen")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(updateTime))
        
        let approveBtn = UIBarButtonItem(image: Icon.cm.check, style: .plain, target: self, action: #selector(approve))
//        approveBtn.setImage(Icon.cm.check, for: .normal)
//        approveBtn.addTarget(self, action: #selector(approve), for: .touchUpInside)
//        
        
        
        var btns:[UIBarButtonItem] = []
        
        
        btns.append(updatebtn)
        
        if appointment?.approved == "0" && appointment?.urgentappointment == "yes"{
            btns.append(approveBtn)
        }
        
        self.navigationItem.rightBarButtonItems = btns
        
        self.tableView.addSubview(progressHUD)
        
        progressHUD.frame = tableView.frame
        
        progressHUD.hide()
    }

    func updateTime(){
    
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 365)
        let picker = DateTimePicker.show(minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = NSLocalizedString("Done", comment: "")
        picker.todayButtonTitle = NSLocalizedString("Today", comment: "")
        picker.cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        picker.is12HourFormat = false
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //   picker.isDatePickerOnly = true
        
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
            self.updateAppointment(date:date1,time:time)
        }

    }
    
    func updateAppointment(date:String,time:String){
        ///api-update-appointment?nid=172&date=2017-05-31&time=11:00
    
        progressHUD.show()
        guard let id = appointment?.nid else{
            return
        }
        let url = Globals.baseUrl + "/api-update-appointment?nid=\(id)&date=\(date)&time=\(time)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        Alamofire.request(url).responseJSON { response in
            print(response.response)
            self.progressHUD.hide()
            switch response.result{
            case .success:
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.showAlert(title: "", msg:NSLocalizedString("Appointment time changed successfully", comment: "") ,style:.success)
                }
                break
            case .failure(let error):
                self.showAlert(title: "", msg: NSLocalizedString("Appointment time did not changed", comment: ""),style:.error)
                print(error)
                break
            }
        }
        
        
    }
    
    
    func showAlert(title:String,msg:String,style:SCLAlertViewStyle){
        
        SCLAlertView().showTitle(
            title, // Title of view
            subTitle: NSLocalizedString(msg, comment: ""), // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: NSLocalizedString("OK", comment: ""), // Optional button value, default: ""
            style: style, // Styles - see below.
            colorStyle: 0x54BEC0,
            colorTextButton: 0xFFFFFF
        )
        
    }
    
    
    func approve(){
        
        progressHUD.show()
        guard let id = appointment?.nid else{
            return
        }
        
        
        guard let user = Globals.user else{
            return
        }
        
        guard let uid = user.user?.uid else{
        
            return
        }
        
        let url = Globals.baseUrl + "/api-approve-appointment?nid=\(id)&uid=\(uid)&sess_name=\(user.session_name!)&sess_id=\(user.sessid!)&token=\(user.token!)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        	
        Alamofire.request(url).responseJSON { response in
            print(response.result)
            self.progressHUD.hide()
//            switch response.result{
//            case .success:
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let dic = JSON as! NSDictionary
                    let msg = dic["message"] as! String
                    self.showAlert(title: "",  msg: msg ,style:.success)
                }else{
//                break
//            case .failure(let error):
                self.showAlert(title: "", msg: NSLocalizedString("check your connection and try again", comment: ""),style:.warning)
             //   print(error)
//                break
            }
        
        }

    
    
    }
    
        // MARK: - Table view data source

   override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

   override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if ( appointment?.urgentappointment == "yes"){
        return 5
    
    }else{
    return 3
    }
    }

    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! typecell
        if(indexPath.row==0){
        cell.title.text =  NSLocalizedString("Appointment ID:", comment: "") 
        cell.subtitle.text = appointment?.nid!
        }
        if(indexPath.row==1){
            cell.title.text = NSLocalizedString("Time", comment: "")
            cell.subtitle.text = appointment?.appointmentstarttime!
        }
        
        if(indexPath.row==2){
            cell.title.text = NSLocalizedString("Patient Name:", comment: "")
            cell.subtitle.text = appointment?.patientName!
        }
        
        if(indexPath.row==3){
            cell.title.text = NSLocalizedString("Urgent appointment cause:", comment: "")
            if let cuz = appointment?.urgentappointmentcause?.value{
                cell.subtitle.text = cuz
            }
        }
        
        if(indexPath.row==4){
            cell.title.text = NSLocalizedString("Appointment Status:", comment: "")
            if(appointment?.approved == "1"){
                cell.subtitle.text =  NSLocalizedString("Approved", comment: "")
            }else{
            cell.subtitle.text = NSLocalizedString("Not approved", comment: "")
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func AppointmentApprove(){
    
        guard let nid = appointment?.nid else{
            return
        }
        
        guard let user  = Globals.user else{
            return
        }
        
        guard let uid = user.user?.uid else{
            return
        }
        
        progressHUD.show()
        let url = Globals.baseUrl + "/api-approve-appointment?nid=\(nid)&uid=\(uid)&sess_name=\(user.session_name!)&sess_id=\(user.sessid!)&token=\(user.token!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            print(response.response)
            self.progressHUD.hide()
            switch response.result{
            case .success:
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                  //  self.navigationController?.popViewController(animated: true)
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }

    
    }
}
