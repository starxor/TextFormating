//
//  SignInFlowComponent.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 18.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

struct UserCredentials {
    var login: String
    var password: String
}

class SingInComponent {
    var model: UserCredentials
    var onExit: (SingInComponent) -> Void

    init(model: UserCredentials, onExit: @escaping (SingInComponent) -> Void) {
        self.model = model
        self.onExit = onExit
        self.flowCoordinator.onExit = { [unowned self] in
            onExit(self)
        }
    }

    private var flowCoordinator: SignInFlowCoordinator = SignInFlowCoordinator()

    func start(from container: ViewControllerContainer) {
        flowCoordinator.start(from: container)
    }
    
}
