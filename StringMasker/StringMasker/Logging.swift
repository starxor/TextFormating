//
//  Logging.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

public protocol ActionLogger {
    func log(action: CustomStringConvertible)
    func debugLog(action: CustomStringConvertible)
}

extension ActionLogger where Self: LabeledEntity {
    func log(action: CustomStringConvertible) {
        print("\(Swift.type(of: self)).\(label) ➡️ \(action.description)")
    }

    func debugLog(action: CustomDebugStringConvertible) {
        print("\(Swift.type(of: self)).\(label) ➡️ \(action.debugDescription)")
    }
}

enum NetworkOperationAction {
    case willRequestForResourceAtURL(URL)
    case willPerformRequest(URLRequest)
    case didRecieveResponseForRequest(URLRequest)
    case didStartedLoadingResourceFromURL(URL)
    case didRecieveData(progress: Progress)
    case didDownloadResource(fromURL:URL, localURL: URL)
    case didDownloadData(forRequest: URLRequest, localURL: URL)
}
