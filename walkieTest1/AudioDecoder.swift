//
//  AudioDecoder.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/7/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

class AudioDecoder {
    let codec:CodecProtocol = OpusCodec()

    init(){

    }

    func stringToByteValues(data: String) -> Array<UInt8>{
        var byteArray: Array<UInt8> = Array(count: count(data), repeatedValue: 0)

        for (index, singleChar) in enumerate(data.unicodeScalars){
            if(index == count(data)){
                println("total hack right now, but this happens sometimes")
                break
            }
            byteArray[index] = UInt8(singleChar.value)
        }


        return byteArray
    }

    func decodePacketFromString(voicePacket:String) -> Array<Float>{
        return self.decodeForCodec(voicePacket)
        /*
        let floatSizeBytes = 4
        let convertedPacketSize = count(voicePacket) / floatSizeBytes
        var decodedPCMValues:Array<Float> = Array(count: convertedPacketSize, repeatedValue: 0.0)

        let byteValues:Array<UInt8> = self.stringToByteValues(voicePacket)

        let bytePointer = UnsafeMutablePointer<UInt8>(byteValues)
        memcpy(&decodedPCMValues, bytePointer, byteValues.count)
        return decodedPCMValues
        */
    }


    func decodeForCodec(voicePacket:String) ->Array<Float>{
        let byteArray = self.stringToByteValues(voicePacket)
        return codec.decode(byteArray)

    }


}
