//
//  some.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 05.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

struct TestSt: Codable {
    var field1: String
    var field2: String
}

protocol TestProtocol {
    func ololo()
}

extension TestProtocol {
    func ololo() {
        print(#function)
    }
}

extension TestProtocol where Self: LabeledEntity {
    func ololo() {
        print(label + " " + #function)
    }
}

class Some {

}

extension Some: TestProtocol {}
