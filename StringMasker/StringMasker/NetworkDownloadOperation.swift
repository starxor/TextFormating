//
//  NetworkDownloadOperation.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

class NetworkDownloadOperation: Operation, RequiredOperationDependency {
    var isRequired: Bool = false

    private var _finished: Bool = false {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }

    private(set) var label: String
    private(set) var url: URL

    init(label: String, url: URL) {
        self.label = label
        self.url = url
    }

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
