//
//  StringMasker.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

protocol TextFormatter {
    func format(_ input: String) -> String
    var insertedCharacters: CharacterSet { get }
}

struct RegexTextFormatterDescriptor {
    var toPlainPattern: String
    var formatPattern: String
    var replaceTemplate: String
    var cleanPattern: String
    var insertedCharacters: CharacterSet
}

struct RegexTextFormatter: TextFormatter {
    var descriptor: RegexTextFormatterDescriptor = RegexTextFormatterDescriptor(
        toPlainPattern: "", formatPattern: "", replaceTemplate: "", cleanPattern: "", insertedCharacters: CharacterSet()
    )

    func format(_ input: String) -> String {
        let plain = input.replacingOccurrences(of: descriptor.toPlainPattern, with: "", options: .regularExpression)
        let applyMask = plain.replacingOccurrences(of: descriptor.formatPattern, with: descriptor.replaceTemplate,
                                                   options: .regularExpression)
        let res = applyMask.replacingOccurrences(of: descriptor.cleanPattern, with: "", options: .regularExpression)
        return res
    }

    var insertedCharacters: CharacterSet {
        return descriptor.insertedCharacters
    }
}

struct RegexStupidPhoneStringFormatter: TextFormatter {
    private let lessThenThreeDigitsCallingCodes = [
        "1", // North American Numbering Plan countries and territories +1 (area code) local number
        // ===========================================
        // EG |  ZA |  -- |
        "20", "27", "28",
        // ===========================================
        // GR |  NL |  BE |  FR |  ES |  HU | IT, VA |
        "30", "31", "32", "33", "34", "36", "39",
        // ===========================================
        // RO |  CH |  AT | GB/UK |  DK |  SE |  NO |  PL |  DE |
        //    |     |     |   GG  |     |     |     |     |     |
        //    |     |     |   SJ  |     |     |     |     |     |
        //    |     |     |   JE  |     |     |     |     |     |
        "40", "41", "43",  "44" , "45", "46", "47", "48", "49",
        // ===========================================
        // PE |  MX |  CU |  AR |  BR |  CL |  CO |  VE |
        "51", "52", "53", "54", "55", "56", "57", "58",
        // ===========================================
        // AU |  ID |  PH |  NZ |  SG |  TH |
        // CX |     |     |  PN |     |     |
        // CC |     |     |     |     |     |
        "61", "62", "63", "64", "65", "66",
        // ===========================================
        // RU |
        // KZ |
        "7",
        // ===========================================
        // JP |  KR |  -- |  VN |  CN |  -- |
        "81", "82", "83", "84", "86", "89",
        // ===========================================
        // TR |  IN |  PK |  AF |  LK |  MM   IR
        // CT |     |     |     |     |     |     |
        "90", "91", "92", "93", "94", "95", "98",
        ]

    var descriptor: RegexTextFormatterDescriptor = RegexTextFormatterDescriptor(
        toPlainPattern: "\\D",
        formatPattern: "((?<=.)[0-9]{1,3})?((?<=.{3})[0-9]{1,3})?((?<=.{2})[0-9]{1,2})?((?<=.{2})[0-9]{1,2})?((?<=.{2})[0-9]{1,4})?",
        replaceTemplate: "+$1 ($2) $3-$4-$5-$6",
        cleanPattern: "--|-$|\\(\\)| -| \\(\\)", insertedCharacters: CharacterSet(charactersIn:"+ ()-")
    )

    private func regionFormatPattern(for string: String) -> String {
        if let regex = try? NSRegularExpression(pattern: "\\d{1,2}", options: .init(rawValue: 0)) {
            let fullRange = NSRange(location:0, length: (string as NSString).length)
            if let match = regex.firstMatch(in: string, options: .init(rawValue: 0), range: fullRange) {
                switch match.range.length {
                case 1:
                    return "^\\+?([0-9]{1})"
                case 2:
                    let checkNANPorRUKZ = string.substring(to: string.index(string.startIndex, offsetBy: 1))
                    if checkNANPorRUKZ == "1" || checkNANPorRUKZ == "7" {
                        return "^\\+?([0-9]{1})"
                    }
                    let code = string.substring(to: string.index(string.startIndex, offsetBy: 2))
                    if lessThenThreeDigitsCallingCodes.contains(code) {
                        return "^\\+?([0-9]{2})"
                    }
                    return "^\\+?([0-9]{1,3})"
                default:
                    return "^\\+?([0-9]{3})"
                }
            }
        }
        return "^\\+?([0-9]{1})"
    }

    func format(_ input: String) -> String {
        let plain = input.replacingOccurrences(
            of: descriptor.toPlainPattern, with: "", options: .regularExpression,
            range: input.startIndex..<input.endIndex
        )
        let applyMaskPattern = regionFormatPattern(for: plain) + descriptor.formatPattern
        let applyMask = plain.replacingOccurrences(
            of: applyMaskPattern,
            with: descriptor.replaceTemplate,
            options: .regularExpression,
            range: plain.startIndex..<plain.endIndex
        )

        let res = applyMask.replacingOccurrences(
            of: descriptor.cleanPattern, with: "",
            options: .regularExpression, range: applyMask.startIndex..<applyMask.endIndex
        )

        return res
    }

    var insertedCharacters: CharacterSet {
        return descriptor.insertedCharacters
    }
}
