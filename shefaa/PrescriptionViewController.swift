//
//  PrescriptionViewController.swift
//  shefaa
//
//  Created by Nour  on 8/17/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class PrescriptionViewController: UITableViewController{

    
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var DateLbl: UILabel!
    
    
    var prescription:Prescription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  let prescription = prescription  {
            if let name = prescription.author_Name {
                doctorNameLbl.text = name
                
            }else{
                doctorNameLbl.text = "N/A"
                
            }
            
            if let date = prescription.prec_date {
                DateLbl.text = date
            }else{
                DateLbl.text = ""
            }

        }else{
            doctorNameLbl.text = ""
            DateLbl.text = ""
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func showTests(_ sender: UIButton) {
        
        let vc =  UIStoryboard.viewController(identifier: "TestsViewController") as! TestsViewController
        vc.tests = prescription?.testsneeded
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    @IBAction func showDiagnosis(_ sender: UIButton) {
        
        let vc = UIStoryboard.viewController(identifier: "DiagnosisViewController") as! DiagnosisViewController
        if let diagnosis = prescription?.diagnosis_of_disease {
            vc.diagnosis = diagnosis
        
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func showMedicines(_ sender: UIButton) {
        
        
        let vc = MedicineViewController()
        if let id = prescription?.nid {
            vc.id = id
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
