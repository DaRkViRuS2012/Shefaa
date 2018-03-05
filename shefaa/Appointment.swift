/*
 Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Appointment {
    public var nid : String?
    public var approved : String?
    public var title : String?
    public var doctorID : DoctorID?
    public var patientName : String?
    public var patientID : PatientID?
    public var appointmentDate : String?
    public var urgentappointment : String?
    public var appointmentstarttime : String?
    public var urgentappointmentcause : Urgentappointmentcause?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Appointment_list = Appointment.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Appointment Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Appointment]
    {
        var models:[Appointment] = []
        for item in array
        {
            models.append(Appointment(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let Appointment = Appointment(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Appointment Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        nid = dictionary["nid"] as? String
        approved = dictionary["Approved"] as? String
        title = dictionary["title"] as? String
        if (dictionary["Doctor ID"] != nil) { doctorID = DoctorID(dictionary: dictionary["Doctor ID"] as! NSDictionary) }
        patientName = dictionary["Patient Name"] as? String
        if (dictionary["Patient ID"] != nil) { patientID = PatientID(dictionary: dictionary["Patient ID"] as! NSDictionary) }
        appointmentDate = dictionary["Appointment Date"] as? String
        urgentappointment = dictionary["urgent appointment"] as? String
        appointmentstarttime = dictionary["Appointment start time"] as? String
        if dictionary["Urgent appointment cause"] is NSDictionary {
            if let _ = dictionary["Urgent appointment cause"] { urgentappointmentcause = Urgentappointmentcause(dictionary: dictionary["Urgent appointment cause"] as! NSDictionary)
            }
        }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.nid, forKey: "nid")
        dictionary.setValue(self.approved, forKey: "Approved")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.doctorID?.dictionaryRepresentation(), forKey: "Doctor ID")
        dictionary.setValue(self.patientName, forKey: "Patient Name")
        dictionary.setValue(self.patientID?.dictionaryRepresentation(), forKey: "Patient ID")
        dictionary.setValue(self.appointmentDate, forKey: "Appointment Date")
        dictionary.setValue(self.urgentappointment, forKey: "urgent appointment")
        dictionary.setValue(self.appointmentstarttime, forKey: "Appointment start time")
        dictionary.setValue(self.urgentappointmentcause?.dictionaryRepresentation(), forKey: "Urgent appointment cause")
        
        return dictionary
    }
    
}
