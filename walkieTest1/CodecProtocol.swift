//
//  CodecProtocol.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/9/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

protocol CodecProtocol{
    
    func encode(rawPCMValues:Array<Float>) -> Array<UInt8>?
    
    func decode(encodedBytes:Array<UInt8>) -> Array<Float>
}