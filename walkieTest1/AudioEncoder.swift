//
//  AudioEncoder.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/7/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

class AudioEncoder {
    let codec:CodecProtocol = OpusCodec()

    init(){

    }

    func toByteArray<T>(var value: T) -> [UInt8] {
        return withUnsafePointer(&value) {
            Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>($0), count: sizeof(T)))
        }
    }

    func byteToChar(byteValue: UInt8) -> Character{
        return Character(UnicodeScalar(byteValue))
    }

    func encodePacketToString(floatArray:Array<Float>) -> String{

        let codecBytes:Array<UInt8>? = self.encodeToCodec(floatArray)

        if(codecBytes == nil){
            return ""
        }

        let data = NSData(bytes: UnsafeMutablePointer<UInt8>(codecBytes!), length: codecBytes!.count)
        let str = NSString(data: data, encoding: NSASCIIStringEncoding)
        return String(str!)

    }
    func encodeToCodec(floatArray:Array<Float>) -> Array<UInt8>? {
        return codec.encode(floatArray)
    }


}
