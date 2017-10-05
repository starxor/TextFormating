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
    func debugLog(action: CustomDebugStringConvertible)
}

extension ActionLogger {
    func log(action: CustomStringConvertible) {
        print("\(Swift.type(of: self)) ➡️ \(action.description)")
    }

    func debugLog(action: CustomDebugStringConvertible) {
        print("\(Swift.type(of: self)) ➡️ \(action.debugDescription)")
    }
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
    case didRecieveResponseForRequest(URLRequest, URLResponse)
    case didStartedLoadingResourceFromURL(URL)
    case didRecieveData(progress: Progress)
    case didDownloadResource(fromURL:URL, localURL: URL)
    case didDownloadData(forRequest: URLRequest, localURL: URL)
    case didFail(Error)
}

extension NetworkOperationAction: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
            case .willRequestForResourceAtURL(let url):
                return "Will request resource 🌏 ➟ \(url)"
            case .willPerformRequest(let request):
                return "Will perform request 🌏 ➟ \(request.debugDescription)"
            case .didRecieveResponseForRequest(let request, let response):
                return "Did recieve response:\(response.debugDescription) for request 🌏 ➟ \(request.debugDescription)"
            case .didStartedLoadingResourceFromURL(let url):
                return "Did start loading resource 🌏 ➟ \(url)"
            case .didRecieveData(let progress):
                return "Did recieve data. ⏳ \(progress.localizedDescription ?? "nil")"
            case .didDownloadResource(let from, let localURL):
                return "Resource ➟ @\(from) downloaded successfuly. 📄 ➟ \(localURL)"
            case .didDownloadData(let request, let localURL):
                return "Data recieved for request 🌏 ➟ \(request.debugDescription). Saved to 📄 ➟ \(localURL)"
            case .didFail(let error):
                return "Did fail. Reason ➟ ❌ \(error.localizedDescription)"
        }
    }
}
