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

struct PhoneNumberFormatter: AsYouTypeFormatter {
    func format(_ input: InputAction) -> FormatResult {
        
        return FormatResult(string: "", carretPosition: .end)
    }
}
