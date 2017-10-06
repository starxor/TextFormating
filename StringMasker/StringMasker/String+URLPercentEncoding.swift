//
//  String+URLPercentEncoding.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 06.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

/*


     Great answer. I think you can use NSCharacterSet.URLQueryAllowedCharacterSet() instead of manually creating the allowed characters. – Eddie Sullivan Jun 13 '16 at 10:51


     @EddieSullivan - Not quite. If you do that, you have to make a mutable copy and then remove a few characters, notably & and +, which URLQueryAllowedCharacterSet will allow to pass unescaped. See stackoverflow.com/a/35912606/1271826. – Rob Jun 13 '16 at 14:02
    https://stackoverflow.com/a/27724627/1677710
 */

extension String {

    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// - returns: Returns percent-escaped string.

    func addingPercentEncodingForURLQueryValue() -> String? {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return addingPercentEncoding(withAllowedCharacters: allowed)
    }

}
