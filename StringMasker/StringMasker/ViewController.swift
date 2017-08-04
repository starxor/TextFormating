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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textFieldController = TextFieldController(textField: textField, textFormatter: RegexStupidPhoneStringFormatter())
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
        apply(editingResult: textEditingResult, to: textField)
        _ = Formatter()
    }
    
    func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        
        print("replacementString: \(string)")
        print("shouldChangeCharactersIn: \(NSStringFromRange(range))")
        var formated: String
        var selectedRange: TextEditingResult.SelectionRange
        if let text = textField.text {
            let result = text.replacingCharacters(in: range.toStringIndexRange(in: text), with: string)
            formated = textFormatter.format(result)
            
            if (string as NSString).length > 0 {
                if let loc = textField.position(from: textField.beginningOfDocument, offset: range.location),
                   let newLoc = textField.position(from: loc, offset: range.length),
                   loc != textField.endOfDocument {
                    selectedRange = .range(textField.textRange(from: newLoc, to: newLoc))
                } else {
                    selectedRange = .end
                }
                
            } else {
                let substring = text.substring(with: range.toStringIndexRange(in: text))
                if range.length == 1,
                   let scalar = substring.unicodeScalars.first, textFormatter.insertedCharacters.contains(scalar) {
                    selectedRange = .end
                    // search first char not in set and reformat
                    let substring = text.substring(to: range.toStringIndexRange(in: text).lowerBound)
                    
                    for scalar in substring.unicodeScalars.reversed() {
                        if !textFormatter.insertedCharacters.contains(scalar),
                           let newRange = text.range(of: String(Character(scalar))) {
                            // delete and format
                        	let newResult = text.substring(to: newRange.lowerBound)
                            formated = textFormatter.format(newResult)
                            break
                        }
                    }
                } else {
                    if let loc = textField.position(from: textField.beginningOfDocument, offset: range.location) {
                        selectedRange = .range(textField.textRange(from: loc, to: loc))
                    } else {
                        let start = textField.beginningOfDocument
                        selectedRange = .range(textField.textRange(from: start, to: start))
                    }
                    
                }
            }
            
        } else {
            formated = textFormatter.format(string)
            selectedRange = .end
        }
        
        textEditingResult.text = formated
        textEditingResult.selectedRange = selectedRange
        
        return true
    }
}

extension NSRange {
    func toStringIndexRange(in string: String) -> Range<String.Index> {
        let start = string.index(string.startIndex, offsetBy: self.location)
        let end = string.index(start, offsetBy: self.length)
		return start..<end
    }
}
