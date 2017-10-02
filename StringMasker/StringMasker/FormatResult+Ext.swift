//
//  FormatResult+Ext.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 26.09.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit

extension FormatResult {
    func textPosition(in textField: UITextField) -> UITextRange? {
        switch carretPosition {
        case .end:
            return textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
        case .position(let pos):
            guard let tpos = textField.position(from: textField.beginningOfDocument, offset: pos) else { return nil }

            return textField.textRange(from: tpos, to: tpos)
        }
    }
}
