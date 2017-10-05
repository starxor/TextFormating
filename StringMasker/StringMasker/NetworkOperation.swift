//
//  NetworkOperation.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 05.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

class NetworkOperation: CustomCancelableOperation {
    struct NetworkOperationResult<Result> {
        var value: Result?
        var error: Error?
    }

    private(set) var url: URL
    private(set) var session: URLSession

    init(url: URL, label: String = "<No Label>", session: URLSession = URLSession.shared, isRequired: Bool = false) {
        self.url = url
        self.session = session
        super.init(label: label, isRequired: isRequired)
    }
}
