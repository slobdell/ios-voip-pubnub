//
//  ObserverSubject.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/7/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import Foundation

protocol ObserverSubject{
    var observers:[Observer] {get set}
    func register(observer: Observer)
    func notifyObservers()
}