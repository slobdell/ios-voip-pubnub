//
//  TinCanX.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/6/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

class TinCanX: Observer, TinCanXProtocol{
    var communicator:Communicator!
    let encodedAudioCapture:EncodedAudioCapture = EncodedAudioCapture()
    let encodedAudioPlayer:EncodedAudioPlayer = EncodedAudioPlayer()
    
    init(){
        (encodedAudioCapture as ObserverSubject).register(self)
    }
    
    func update(object: AnyObject){
        if(object is VoicePacket){
            self._update(object as! VoicePacket)
        } else if (object is EncodedAudioCapture){
            self._update(object as! EncodedAudioCapture)
        }

    }
    func _update(voicePacket: VoicePacket){
        
        self.encodedAudioPlayer.enqueueEncodedAudioSample(voicePacket.encodedAudioString, timestampMs: voicePacket.timestampMsCreated)
    }
    
    func _update(encodedAudioCapture: EncodedAudioCapture){

        self.communicator.publish(encodedAudioCapture.lastVoicePacket!)
    }
    
    func initiateTrip(tripUUID:String, role:String){
        self.communicator = Communicator(channelName: tripUUID, role: role)
        (self.communicator as ObserverSubject).register(self)
        
        
    }
    
    func enableListening(){
        
    }
    
    func disableListening(){
        
    }
    
    func startReadingMicrophone(){
        self.encodedAudioCapture.startReadingFromMicrophone()
    }
    
    func stopReadingMicrophone(){
        self.encodedAudioCapture.stopReadingFromMicrophone()
    }

}