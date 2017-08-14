//
//  AuthFlowCoordinator.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 14.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

class AuthorizationFlowCoordinator: FlowCoordinator {
    private var navigationRoot: ViewControllerContainer
    required init(navigationRoot: ViewControllerContainer) {
        self.navigationRoot = navigationRoot
    }

    func start() {}
}
