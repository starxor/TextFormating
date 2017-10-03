//
// Random
// EE Utilities
//
// Copyright (c) 2015 Eugene Egorov.
// License: MIT, https://github.com/eugeneego/utilities-ios/blob/master/LICENSE
//

import Foundation

public enum Random {
    /**
        Generate a random unsigned integer number.
        - returns: An unsigned integer number in a [0, UInt32.max) range.
     */
    public static func uint32() -> UInt32 {
        return arc4random_uniform(UInt32.max)
    }

    /**
        Generate a random integer number.
        - parameter max: The maximum number, not inclusive.
        - returns: An integer number in a [0, max) range.
     */
    public static func int(_ max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }

    /**
        Generate a random integer number.
        - parameter min: The minimum number, inclusive.
        - parameter max: The maximum number, inclusive.
        - returns: An integer number in a [min, max] range.
     */
    public static func int(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }

    /**
        Generate a random integer number.
        - parameter range: The range.
        - returns: An integer number in a given range.
     */
    public static func int(_ range: Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound + 1)))
    }

    /**
        Generate a random boolean vaue.
        - returns: *true* with 50% chance
     */
    public static func bool() -> Bool {
        return bool(chance: 50)
    }

    /**
        Generate a random boolean vaue.
        - parameter chance: The chance of *true*.
        - returns: *true* with a given chance (from 0% to 100%)
     */
    public static func bool(chance: Int) -> Bool {
        return arc4random_uniform(100) < UInt32(min(max(chance, 0), 100))
    }
}
