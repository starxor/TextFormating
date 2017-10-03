//
//  HTTPMethod.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

enum HTTPMethod: RawRepresentable {
    typealias RawValue = String
    case GET
    case HEAD
    case POST
    case PUT
    case PATCH
    case DELETE
    case TRACE
    case OPTIONS
    case CONNECT
    case custom(String)

    var rawValue: HTTPMethod.RawValue {
        switch self {
        case .GET:     return "GET"
        case .PUT:     return "PUT"
        case .POST:    return "POST"
        case .HEAD:    return "HEAD"
        case .PATCH:   return "PATCH"
        case .TRACE:   return "TRACE"
        case .DELETE:  return "DELETE"
        case .OPTIONS: return "OPTIONS"
        case .CONNECT: return "CONNECT"
        case .custom(let value): return value
        }
    }

    init?(rawValue: HTTPMethod.RawValue) {
        switch rawValue {
        case "GET":     self = .GET
        case "PUT":     self = .PUT
        case "POST":    self = .POST
        case "HEAD":    self = .HEAD
        case "PATCH":   self = .PATCH
        case "TRACE":   self = .TRACE
        case "DELETE":  self = .DELETE
        case "OPTIONS": self = .OPTIONS
        case "CONNECT": self = .CONNECT
        default: self = .custom(rawValue)
        }
    }
}

extension HTTPMethod: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}

extension HTTPMethod: CustomDebugStringConvertible {
    var debugDescription: String {
        return self.rawValue
    }
}

extension HTTPMethod: Equatable {
    static func ==(lhs: HTTPMethod, rhs: HTTPMethod) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
