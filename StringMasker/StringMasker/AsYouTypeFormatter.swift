//
//  AsYouTypeFormatter.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 06.09.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

enum CaretPosition {
    case end
    case position(Int)
}

struct FormatResult {
    var string: String
    var carretPosition: CaretPosition
}

protocol AsYouTypeFormatter {
    func format(existing: String, input: String, range: NSRange) -> FormatResult
    func format(_ input: InputAction) -> FormatResult
}

extension AsYouTypeFormatter {
    func format(existing: String, input: String, range: NSRange) -> FormatResult {
        let action = inputAction(from: input, targetRange: range, target: existing)
        return format(action)
    }

    func inputAction(from input: String, targetRange range: NSRange, target: String) -> InputAction {
        let stringIndexRange = range.toStringIndexRange(in: target)
        if stringIndexRange.lowerBound == target.endIndex {
            return input.characters.count > 0 ? .append(string: input, target: target) : .deleteLast(target: target)
        } else {
            if input.characters.count > 0 {
                return .insertion(string: input, target: target, range: range.toStringIndexRange(in: target))
            } else {
                return .deletion(target: target, range: range.toStringIndexRange(in: target))
            }
        }
    }
}

struct PhoneNumberFormatter: AsYouTypeFormatter {
    /// area code to substitute
    var predefinedAreaCode: Int? = nil
    /// number of digits without country code
    var maxNumberLength: Int? = nil
    func format(_ input: InputAction) -> FormatResult {
        switch input {
        case .append:
            return FormatResult(string: format(input.result), carretPosition: .end)
        case .deleteLast:
            return FormatResult(string: input.result, carretPosition: .end)
        case .deletion(let target, let range):
            let pos = target.distance(from: target.startIndex, to: range.lowerBound)
            let formatted = format(input.result)
            var resPos = CaretPosition.end
            if formatted.characters.count > pos {
                resPos = .position(pos)
            }
            return FormatResult(string: formatted, carretPosition: resPos)
        case .insertion(let string, let target, let range):
            let resStr = input.result
            let prefix = target.substring(to: range.lowerBound)
            let suffixRange = resStr.index(range.lowerBound, offsetBy: string.characters.count)
			let suffix = resStr.substring(from: suffixRange)
            let formattedPrefix = format(prefix + string)
            let resPos = CaretPosition.position(formattedPrefix.characters.count)
            let formatted = format(formattedPrefix+suffix)
            return FormatResult(string: formatted, carretPosition: resPos)
        }
    }

    private func format(_ string: String) -> String {
        if string.characters.count == 0 {
            return string
        }

        var plain = string.replacingOccurrences(of: toPlainPattern, with: "", options: .regularExpression)
        if let maxNumbLength = maxNumberLength, plain.characters.count > maxNumbLength {
            let index = plain.index(plain.startIndex, offsetBy: maxNumbLength)
            plain = plain.substring(to: index)
        }

        let acPattern: String

        if (plain.characters.count < 2) {
            guard let code = Int(plain) else { return "" }
            acPattern = areaCodePattern(for: code)
        } else {
            let takeFirstIndex = plain.index(plain.startIndex, offsetBy: 1)
            let takeFirstTwoIndex = plain.index(plain.startIndex, offsetBy: 2)

            guard let tryFirst = Int(plain.substring(to: takeFirstIndex)) else { return "" }

            guard let tryFirstTwo = Int(plain.substring(to: takeFirstTwoIndex)) else { return "" }

            if tryFirst == 1 || tryFirst == 7 {
                acPattern = areaCodePattern(for: tryFirst)
            } else {
                acPattern = areaCodePattern(for: tryFirstTwo)
            }
        }

        let fullPattern = acPattern + formatPattern

        let formatted = plain.replacingOccurrences(of: fullPattern, with: replacePattern, options: .regularExpression)
        let clean = formatted.replacingOccurrences(of: cleanPattern, with: "", options: .regularExpression)

        return clean
    }
}

extension PhoneNumberFormatter {
    var formatPattern: String {
        var prefix = "((?<=.)"
        if predefinedAreaCode != nil {
            prefix = "^("
        }
        let firstPart = prefix + "[0-9]{1,3})?((?<=.{3})[0-9]{1,3})?"
        let secondPart = "((?<=.{2})[0-9]{1,2})?((?<=.{2})[0-9]{1,2})?((?<=.{2})[0-9]{1,4})?"
        return firstPart + secondPart
    }

    var toPlainPattern: String {
        if let code = predefinedAreaCode {
            return "^\\+\(code)|\\D"
        }
        return "\\D"
    }

    var replacePattern: String {
        if let areaCode = predefinedAreaCode {
            return "+\(areaCode) ($1) $2-$3-$4-$5"
        } else {
            return "+$1 ($2) $3-$4-$5-$6"
        }
    }

    var cleanPattern: String {
        return "--|-$|\\(\\)| -| \\(\\)"
    }

    func areaCodePattern(for areaCode: Int) -> String {
        if predefinedAreaCode != nil {
            return ""
        }

        switch areaCode {
        case 1, 7:
            return "^\\+?([0-9]{1})"
        default:
            if LessThenThreeDigitsAreaCodes.contains(areaCode) {
                return "^\\+?([0-9]{2})"
            } else {
                return "^\\+?([0-9]{1,3})"
            }
        }
    }
}

///      World phone region codes. Data taken from wikipedia.
///		This is the code you enter after + or 00 to call countries(regions) aroun the world.
///      For example: you enter +1 to call United States or +7 to call Russia or Kazahstan or +39 to call Italy.
///      This is an array of region codes that consist of one or two digits.
///      All other known codes are 3 digit codes.
    let LessThenThreeDigitsAreaCodes = [
// 		   North American Numbering Plan countries and territories  (US and others)
            1,
//         ================================================
//             EG |  ZA |  -- |
            20, 27, 28,
//         ================================================
//          GR| NL| BE| FR| ES| HU| IT|
//			  |   |   |   |   |   |   |
            30, 31, 32, 33, 34, 36, 39,
//         ================================================
//         RO |CH |AT | GB| DK| SE| NO| PL| DE|
//            |   |   | UK|   |   |   |   |   |
//            |   |   | GG|   |   |   |   |   |
//            |   |   | SJ|   |   |   |   |   |
//            |   |   | JE|   |   |   |   |   |
            40, 41, 43, 44, 45, 46, 47, 48, 49,
//          ===============================================
//          PE| MX| CU| AR| BR| CL| CO| VE|
            51, 52, 53, 54, 55, 56, 57, 58,
//          ===============================================
//          AU| ID| PH| NZ| SG| TH|
//          CX|   |   | PN|   |   |
//          CC|   |   |   |   |   |
            61, 62, 63, 64, 65, 66,
//          ===============================================
//          RU|
//          KZ|
             7,
//          ===============================================
//          JP| KR| --| VN| CN| --|
            81, 82, 83, 84, 86, 89,
//          ===============================================
//          TR| IN| PK| AF| LK| MM| IR|
//          CT|   |   |   |   |   |   |
            90, 91, 92, 93, 94, 95, 98
        ]
