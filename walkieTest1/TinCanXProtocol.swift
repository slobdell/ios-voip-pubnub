//
//  TinCanXProtocol.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/7/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

protocol TinCanXProtocol{
    func initiateTrip(tripUUID:String, role:String)
    func enableListening()
    func disableListening()
    func startReadingMicrophone()
    func stopReadingMicrophone()
}
