//
//  IntroFlowComponent.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 18.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

struct IntroModel {}

class IntroComponent {
    var model: IntroModel
    var onExit: (IntroComponent) -> Void

    init(model: IntroModel, onExit: @escaping (IntroComponent) -> Void) {
        self.model = model
        self.onExit = onExit
        self.flowCoordinator.onExit = { [unowned self] in
            onExit(self)
        }
    }

    private var flowCoordinator: IntroductionFlowCoordinator = IntroductionFlowCoordinator()

    func start(from container: ViewControllerContainer) {
        flowCoordinator.start(from: container)
    }

    func remove(_ completion: (() -> Void)?) {
        flowCoordinator.remove(completion)
    }
}
