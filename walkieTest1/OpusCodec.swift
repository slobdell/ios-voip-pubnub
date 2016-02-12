//
//  SpeexCodec.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/8/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

class OpusCodec:CodecProtocol {

    var opusEncoder:COpaquePointer
    var opusDecoder:COpaquePointer
    
    let inputFrequency = opus_int32(TinCanXConstants().voiceTransmissionHertz)
    var error = UnsafeMutablePointer<Int32>(bitPattern: 0)
    let channels:Int32 = 1
    let frameSize:opus_int32 = opus_int32(TinCanXConstants().voiceTransmissionHertz / (1000 / TinCanXConstants().voiceSampleMs))

    
    let forwardErrorCorrectionFlag:Int32 = 0
    
    
    init(){
        opusEncoder = opus_encoder_create(inputFrequency, channels, OPUS_APPLICATION_VOIP, error)
        opusDecoder = opus_decoder_create(inputFrequency, channels, error)
    }
    
    func encode(rawPCMValues:Array<Float>) -> Array<UInt8>? {
        let maxPossibleFrameSize = frameSize
        var writeToBuffer:Array<UInt8> = Array(count: Int(maxPossibleFrameSize), repeatedValue: 0)
        
        let bytesWrriten = opus_encode_float(opusEncoder, UnsafeMutablePointer<Float>(rawPCMValues), frameSize, UnsafeMutablePointer<UInt8>(writeToBuffer), maxPossibleFrameSize)
        
        var finalBytes:Array<UInt8> = Array(count: Int(bytesWrriten), repeatedValue: 0)
        if(bytesWrriten == -1){
            //There was an error
            return nil
        } else if (bytesWrriten == 1){
            // packet does not need to be transmitted
            return nil
        }
        memcpy(UnsafeMutablePointer<UInt8>(finalBytes), UnsafeMutablePointer<UInt8>(writeToBuffer), Int(bytesWrriten))
        return finalBytes
    }
    
    func decode(encodedBytes:Array<UInt8>) -> Array<Float>{
        let encodedByteCount = opus_int32(encodedBytes.count)
        var decodedPCMValues:Array<Float> = Array(count: 320, repeatedValue: 0.0)
        let bytesWritten = opus_decode_float(opusDecoder, UnsafePointer<UInt8>(encodedBytes), encodedByteCount, UnsafeMutablePointer<Float>(decodedPCMValues), frameSize, forwardErrorCorrectionFlag)
        return decodedPCMValues
    }
}