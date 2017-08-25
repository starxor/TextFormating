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

enum CaretPosition {
    case end
    case position(Int)
}

struct FormatResult {
    var string: String
    var carretPosition: CaretPosition
}

protocol FormatDescriptor {
    var pattern: String { get set }
    var replacePattern: String { get set }
    var toPlainPattern: String { get set }
    var cleanPattern: String { get set }
}

protocol AsYouTypeStringFormatter {
    func format(existing: String, input: String, range: NSRange) -> FormatResult
    var descriptor: FormatDescriptor { get set }
    var formatOnDeletion: Bool { get }
    func format(_ input: InputAction) -> FormatResult
}

extension AsYouTypeStringFormatter {
    func format(existing: String, input: String, range: NSRange) -> FormatResult {
        let action = inputAction(from: input, targetRange: range, target: existing)

        switch action {
            case .deleteLast, .deletion:
                if formatOnDeletion {
                    return format(action)
                } else {
                    let caretPosition = self.caretPosition(for: action)
                    let actionResult = action.result
                    return FormatResult(string: actionResult, carretPosition: caretPosition)
                }
            default:
                return format(action)
            }

    }

    func caretPosition(for inputAction: InputAction) -> CaretPosition {
        switch inputAction {
            case .append:
                return .end
            case .deleteLast:
                return .end
        // TODO: Logic for insertion / deletion
        case .deletion:
            return .end
        case .insertion:
            return .end
        }
    }

    func inputAction(from input: String, targetRange range: NSRange, target: String) -> InputAction {
        switch (range.length, input.characters.count) {
        case (0, 1):
            return .append(string: input, target: target)
        case (1, 0):
            return .deleteLast(target: target)
        default:
            if input.characters.count > 0 {
                return .insertion(string: input, target: target, range: range.toStringIndexRange(in: target))
            } else {
                return .deletion(target: target, range: range.toStringIndexRange(in: target))
            }
        }
    }
}
