//
//  MessageFactory.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/9/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

class MessageFactory{
    static let typeKey = "t"
    static let classIdToFactory = [
        VoicePacket.typeId: VoicePacket.deserialize
    ]
    /*
    class func createFromString(serializedInstance: String) -> MessageProtocol{
        let jsonString = serializedInstance
        let data:NSData? = (jsonString as NSString).dataUsingEncoding(NSASCIIStringEncoding)
        let decodedJson = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! Dictionary<String, AnyObject>
        
        let typeId = decodedJson[MessageFactory.typeKey] as! Int
        let deserializeFunc = MessageFactory.classIdToFactory[typeId]
        
        return deserializeFunc!(decodedJson)
    }
*/
    
    class func createFromDict(decodedJson: NSDictionary) -> MessageProtocol{
        let typeId = decodedJson[MessageFactory.typeKey] as! Int
        let deserializeFunc = MessageFactory.classIdToFactory[typeId]
        return deserializeFunc!(decodedJson)
    }

}
