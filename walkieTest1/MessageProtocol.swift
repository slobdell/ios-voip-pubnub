//
//  MessageProtocol.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/9/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

protocol MessageProtocol {
    static var typeId: Int { get }
    func serialize() -> String
    static func deserialize(decodedJson:NSDictionary) -> MessageProtocol
}