//
//  Dictionary+StringFromHTTPParameters.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 06.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

/*
    https://stackoverflow.com/a/27724627/1677710
*/

extension Dictionary where Key == String, Value == String {

    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// - returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped

    func stringFromHttpParameters() -> String {
        let parameterArray = map { key, value -> String in
            let percentEscapedKey = key.addingPercentEncodingForURLQueryValue()
            let percentEscapedValue = value.addingPercentEncodingForURLQueryValue()
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }

        return parameterArray.joined(separator: "&")
    }

}
