//
//  PhoneNumberKitMasker.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation
import PhoneNumberKit

struct PhoneNumberKitFormatter: TextFormatter {
    var insertedCharacters: CharacterSet {
        return CharacterSet()
    }

    private let pnk = PhoneNumberKit()
    func format(_ input: String) -> String {
        let pf = PartialFormatter(phoneNumberKit: pnk, defaultRegion: "RU", withPrefix: true)
        return pf.formatPartial(input)
    }
}
