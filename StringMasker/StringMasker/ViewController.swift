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

    let opQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        textFieldController = TextFieldController(
            textField: textField,
            asYouTypeFormatter: PhoneNumberFormatter(predefinedAreaCode: 7, maxNumberLength: 10)
        )

        opQueue.qualityOfService = .default

        let op1 = TestOperation(label: "OP1")
        let op2 = TestOperation(label: "OP2")
        let op3 = TestOperation(label: "OP3")
        let op4 = TestOperation(label: "OP4")
        let op5 = TestOperation(label: "OP5")

        op3.isRequired = true
        op4.isRequired = true

        op2.addDependency(op1)
        op3.addDependency(op2)
        op4.addDependency(op3)
        op5.addDependency(op4)

        opQueue.addOperations([op1, op2, op3, op4, op5], waitUntilFinished: false)

        let oneSecond = DispatchTime.now() + DispatchTimeInterval.seconds(1)
        DispatchQueue.main.asyncAfter(deadline: oneSecond) {
            op2.cancel()
            op4.cancel()
        }
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
