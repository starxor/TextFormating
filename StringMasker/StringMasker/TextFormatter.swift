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

enum InputAction {
    case append(string: String, target: String)
    case deleteLast(target: String)
    case deletion(target: String, range: Range<String.Index>)
    case insertion(string: String, target: String, range: Range<String.Index>)

    var result: String {
        switch self {
            case .append(let string, let target):
                return target.appending(string)
            case .deleteLast(let target):
                return target.substring(to: target.index(before: target.endIndex))
            case .deletion(let target, let range):
                return target.replacingCharacters(in: range, with: "")
            case .insertion(let string, let target, let range):
                return target.replacingCharacters(in: range, with: string)
        }
    }
}

protocol FormatDescriptor {
    var pattern: String { get set }
    var replacePattern: String { get set }
    var toPlainPattern: String { get set }
    var cleanPattern: String { get set }
}
