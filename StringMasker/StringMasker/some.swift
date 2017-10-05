//
//  some.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 05.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

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
