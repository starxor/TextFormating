//
//  Transport.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 05.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

struct NetworkRequest<T> {
    var value: T
    init(_ value: T) { self.value = value }
}

protocol NetworkTransport {
    associatedtype RequestType
    func perform(request: NetworkRequest<RequestType>)
}

class URLSessionTransport: NSObject, NetworkTransport {
    typealias RequestType = URLRequest
    private(set) var session: URLSession!
    private var queue: OperationQueue = OperationQueue()

    init(config: URLSessionConfiguration) {
        super.init()

        self.session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
    }

    func send() {
        var request = URLRequest(url: URL(string: "www.google.com")!)
        request.httpMethod = HTTPMethod.POST.rawValue
    }

    func perform(request: NetworkRequest<URLRequest>) {

    }
}

extension URLSessionTransport: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {

    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {

    }
}
