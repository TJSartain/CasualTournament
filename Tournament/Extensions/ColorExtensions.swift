//
//  ColorExtensions.swift
//  SwiftGraphics
//
//  Created by TJ Sartain on 3/9/18.
//  Copyright © 2018 iTrinity, Inc. All rights reserved.
//

import UIKit

extension UIColor
{
    class func color(withData data:Data) -> UIColor
    {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }

    func encode() -> Data
    {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }

    struct Channels {
        var r, g, b, a: CGFloat
    }

    static func channels(_ c: UIColor) -> Channels
    {
        var channels = Channels(r: 0, g: 0, b: 0, a: 0)
        c.getRed(&channels.r, green: &channels.g, blue: &channels.b, alpha: &channels.a)
        return channels
    }

    func lighter() -> UIColor
    {
        let c = UIColor.channels(self)
        return UIColor.rgb(min(c.r * 5 / 4, 1),
                           min(c.g * 5 / 4, 1),
                           min(c.b * 5 / 4, 1))
    }

    func lighterByPct(_ pct: CGFloat) -> UIColor
    {
        let c = UIColor.channels(self)
        return UIColor.rgb(min(pct/100 * (1-c.r) + c.r, 1),
                           min(pct/100 * (1-c.g) + c.g, 1),
                           min(pct/100 * (1-c.b) + c.b, 1))
    }

    func darker() -> UIColor
    {
        let c = UIColor.channels(self)
        return UIColor.rgb(c.r * 4 / 5,
                           c.g * 4 / 5,
                           c.b * 4 / 5)
    }

    func hexValue() -> String
    {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    func description() -> String
    {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "(%ld, %ld, %ld)", Int(round(r * 255)), Int(round(g * 255)), Int(round(b * 255)))
    }

    static func rgb(_ r: Int, _ g: Int, _ b: Int) -> UIColor
    {
        return rgb(Double(min(max(r, 0), 255)) / 255,
                   Double(min(max(g, 0), 255)) / 255,
                   Double(min(max(b, 0), 255)) / 255)
    }

    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor
    {
        return rgba(Double(r), Double(g), Double(b), 1)
    }

    static func rgb(_ r: Double, _ g: Double, _ b: Double) -> UIColor
    {
        return rgba(r, g, b, 1)
    }

    static func rgba(_ r: Double, _ g: Double, _ b: Double, _ a: Double) -> UIColor
    {
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }

    static func fromString(_ str: String) -> UIColor
    {
        if str.hasPrefix("(") {
            return fromCSV(str)
        } else if str.hasPrefix("#") {
            return fromHex(str)
        } else {
            return .clear
        }
    }

    static func fromCSV(_ c: String) -> UIColor
    {
        var csv = c.replace(this: "(", that: "")
        csv = csv.replace(this: ")", that: "")
        let parts = csv.split(separator: ",")
        guard parts.count == 3 else {
            return .clear
        }
        let r = Int(String(parts[0]).trim)!
        let g = Int(String(parts[1]).trim)!
        let b = Int(String(parts[2]).trim)!
        return rgb(r, g, b)
    }

    static func fromHex(_ h: String) -> UIColor
    {
        var hex = h.replace(this: "#", that: "")
        if hex.count == 1 {
            hex = hex + hex + hex + hex + hex + hex
        } else if hex.count == 2 {
            hex = hex + hex + hex
        } else if hex.count == 3 {
            hex = "\(hex[0])\(hex[0])\(hex[1])\(hex[1])\(hex[2])\(hex[2])"
        }
        if hex.count != 6 {
            return .clear
        }
        let r = hexToInt(hex: String(hex[0...1]))
        let g = hexToInt(hex: String(hex[2...3]))
        let b = hexToInt(hex: String(hex[4...5]))
        return rgb(r, g, b)
    }

    static func hexToInt(hex: String) -> Int
    {
        var value: UInt32 = 0
        let hexValueScanner = Scanner(string: hex)
        hexValueScanner.scanHexInt32(&value)
        return Int(value)
    }

    func image() -> UIImage?
    {
        let chan = UIColor.channels(self)
        return imageWithOpacity(chan.a)
    }

    func imageWithOpacity(_ alpha: CGFloat) -> UIImage?
    {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(self.withAlphaComponent(alpha).cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}

let ImperialBlue     = UIColor.rgb(  0,  35, 149) // #002395
let TangerineYellow  = UIColor.fromHex("FC0")

let RedOrange        = UIColor.rgb(255, 103,  31) // #FF671F
let MagentaPink      = UIColor.rgb(138,   0,  77) // #8A004D
let BlueMagenta      = UIColor.rgb( 89,  23, 138) // #59178A
let CyanBlue         = UIColor.rgb( 26, 117, 207) // #1A75CF
let Purple1          = UIColor.rgb(194,  72, 133) // #C24885
let EvernoteGreen    = UIColor.rgb( 80, 158,  47) // #509E2F
let CoolGray         = UIColor.rgb( 97,  99, 101) // #616365

let WarmGrey         = UIColor.fromHex("80")
let GreyishBrown     = UIColor.fromHex("45")
let LightestGrey     = UIColor.fromHex("F0")
let LighterGrey      = UIColor.fromHex("D7")
let BrownishGrey     = UIColor.fromHex("6")
let Scarlet          = UIColor.rgb(200,   5,  10) // #C8050A
let OceanBlue        = UIColor.rgb(  0, 107, 180) // #006BB4
let OrangeYellow     = UIColor.rgb(255, 164,   0) // #FFA400
let Green            = UIColor.rgb(100, 179,  65) // #64B341
let CobaltBlue       = UIColor.rgb(  0,  36, 150) // #002496
let BabyBlue         = UIColor.rgb(167, 202, 255) // #A7CAFF
let Marine           = UIColor.rgb(  7,  41,  92) // #07295C

let CancelButton     = OceanBlue
let OKButton         = Green

let ltGreen  = UIColor.rgb( 80, 225,  18)
let dkGreen  = UIColor.rgb( 57, 113,   7)
let ltRed    = UIColor.rgb(245,  63,  66)
let dkRed    = UIColor.rgb(124,  16,   0)
let ltPurple = UIColor.rgb(145,  51, 229)
let dkPurple = UIColor.rgb( 83,  25, 113)
let ltBlue   = UIColor.rgb( 50, 172, 247)
let dkBlue   = UIColor.rgb(  5,  81, 136)
let ltYellow = UIColor.rgb(255, 195,  56)
let dkYellow = UIColor.rgb(172,  97,  11)
let ltTeal   = UIColor.rgb(  0, 249, 201)
let dkTeal   = UIColor.rgb(  0, 101,  81)


