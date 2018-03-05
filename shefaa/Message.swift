/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Message {
	public var mid : String?
	public var author : Author?
	public var subject : String?
	public var body : String?
	public var timestamp : String?
	public var is_new : String?
	public var thread_id : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Message_list = Message.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Message Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Message]
    {
        var models:[Message] = []
        for item in array
        {
            models.append(Message(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Message = Message(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Message Instance.
*/
	required public init?(dictionary: NSDictionary) {

		mid = dictionary["mid"] as? String
		if (dictionary["author"] != nil) { author = Author(dictionary: dictionary["author"] as! NSDictionary) }
		subject = dictionary["subject"] as? String
		body = dictionary["body"] as? String
		timestamp = dictionary["timestamp"] as? String
		is_new = dictionary["is_new"] as? String
		thread_id = dictionary["thread_id"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.mid, forKey: "mid")
		dictionary.setValue(self.author?.dictionaryRepresentation(), forKey: "author")
		dictionary.setValue(self.subject, forKey: "subject")
		dictionary.setValue(self.body, forKey: "body")
		dictionary.setValue(self.timestamp, forKey: "timestamp")
		dictionary.setValue(self.is_new, forKey: "is_new")
		dictionary.setValue(self.thread_id, forKey: "thread_id")

		return dictionary
	}

}
