//
//  VoicePacket.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/9/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

class VoicePacket:MessageProtocol {
    
    static var typeId:Int = 1
    
    var packetDict:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    static let dataKey = "d"
    static let orderKey = "o"
    static let typeKey = "t" // maybe move this into a superclass or something
    static let timeKey = "s"
 
    var encodedAudioString:String
    var order:Int
    var timestampMsCreated:Int64
    
    init(voicePacket:String, order: Int, timestampMsCreated: Int64){
        encodedAudioString = voicePacket
        self.order = order
        self.timestampMsCreated = timestampMsCreated
        packetDict[VoicePacket.dataKey] = self.b64encode(encodedAudioString)
        packetDict[VoicePacket.orderKey] = self.order
        packetDict[VoicePacket.typeKey] = VoicePacket.typeId
        packetDict[VoicePacket.timeKey] = NSNumber(longLong:self.timestampMsCreated)

    }

    
    func serialize() -> String{
        let jsonData = NSJSONSerialization.dataWithJSONObject(
            packetDict ,
            options: NSJSONWritingOptions(0),
            error: nil)
        let jsonText = NSString(data: jsonData!, encoding: NSASCIIStringEncoding)
        return String(jsonText!)
    }
    
    class func deserialize(decodedJson:NSDictionary) -> MessageProtocol{
        let b64EncodedString: String = decodedJson[VoicePacket.dataKey] as! String
        let voicePacket:String = VoicePacket.b64decode(b64EncodedString)
        let order:Int = decodedJson[VoicePacket.orderKey] as! Int

        let timestampMsCreated:Int64 = (decodedJson[VoicePacket.timeKey] as! NSNumber).longLongValue
        return VoicePacket(voicePacket: voicePacket, order: order, timestampMsCreated: timestampMsCreated)
    }
    
    func b64encode(string:String) -> String{
        let utf8str = string.dataUsingEncoding(NSUTF8StringEncoding)
        let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64Encoded!
        
    }
    
    class func b64decode(base64Encoded: String) -> String{
        let base64Decoded = NSData(base64EncodedString: base64Encoded, options:   NSDataBase64DecodingOptions(rawValue: 0))
            .map({ NSString(data: $0, encoding: NSUTF8StringEncoding) })
        return base64Decoded as! String
        
    }
}