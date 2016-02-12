//
//  JitterBuffer.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/7/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation
import AVFoundation

class BufferNode{
    var next:BufferNode?
    var previous:BufferNode?
    let value:AVAudioPCMBuffer
    let timestampMs:Int64
    
    init(value:AVAudioPCMBuffer, timestampMs:Int64){
        self.value = value
        self.timestampMs = timestampMs

    }

}

class JitterBuffer{
    var head:BufferNode? = nil
    var tail:BufferNode? = nil
    let bufferTimeMs = 150
    var count:Int = 0
    
    init(){

    }
    
    func enqueue(buffer: AVAudioPCMBuffer, timestampMs: Int64){
        count++
        let node = BufferNode(value: buffer, timestampMs: timestampMs)
        // first check empty case
        if(self.tail == nil){
            self.head = node
            self.tail = node
        } else {
            // need to determine if packet arrived in order
            if(self.tail!.timestampMs <= timestampMs){
                // primary case
                self.tail!.next = node
                node.previous = self.tail
                self.tail = node
            } else {
                // traverse linearly until we find the right now
                var cursor:BufferNode? = self.tail
                while(cursor!.timestampMs > timestampMs){
                    cursor = cursor!.previous
                    if(cursor == nil){
                        node.next = head
                        head!.previous = node
                        head = node
                        return
                    }
                }
                node.next = cursor!.next
                node.next!.previous = node
                node.previous = cursor
                cursor!.next = node

            }
        }
        
    }
    
    func dequeue() -> AVAudioPCMBuffer?{
        if(self.head == nil){
            return nil
        }
        let nextTimestamp:Int64 = self.head!.timestampMs
        if(nextTimestamp > (self.currentTimeMillis() - self.bufferTimeMs)){
            return nil
        }
        count -= 1

        let buffer = self.head!.value
        self.head = self.head!.next
        if (self.head != nil){
            self.head!.previous = nil
        } else {
            self.tail = nil
        }
        // there's automatic garbage collection right??
        return buffer
    }
    
    func currentTimeMillis() -> Int64{
        var nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
}