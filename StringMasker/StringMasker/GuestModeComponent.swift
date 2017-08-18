//
//  GuestModeComponent.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 18.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

class GuestModeModel {}

class GuestModeComponent {
    var model: GuestModeModel
    var onExit: (GuestModeComponent) -> Void

    init(model: GuestModeModel, onExit: @escaping (GuestModeComponent) -> Void) {
        self.model = model
        self.onExit = onExit
        self.flowCoordinator.onExit = { [unowned self] in
            onExit(self)
        }
    }

    private var flowCoordinator: GuestFlowCoordinator = GuestFlowCoordinator()

    func start(from container: ViewControllerContainer) {
        flowCoordinator.start(from: container)
    }

    func remove(_ completion: (() -> Void)?) {
        flowCoordinator.remove(completion)
    }
}
