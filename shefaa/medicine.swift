/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class medicine {
	public var pharmacist_id : String?
	public var pharmacist_Name : String?
	public var pharmacy_name : String?
	public var batch_ID : String?
	public var medicine_name : String?
	public var medicine_details : String?
	public var amount : String?
	public var remainingamount : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let medicine_list = medicine.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of medicine Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [medicine]
    {
        var models:[medicine] = []
        for item in array
        {
            models.append(medicine(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let medicine = medicine(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: medicine Instance.
*/
	required public init?(dictionary: NSDictionary) {

		pharmacist_id = dictionary["Pharmacist_id"] as? String
		pharmacist_Name = dictionary["Pharmacist_Name"] as? String
		pharmacy_name = dictionary["Pharmacy_name"] as? String
		batch_ID = dictionary["Batch_ID"] as? String
		medicine_name = dictionary["Medicine_name"] as? String
		medicine_details = dictionary["Medicine_details"] as? String
		amount = dictionary["Received Amount"] as? String
		remainingamount = dictionary["Remaining amount"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.pharmacist_id, forKey: "Pharmacist_id")
		dictionary.setValue(self.pharmacist_Name, forKey: "Pharmacist_Name")
		dictionary.setValue(self.pharmacy_name, forKey: "Pharmacy_name")
		dictionary.setValue(self.batch_ID, forKey: "Batch_ID")
		dictionary.setValue(self.medicine_name, forKey: "Medicine_name")
		dictionary.setValue(self.medicine_details, forKey: "Medicine_details")
		dictionary.setValue(self.amount, forKey: "Amount")
		dictionary.setValue(self.remainingamount, forKey: "Remaining amount")

		return dictionary
	}

}
