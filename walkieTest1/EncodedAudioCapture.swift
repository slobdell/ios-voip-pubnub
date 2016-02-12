//
//  EncodedAudioCapture.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/7/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation
import AVFoundation

class EncodedAudioCapture: ObserverSubject{
    var observers:[Observer]
    var audioEncoder:AudioEncoder
    let audioEngine = AVAudioEngine()
    let sampleTimeMs = TinCanXConstants().voiceSampleMs
    let finalSampleHertz = TinCanXConstants().voiceTransmissionHertz
    let audioFormat:AVAudioFormat
    let bus = 0
    let inputNode:AVAudioInputNode

    var lastVoicePacket:VoicePacket?
    var order:Int = 0

    init(){
        observers = []
        audioEncoder = AudioEncoder()

        inputNode = audioEngine.inputNode
        audioFormat = audioEngine.inputNode.inputFormatForBus(bus)
    }

    func getRawBufferSize() -> Int {
        let oneSecond = 1000.0
        let samplesPerSec = oneSecond / Double(self.sampleTimeMs)

        let inputHertz = audioFormat.sampleRate
        let sampleBufferSize = inputHertz / samplesPerSec
        return Int(sampleBufferSize)
    }

    func getDownSampledBufferSize() -> Int {
        let rawBufferSize = self.getRawBufferSize()
        return Int((Double(rawBufferSize) / audioFormat.sampleRate) * Double(finalSampleHertz))
    }

    func register(observer: Observer){
        observers.append(observer)
    }

    func notifyObservers(){
        for observer: Observer in self.observers{
            observer.update(self)
        }

    }

    func downSampleRawAudioInput(rawPCMValues:UnsafeMutablePointer<Float>) -> Array<Float>{

        let downSampledBufferSize = self.getDownSampledBufferSize()
        var downSampledBuffer:Array<Float> = Array(count: downSampledBufferSize, repeatedValue: 0.0)

        var downSampleIndex:Int = 0
        for(var bufferIndex:Double = 0.0; bufferIndex <= audioFormat.sampleRate; bufferIndex += audioFormat.sampleRate / Double(finalSampleHertz)){

            let pcmSample:Float = rawPCMValues[Int(bufferIndex)]
            downSampledBuffer[downSampleIndex] = pcmSample
            downSampleIndex++
            if(downSampleIndex == downSampledBufferSize){
                break
            }
        }
        return downSampledBuffer

    }

    func startReadingFromMicrophone(){
        let downSampledAudioFormat = AVAudioFormat(standardFormatWithSampleRate: Double(finalSampleHertz), channels: 1)
        let threadPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        let flags:UInt = 0

        let rawBufferSize = self.getRawBufferSize()


        self.inputNode.installTapOnBus(self.bus, bufferSize: UInt32(rawBufferSize), format:self.audioFormat) {
            (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in

            // hack in iOS apparently since rawBufferSize is ignored
            buffer.frameLength = UInt32(rawBufferSize)

            dispatch_async(dispatch_get_global_queue(threadPriority, flags)){
                let downSampledPCMAudio:Array<Float> = self.downSampleRawAudioInput(buffer.floatChannelData.memory)
                let encodedPacket:String = self.audioEncoder.encodePacketToString(downSampledPCMAudio)
                if(encodedPacket != ""){
                    self.lastVoicePacket = VoicePacket(voicePacket: encodedPacket, order: self.order, timestampMsCreated: self.currentTimeMillis())
                    self.order++
                    self.notifyObservers()
                }
            }

        }

        audioEngine.prepare()
        audioEngine.startAndReturnError(nil)

    }

    func stopReadingFromMicrophone(){
        inputNode.removeTapOnBus(bus)

    }

    // TODO move this to a utils file or something
    func currentTimeMillis() -> Int64{
        var nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
}
