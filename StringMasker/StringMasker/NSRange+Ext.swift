//
//  NSRange+Ext.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 24.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

extension NSRange {
    func toStringIndexRange(in string: String) -> Range<String.Index> {
        let start = string.index(string.startIndex, offsetBy: self.location)
        let end = string.index(start, offsetBy: self.length)
        return start..<end
    }
}
