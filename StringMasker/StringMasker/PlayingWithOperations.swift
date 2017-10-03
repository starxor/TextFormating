//
//  PlayingWithOperations.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 26.09.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

class TestOperation: Operation, RequiredOperationDependency {
    private var _finished: Bool = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }

        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }

    var isRequired: Bool = false
    private(set) var label: String

    init(label: String) {
        self.label = label
    }

    override func main() {
        for dependency in dependencies {
            if let op = dependency as? RequiredOperationDependency, op.isRequired, dependency.isCancelled {
                print("\(type(of: self)).\(self.label) cancel() self because required dependecy was canceled")
                cancel()
                return
            }
        }

        guard !isCancelled else { return }

        let time = DispatchTime.now() + DispatchTimeInterval.seconds(3)
        DispatchQueue.main.asyncAfter(deadline: time) { [weak self] in
            guard let `self` = self else {
                print("Operation was released before we got in asyncAfter")
                return
            }
            print("\(type(of: self)).\(self.label) executes \(#function) async after \(time.rawValue)")
            self._finished = true
        }
    }

    override var isFinished: Bool {
        return _finished
    }

    override func cancel() {
        super.cancel()
        print("\(type(of: self)).\(self.label) will \(#function)")
        _finished = true
    }

    deinit {
        print("\(type(of: self)).\(self.label) will \(#function)")
    }
}
