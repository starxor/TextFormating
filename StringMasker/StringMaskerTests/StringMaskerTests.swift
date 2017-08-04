//
//  StringMaskerTests.swift
//  StringMaskerTests
//
//  Created by Stanislav Starzhevskiy on 03.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import XCTest
@testable import StringMasker

class StringMaskerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let masker = PhoneNumberKitFormatter()
        let testList = [
            "14067189000",
            "15708866000",
            "37379381333",
            "79657535778",
            "89657535778",
            "079381333",
            "7",
            "79",
            "791",
            "7911",
            "79113",
            "791134",
            "7911348",
            "79113493",
            "791134933",
            "79113493390",
            "79657535778",
        ]
        
        for input in testList {
            print(masker.format("+" + input))
            
        }
        
//        for _ in 0..<100 {
//            let randomPhone = 10_000_000_000 + Int(arc4random_uniform(99_999_999)) * 1000
//            print(masker.mask(String(randomPhone)))
//        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
