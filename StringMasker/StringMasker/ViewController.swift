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
        textFieldController = TextFieldController(textField: textField, textFormatter: RegexStupidPhoneStringFormatter())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onReady()
    }
}

class TextFieldController: NSObject, UITextFieldDelegate {
    var textField: UITextField
    var textFormatter: TextFormatter

    init(textField: UITextField, textFormatter: TextFormatter) {
        self.textField = textField
        self.textFormatter = textFormatter

        super.init()

        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    struct TextEditingResult {
        enum SelectionRange {
            case range(UITextRange?)
            case end
        }

        var text: String?
        var selectedRange: SelectionRange
    }

    private var textEditingResult = TextEditingResult(text: nil, selectedRange: .end)

    private func apply(editingResult result: TextEditingResult, to textField: UITextField) {
        textField.text = result.text
        switch result.selectedRange {
        case .range(let range):
            textField.selectedTextRange = range
        case .end:
            textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
        }

    }

    func textFieldEditingChanged(_ textField: UITextField) {
//        apply(editingResult: textEditingResult, to: textField)
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {

        print("range: \(NSStringFromRange(range))")
        print("replacementString: \(string)")
        print("existing: \(textField.text ?? "textField.text is nil")")
        if let text = textField.text {
            print("result: \(text.replacingCharacters(in: range.toStringIndexRange(in: text), with: string))")
        }
//        var formated: String
//        var selectedRange: TextEditingResult.SelectionRange
//        if let text = textField.text {
//            let result = text.replacingCharacters(in: range.toStringIndexRange(in: text), with: string)
//            formated = textFormatter.format(result)
//
//            if (string as NSString).length > 0 {
//                if let loc = textField.position(from: textField.beginningOfDocument, offset: range.location),
//                    let newLoc = textField.position(from: loc, offset: range.length),
//                    loc != textField.endOfDocument {
//                    selectedRange = .range(textField.textRange(from: newLoc, to: newLoc))
//                } else {
//                    selectedRange = .end
//                }
//            } else {
//                let originalRange = range.toStringIndexRange(in: text)
//                let substring = text.substring(with: originalRange)
//                // check if we deleted an inserted character
//                if range.length == 1,
//                    let scalar = substring.unicodeScalars.first, textFormatter.insertedCharacters.contains(scalar) {
//                    selectedRange = .end
//                    // search first char not in set
//                    let substring = text.substring(to: range.toStringIndexRange(in: text).lowerBound)
//                    var currentIndex = substring.endIndex
//                    while currentIndex != substring.startIndex {
//                        let next = substring.index(before: currentIndex)
//                        let set = CharacterSet(charactersIn: substring.substring(with: next..<currentIndex))
//                        currentIndex = next
//                        if !set.isSubset(of: textFormatter.insertedCharacters) {
//                            // found first char in set
//                            let newResult = text.replacingCharacters(in: currentIndex..<originalRange.lowerBound, with: "")
//                            // reformat
//                            formated = textFormatter.format(newResult)
//                            // update selected range
//                            let distance = text.distance(from: text.startIndex, to: currentIndex)
//                            let dist = formated.distance(from: formated.startIndex, to: formated.endIndex)
//                            let fromIndex = formated.index(formated.startIndex, offsetBy: min(distance, dist))
//                            let test = formated.substring(from: fromIndex)
//                            let testSet = CharacterSet(charactersIn: test)
//                            if testSet.isSubset(of: textFormatter.insertedCharacters) {
//                                selectedRange = .end
//                            } else {
//                                if let newPosition = textField.position(from: textField.beginningOfDocument, offset: distance) {
//                                    selectedRange = .range(textField.textRange(from: newPosition, to: newPosition))
//                                }
//                            }
//                            break
//                        }
//                    }
//                } else {
//                    if let loc = textField.position(from: textField.beginningOfDocument, offset: range.location) {
//                        selectedRange = .range(textField.textRange(from: loc, to: loc))
//                    } else {
//                        let start = textField.beginningOfDocument
//                        selectedRange = .range(textField.textRange(from: start, to: start))
//                    }
//                }
//            }
//
//        } else {
//            formated = textFormatter.format(string)
//            selectedRange = .end
//        }
//
//        textEditingResult.text = formated
//        textEditingResult.selectedRange = selectedRange

        return true
    }
}
