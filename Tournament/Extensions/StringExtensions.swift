//
//  StringExtensions.swift
//  SwiftGraphics
//
//  Created by TJ Sartain on 5/16/17.
//  Copyright © 2017 iTrinity, Inc. All rights reserved.
//

import UIKit

enum HorizontalAlignment
{
    case Left
    case Center
    case Right
}

enum VerticalAlignment
{
    case Top
    case Middle
    case Bottom
}

extension String
{

    func draw(at point: CGPoint,
              font: UIFont,
              color: UIColor,
              shadow: NSShadow?,
              align: HorizontalAlignment,
              vAlign: VerticalAlignment)
    {
        let size = self.size(withFont: font)
        var x = point.x
        var y = point.y

        if align == .Center {
            x -= (size.width / 2)
        } else if align == .Right {
            x -= size.width
        }

        if vAlign == .Middle {
            y -= (size.height / 2)
        } else if  vAlign == .Bottom {
            y -= size.height
        }

        let rect = CGRect(x: x, y: y, width: size.width, height: size.height)
        var attribs: [NSAttributedStringKey : Any] = [
            .font: font,
            .foregroundColor: color
        ]
        if let shadow = shadow {
            attribs[.shadow] = shadow
        }
        draw(in: rect, withAttributes: attribs)
    }

    func toDictionary() -> [String: String]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func date(_ fmt: String? = "") -> Date?
    {
        var formats = ["yyyy-MM-dd hh:mm:ss a",
                       "yyyy-MM-dd hh:mm a",
                       "yyyy-MM-dd hh:mm",
                       "MM/dd/yyyy hh:mm",
                       "MM/dd/yyyy",
                       "M/d/yyyy hh:mm",
                       "M/d/yyyy",
                       "yyyy-MM-dd"]
        if stringNotEmpty(fmt) {
            formats.insert(fmt!, at: 0)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let tz = NSTimeZone.local
        dateFormatter.timeZone = tz
        dateFormatter.isLenient = true

        for fmt in formats {
            dateFormatter.dateFormat = fmt
            if let date = dateFormatter.date(from: self) {
                return date
            }
        }
        return nil
    }

    func size(withFont font: UIFont) -> CGSize
    {
        return self.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude,
                                              height: Double.greatestFiniteMagnitude),
                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                 attributes: [NSAttributedStringKey.font: font],
                                 context: nil).size
    }

    func dpad(_ d: Int) -> String
    {
        var pad = d + 1
        if let dp = self.index(of: ".") {
            let p = self.distance(from: startIndex, to: dp)
            pad = pad + p - self.count
        }
        return self + "                       ".prefix(pad)
    }

    func dpad(_ d: Int, pad: String) -> String
    {
        var newString = self
        var n = d
        if let i = self.index(of: ".") {
            let dp = self.distance(from: startIndex, to: i)
            n = n + 1 + dp - self.count
        } else if d > 0 {
            newString.append(".")
        }
        if n > 0 {
            for _ in 0..<n {
                newString.append(pad)
            }
        }
        return newString
    }

    var length : Int
    {
        return self.count
    }

    func equals(_ string: String) -> Bool
    {
        return caseInsensitiveCompare(string) == .orderedSame
    }

    func allDigits() -> Bool
    {
        if self.count > 0 {
            for i in 0..<self.count {
                if !("0123456789".contains(self[i..<i+1])) {
                    return false
                }
            }
            return true
        }
        return false
    }

    var trim: String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func trim(_ chars: String) -> String
    {
        let set = CharacterSet(charactersIn: chars)
        return self.trimmingCharacters(in: set)
    }

    func isNotEmpty() -> Bool
    {
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return !["nil", "<null>", "-1", ""].contains(str)
    }

    func removeDateWord() -> String
    {
        return removeWord("DATE")
    }

    func removeWord(_ word: String) -> String
    {
        let sansWord = self.replacingOccurrences(of: word,
                                         with: "",
                                         options: .caseInsensitive,
                                         range: self.range(of: self))
        return sansWord.trim
    }

    func removeSpaces() -> String
    {
        return self.replacingOccurrences(of: " ", with: "")
    }

    func replace(this: String, that: String) -> String
    {
        return self.replacingOccurrences(of: this, with: that)
    }

    func truncate(length: Int, trailing: String = "…") -> String
    {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }

    func pluralize() -> String
    {
        return pluralize(basedOn: [0])
    }

    func pluralize(basedOn list: [Any]) -> String
    {
        return pluralize(with: "s", basedOn: list)
    }

    func pluralize(with suffix: String, basedOn list: [Any]) -> String
    {
        if list.count != 1 {
            return self + suffix
        }
        return self
    }

    var localized: String
    {
        return NSLocalizedString(self, comment: self)
    }

    func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String
    {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }

    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    // Subscripting

    subscript (i: Int) -> Character
    {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript (bounds: CountableRange<Int>) -> Substring
    {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }

    subscript (bounds: CountableClosedRange<Int>) -> Substring
    {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }

    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring
    {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }

    subscript (bounds: PartialRangeThrough<Int>) -> Substring
    {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }

    subscript (bounds: PartialRangeUpTo<Int>) -> Substring
    {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }


    func indices(of occurrence: String) -> [Int]
    {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }

//    func ranges(of searchString: String) -> [Range<String.Index>]
//    {
//        let _indices = indices(of: searchString)
//        let count = searchString.count
//        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
//    }
}
