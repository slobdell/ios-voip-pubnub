//
//  Communicator.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/6/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

class Communicator: NSObject, PNObjectEventListener, ObserverSubject {

    var rxClient: PubNub

    var roundRobbinPublishers: Array<PubNub>
    let roundRobbinPublisherCount = 15
    var roundRobbinIndex = 0

    var observers:[Observer]

    var txChannelName:String = ""
    var rxChannelName:String = ""
    var latestTImestamp:Int = -1

    var latestMessage:MessageProtocol?


    func register(observer: Observer){
        observers.append(observer)
    }

    func notifyObservers(){
        for observer: Observer in self.observers{
            observer.update(self.latestMessage! as! AnyObject)
        }

    }

    convenience init(channelName:String, role:String){
        self.init()
        let a_tx_channel = channelName + "_a"
        let b_tx_channel = channelName + "_b"
        // debugging
        //let b_tx_channel = channelName + "_a"
        if (role == "b"){
            txChannelName = b_tx_channel
            rxChannelName = a_tx_channel
        } else {
            txChannelName = a_tx_channel
            rxChannelName = b_tx_channel
        }

        rxClient.subscribeToChannels([rxChannelName], withPresence: false)
        rxClient.addListener(self)

    }

    override init(){
        observers = []
        // TODO YOUR PUBNUB KEYS HERE
        let config = PNConfiguration(
            publishKey: "",
            subscribeKey: ""
        )

        rxClient = PubNub.clientWithConfiguration(config);
        roundRobbinPublishers = Array(count: roundRobbinPublisherCount, repeatedValue: PubNub.clientWithConfiguration(config))
        for(var index=0; index<roundRobbinPublisherCount; index++){
            roundRobbinPublishers[index] = PubNub.clientWithConfiguration(config)
        }
        super.init()
    }

    func publish(message: MessageProtocol){
        let serializedMessage = message.serialize()
        let publisher = self.roundRobbinPublishers[roundRobbinIndex]
        roundRobbinIndex++
        roundRobbinIndex = roundRobbinIndex % roundRobbinPublisherCount
        publisher.publish(serializedMessage, toChannel: self.txChannelName, compressed: false, withCompletion: nil)

    }

    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        let encodedMessage = message.data.valueForKey("message") as! NSDictionary

        self.latestMessage = MessageFactory.createFromDict(encodedMessage)
        self.notifyObservers()
    }
}
