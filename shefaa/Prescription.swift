/*
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Prescription {
    public var patient_Name : String?
    public var nid : String?
    public var author_Name : String?
    public var author_id : String?
    public var prec_date : String?
    public var diagnosis_of_disease : Array<String>?
    public var title : String?
    public var patientID : String?
    public var testsneeded : Array<String>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Prescription]
    {
        var models:[Prescription] = []
        for item in array
        {
            models.append(Prescription(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

        patient_Name = dictionary["Patient_Name"] as? String
        nid = dictionary["nid"] as? String
        author_Name = dictionary["Author_Name"] as? String
        author_id = dictionary["Author_id"] as? String
        if (dictionary["Diagnosis_of_disease"] != nil) {
            diagnosis_of_disease = dictionary["Diagnosis_of_disease"] as? Array<String>
        }

        title = dictionary["title"] as? String
        patientID = dictionary["Patient ID"] as? String
       
        if (dictionary["Tests needed"] != nil) {
            testsneeded = dictionary["Tests needed"] as? Array<String>
        }
        prec_date = dictionary["prec_date"] as? String
        
        
//        patient_Name = dictionary["Patient_Name"] as? String
//        nid = dictionary["nid"] as? Int
//        author_Name = dictionary["Author_Name"] as? String
//        author_id = dictionary["Author_id"] as? Int
//        
//        if (dictionary["Diagnosis_of_disease"] != nil) { diagnosis_of_disease = Diagnosis_of_disease.modelsFromDictionaryArray(dictionary["Diagnosis_of_disease"] as! NSArray) }
//        title = dictionary["title"] as? String
//        patient ID = dictionary["Patient ID"] as? Int
//        if (dictionary["Tests needed"] != nil) { tests needed = Tests needed.modelsFromDictionaryArray(dictionary["Tests needed"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

        dictionary.setValue(self.patient_Name, forKey: "Patient_Name")
        dictionary.setValue(self.nid, forKey: "nid")
        dictionary.setValue(self.author_Name, forKey: "Author_Name")
        dictionary.setValue(self.author_id, forKey: "Author_id")
        //dictionary.setValue(self.diagnosis_of_disease, forKey: "Diagnosis_of_disease")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.patientID, forKey: "Patient ID")

		return dictionary
	}

}
