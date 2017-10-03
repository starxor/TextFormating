//
//  Logging.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

public protocol ActionLogger {
    func log(action: CustomStringConvertible)
    func debugLog(action: CustomStringConvertible)
}

extension ActionLogger where Self: LabeledEntity {
    func log(action: CustomStringConvertible) {
        print("\(Swift.type(of: self)).\(label) ➡️ \(action.description)")
    }

    func debugLog(action: CustomDebugStringConvertible) {
        print("\(Swift.type(of: self)).\(label) ➡️ \(action.debugDescription)")
    }
}
