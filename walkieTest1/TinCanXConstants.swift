//
//  TinCanXConstants.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/7/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

struct TinCanXConstants {
    let voiceTransmissionHertz = 8000

    // 40 is the max possible allowed by Opus.  See https://mf4.xiph.org/jenkins/view/opus/job/opus/ws/doc/html/group__opus__encoder.html
    // voiceTransmittionHertz mod voiceSampleMs must also be 0
    let voiceSampleMs = 40
    
}
let serialQueue = dispatch_queue_create("hardcoreSerialQueue", nil)
