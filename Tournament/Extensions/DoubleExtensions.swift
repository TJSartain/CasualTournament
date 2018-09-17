//
//  Extensions.swift
//  SwiftGraphics
//
//  Created by TJ Sartain on 2/14/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit


extension Int
{
    func format(_ f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double
{
    func decimals(_ d: Int) -> String
    {
        var s = self.float(d)
        if s.contains(".") {
            while s.last == "0" {
                s.removeLast()
            }
            if s.last == "." {
                s.removeLast()
            }
        }
        return s
    }

    func float(_ d: Int) -> String
    {
        return String(format: "%.\(d)f", self)
    }

    func format(w: Int, d: Int, dpad: String? = "") -> String
    {
        var s = self.float(d)
        s = s.dpad(d, pad: dpad!)
        s = String(s.suffix(w))
        for _ in 0..<w-s.count {
            s = "\u{2007}" + s
        }
        return s
    }

    func format(_ f: String) -> String
    {
        return String(format: "%\(f)f", self)
    }

    func radians() -> Double
    {
        return self * Double.pi / 180
    }

    func degrees() -> Double
    {
        return self / Double.pi * 180
    }

    func equals(_ x: Double, _ tolerance: Double? = 0) -> Bool
    {
        return (x - tolerance!) <= self && self <= (x + tolerance!)
    }

    func between(_ x: Double, _ y: Double, _ tolerance: Double? = 0) -> Bool
    {
        return (min(x, y) - tolerance!) <= self && self <= (max(x, y) + tolerance!)
    }
}

// \u{200c}  2007,  2060
