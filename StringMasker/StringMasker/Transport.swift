//
//  Transport.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 05.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

protocol Transport {
    func send()
    func get()
}

class URLSessionTransport: NSObject {
    private(set) var session: URLSession!
    private var queue: OperationQueue = OperationQueue()

    init(config: URLSessionConfiguration) {
        super.init()

        self.session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
    }

    func send() {
        let op = NetworkDownloadOperation(url: URL(string: "www.google.com")!)
        queue.addOperation(op)
    }
}

extension URLSessionTransport: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {

    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {

    }
}
