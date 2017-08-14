//
//  FlowCoordinator.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 14.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

protocol FlowCoordinator {
    init(navigationRoot: ViewControllerContainer)
    func start()
}
