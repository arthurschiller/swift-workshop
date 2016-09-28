//
//  Extensions.swift
//  ParticleBurst
//
//  Created by Arthur Schiller on 26.07.16.
//  Copyright © 2016 HYPH. All rights reserved.
//

import Foundation

// Random UIInt32
public extension UInt32 {
    static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
        return arc4random_uniform(upper - lower) + lower
    }
}

// Delay function
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
    dispatch_get_main_queue(), closure)
}