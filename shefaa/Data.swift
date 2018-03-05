/*
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Data {
	public var uid : String?
	public var name : String?
	public var mail : String?
	public var theme : String?
	public var signature : String?
	public var signature_format : String?
	public var created : String?
	public var access : String?
	public var login : String?
	public var status : String?
	public var timezone : String?
	public var language : String?
	public var picture : String?
	public var data : Data?
	public var uuid : String?
	public var roles : Roles?
	public var locations : Array<String>?
	public var location : Array<String>?
	public var privatemsg_disabled : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let user_list = User.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of User Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Data]
    {
        var models:[Data] = []
        for item in array
        {
            models.append(Data(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let user = User(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: User Instance.
*/
	required public init?(dictionary: NSDictionary) {

		uid = dictionary["uid"] as? String
		name = dictionary["name"] as? String
		mail = dictionary["mail"] as? String
		theme = dictionary["theme"] as? String
		signature = dictionary["signature"] as? String
		signature_format = dictionary["signature_format"] as? String
		created = dictionary["created"] as? String
		access = dictionary["access"] as? String
		login = dictionary["login"] as? String
		status = dictionary["status"] as? String
		timezone = dictionary["timezone"] as? String
		language = dictionary["language"] as? String
		picture = dictionary["picture"] as? String
		privatemsg_disabled = dictionary["privatemsg_disabled"] as? String
       if (dictionary["roles"] != nil) { roles = Roles(dictionary: dictionary["roles"] as! NSDictionary) }
    
    }

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.uid, forKey: "uid")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.mail, forKey: "mail")
		dictionary.setValue(self.theme, forKey: "theme")
		dictionary.setValue(self.signature, forKey: "signature")
		dictionary.setValue(self.signature_format, forKey: "signature_format")
		dictionary.setValue(self.created, forKey: "created")
		dictionary.setValue(self.access, forKey: "access")
		dictionary.setValue(self.login, forKey: "login")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.timezone, forKey: "timezone")
		dictionary.setValue(self.language, forKey: "language")
		dictionary.setValue(self.picture, forKey: "picture")
		dictionary.setValue(self.uuid, forKey: "uuid")
		dictionary.setValue(self.roles?.dictionaryRepresentation(), forKey: "roles")
		dictionary.setValue(self.privatemsg_disabled, forKey: "privatemsg_disabled")

		return dictionary
	}

}
