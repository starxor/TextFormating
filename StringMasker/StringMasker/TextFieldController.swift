//
//  TextFieldController.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 16.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit

class TextFieldController: NSObject, UITextFieldDelegate {
    private var textField: UITextField
    private var formatter: AsYouTypeFormatter = PhoneNumberFormatter(predefinedAreaCode: 7, maxNumberLength: 10)
    private var formatResult = FormatResult(string: "", carretPosition: .end)

    init(textField: UITextField, asYouTypeFormatter: AsYouTypeFormatter) {
        self.textField = textField
        self.formatter = asYouTypeFormatter

        super.init()

        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    @objc func textFieldEditingChanged(_ textField: UITextField) {
        textField.text = formatResult.string
        textField.selectedTextRange = formatResult.textPosition(in: textField)
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        formatResult = formatter.format(existing: textField.text ?? "", input: string, range: range)

        return true
    }
}
