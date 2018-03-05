/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Doctor {
	public var doctor_id : String?
	public var doctor_specialization : Array<String>?
    public var profile_users_1_pid : String?
    public var nothing : String?
	public var cost : String?
	public var rate : Rate?
	public var city : String?
	public var country : String?
	public var latitude : String?
	public var longitude : String?
	public var street : String?
	public var clinic_open_hours : [Clinic_open_hours]?
	public var name : String?
	public var locationname : String?
    public var picture : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Doctor_list = Doctor.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Doctor Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Doctor]
    {
        var models:[Doctor] = []
        for item in array
        {
            models.append(Doctor(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Doctor = Doctor(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Doctor Instance.
*/
	required public init?(dictionary: NSDictionary) {

		doctor_id = dictionary["Doctor_id"] as? String
		if (dictionary["Doctor_specialization"] != nil) {
            doctor_specialization = dictionary["Doctor_specialization"] as? Array<String>
        }
        profile_users_1_pid = dictionary["profile_users_1_pid"] as? String
        nothing = dictionary["nothing"] as? String
		cost = dictionary["Cost"] as? String
		if (dictionary["Rate"] != nil) { rate = Rate(dictionary: dictionary["Rate"] as! NSDictionary) }
		city = dictionary["City"] as? String
		country = dictionary["Country"] as? String
		latitude = dictionary["Latitude"] as? String
		longitude = dictionary["Longitude"] as? String
		street = dictionary["Street"] as? String
		if (dictionary["Clinic_open_hours"] != nil) {
        clinic_open_hours = Clinic_open_hours.modelsFromDictionaryArray(array: dictionary["Clinic_open_hours"] as! NSArray)
        }else{
        
            clinic_open_hours = []
        }
		name = dictionary["name"] as? String
		locationname = dictionary["Location name"] as? String
        picture = dictionary["Picture"] as? String
        
        
        if let sub = picture {
        let prefix = "http"
        let suffix = "?itok"
        var pre = ""
        var suf = ""
            if sub.characters.count > 0 {
                if let lower = sub.range(of: prefix)?.lowerBound {
                
                    pre = sub.substring(from: lower)
                    print("from \(pre)")
                }
                
                if let lower = pre.range(of: suffix)?.lowerBound {
                
                    suf = pre.substring(to: lower)
                    print("to \(suf)")
                    picture = suf
                }
                print("final \(picture)")
                
                
            }
   
        }
        ///  "<div class=\"user-picture\">\n    <img src=\"http://shefaaonline.net/sites/default/files/styles/thumbnail/public/pictures/picture-2-1504089632.png?itok=7bfZbQIq\" alt=\"manager&#039;s picture\" title=\"manager&#039;s picture\" />  </div>";
     
        
        
        //"<div class=\"user-picture\">\n    <img src=\"http://shefaaonline.net/sites/default/files/styles/thumbnail/public/pictures/picture-64-1493884233.png?itok=ZP6PutCE\" alt=\"\U0623\U062d\U0645\U062f \U0627\U0644\U0645\U0646\U0635\U0648\U0631&#039;s picture\" title=\"\U0623\U062d\U0645\U062f \U0627\U0644\U0645\U0646\U0635\U0648\U0631&#039;s picture\" />  </div>";
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.doctor_id, forKey: "Doctor_id")
		dictionary.setValue(self.cost, forKey: "Cost")
		dictionary.setValue(self.rate?.dictionaryRepresentation(), forKey: "Rate")
		dictionary.setValue(self.city, forKey: "City")
		dictionary.setValue(self.country, forKey: "Country")
		dictionary.setValue(self.latitude, forKey: "Latitude")
		dictionary.setValue(self.longitude, forKey: "Longitude")
		dictionary.setValue(self.street, forKey: "Street")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.locationname, forKey: "Location name")
        dictionary.setValue(self.picture, forKey: "Picture")

		return dictionary
	}

}
