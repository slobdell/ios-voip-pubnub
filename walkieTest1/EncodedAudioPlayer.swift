//
//  EncodedAudioPlayer.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/7/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation
import AVFoundation

class EncodedAudioPlayer: NSObject {
    let audioDecoder: AudioDecoder
    let jitterBuffer: JitterBuffer
    let audioEngine = AVAudioEngine()

    var currentAudioIndex:Int = 0
    let downSampledAudioFormat = AVAudioFormat(standardFormatWithSampleRate: Double(TinCanXConstants().voiceTransmissionHertz), channels: 1)
    let player = AVAudioPlayerNode()

    override init(){
        audioEngine.attachNode(player)

        audioEngine.connect(player, to: audioEngine.mainMixerNode, format: downSampledAudioFormat)

        audioDecoder = AudioDecoder()
        jitterBuffer = JitterBuffer()

        super.init()
        let timerFrequency:Double = Double(TinCanXConstants().voiceSampleMs) / 1000.0
        var timer = NSTimer.scheduledTimerWithTimeInterval(timerFrequency, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        timer.tolerance = 10000
        self.setSessionPlayAndRecord()

        audioEngine.prepare()
        audioEngine.startAndReturnError(nil)
        player.play()
    }

    func setSessionPlayAndRecord() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error:&error) {
            println("could not set output to speaker")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }

    // TODO need to include creation time aßnd all that stuff
    func enqueueEncodedAudioSample(encodedAudio: String, timestampMs:Int64){
        //println(count(encodedAudio))
        if (count(encodedAudio) > 100){
            println("=====")
            println(encodedAudio)
        }

        let buffer:AVAudioPCMBuffer = self.voicePacketToAVAudioBuffer(encodedAudio)

        dispatch_sync(serialQueue){
            self.jitterBuffer.enqueue(buffer, timestampMs: timestampMs)
        }
    }

    func voicePacketToAVAudioBuffer(encodedAudio: String) -> AVAudioPCMBuffer{
        let voicePacket:Array<Float> = audioDecoder.decodePacketFromString(encodedAudio)

        let decodedBuffer = AVAudioPCMBuffer(PCMFormat: downSampledAudioFormat, frameCapacity: AVAudioFrameCount(voicePacket.count))
        decodedBuffer.frameLength = AVAudioFrameCount(voicePacket.count)
        for(var index = 0; index < voicePacket.count; index++){
            decodedBuffer.floatChannelData.memory[index] = voicePacket[index]
        }
        return decodedBuffer
    }


    func update() {
        let buffer:AVAudioPCMBuffer? = self.jitterBuffer.dequeue()
        if(buffer != nil){
            player.scheduleBuffer(buffer, atTime: nil, options:nil, completionHandler: nil)
        }

    }

}
