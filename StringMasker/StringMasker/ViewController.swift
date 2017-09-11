//
//  ViewController.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    var textFieldController: TextFieldController!

    var onReady: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        textFieldController = TextFieldController(
            textField: textField,
            asYouTypeFormatter: PhoneNumberFormatter(predefinedAreaCode: 7, maxNumberLength: 10)
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onReady()
    }
}

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

    func textFieldEditingChanged(_ textField: UITextField) {
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
