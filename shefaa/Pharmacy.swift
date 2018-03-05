/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Pharmacy {
	public var pharmatics_Name : String?
    public var profile_users_1_pid : String?
    public var nothing : String?
	public var rate : Rate?
	public var pharmacy_open_hours : Array<Clinic_open_hours>?
	public var city : String?
	public var country : String?
	public var latitude : String?
	public var longitude : String?
	public var street : String?
	public var pharmacy_name : String?
	public var medicine_name : String?
	public var distanceProximity : String?
    public var uid : String?
    public var picture : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Pharmacy_list = Pharmacy.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Pharmacy Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Pharmacy]
    {
        var models:[Pharmacy] = []
        for item in array
        {
            models.append(Pharmacy(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Pharmacy = Pharmacy(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Pharmacy Instance.
*/
	required public init?(dictionary: NSDictionary) {

		pharmatics_Name = dictionary["Pharmatics_Name"] as? String
        if dictionary["Rate"] is NSDictionary {
            if let _ = dictionary["Rate"] { rate = Rate(dictionary: dictionary["Rate"] as! NSDictionary)
            }
        }
//        if dictionary["Pharmacy_open_hours"] is NSDictionary {
//                if let _ = dictionary["Pharmacy_open_hours"]{ pharmacy_open_hours = Clinic_open_hours.modelsFromDictionaryArray(array: dictionary["Pharmacy_open_hours"] as! NSArray)
//            }
//            
//        }
        
        	if (dictionary["Pharmacy_open_hours"] != nil) { pharmacy_open_hours = Clinic_open_hours.modelsFromDictionaryArray(array: dictionary["Pharmacy_open_hours"] as! NSArray) }
		city = dictionary["City"] as? String
		country = dictionary["Country"] as? String
		latitude = dictionary["Latitude"] as? String
		longitude = dictionary["Longitude"] as? String
		street = dictionary["Street"] as? String
		pharmacy_name = dictionary["Pharmacy_name"] as? String
		medicine_name = dictionary["Medicine_name"] as? String
		distanceProximity = dictionary["Distance / Proximity"] as? String
        profile_users_1_pid = dictionary["profile_users_1_pid"] as? String
        nothing = dictionary["nothing"] as? String
        uid = dictionary["Uid"] as? String
        
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
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.pharmatics_Name, forKey: "Pharmatics_Name")
		dictionary.setValue(self.rate?.dictionaryRepresentation(), forKey: "Rate")
		dictionary.setValue(self.city, forKey: "City")
		dictionary.setValue(self.country, forKey: "Country")
		dictionary.setValue(self.latitude, forKey: "Latitude")
		dictionary.setValue(self.longitude, forKey: "Longitude")
		dictionary.setValue(self.street, forKey: "Street")
		dictionary.setValue(self.pharmacy_name, forKey: "Pharmacy_name")
		dictionary.setValue(self.medicine_name, forKey: "Medicine_name")
		dictionary.setValue(self.distanceProximity, forKey: "Distance / Proximity")

		return dictionary
	}

}
