//
//  NetworkDownloadOperation.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

protocol LabeledEntity {
    var label: String { get }
}

protocol RequiredOperationDependency {
    var isRequired: Bool { get }
}

class NetworkOperation: Operation, LabeledEntity, RequiredOperationDependency {
    private(set) var label: String
    private(set) var url: URL
    private(set) var isRequired: Bool

    init(label: String, url: URL, isRequired: Bool = false) {
        self.label = label
        self.url = url
        self.isRequired = isRequired
    }
    // MARK: - Main
    override func main() {
        guard !isCancelled else {
            print("\(type(of: self)).\(self.label) was canceled")
            return
        }

        for dependency in dependencies {
            if let op = dependency as? RequiredOperationDependency, op.isRequired, dependency.isCancelled {
                print("\(type(of: self)).\(self.label) cancel() self because required dependecy was canceled")
                cancel()
                return
            }
        }

        //Implement actual functionality in subclasses
    }

    // MARK: - Finished state managment
    private var _finished: Bool = false {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }

    override var isFinished: Bool {
        return _finished
    }

    // MARK: - Canceling
    override func cancel() {
        super.cancel()
        print("\(type(of: self)).\(self.label) will \(#function)")
        _finished = true
    }

    deinit {
        print("\(type(of: self)).\(self.label) will \(#function)")
    }
}

class NetworkDownloadOperation: NetworkOperation {}
