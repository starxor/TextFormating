//
//  SignInFlowCoordinator.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 14.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation
import UIKit

class SignInFlowCoordinator {
    lazy var initialController = UIStoryboard(name: AppStoryboards.signIn, bundle: nil)
        .instantiateInitialViewController() as? UINavigationController

    func start(from container: ViewControllerContainer) {
        guard let initial = initialController else { fatalError("initialController is not configured") }

        switch container {
        case .custom(let ctrl):
            ctrl.present(initial, animated: true, completion: nil)
        case .navigationController(let ctrl):
            ctrl.pushViewController(initial, animated: true)
        case .pageViewController(let ctrl):
            ctrl.present(initial, animated: true, completion: nil)
        case .splitViewController(let ctrl):
            ctrl.showDetailViewController(initial, sender: nil)
        case .tabbarController(let ctrl):
            ctrl.present(initial, animated: true, completion: nil)
        }
    }

    var onExit: () -> Void = {}

    var logInClosure: ((String?, String?) -> Void)?
}
