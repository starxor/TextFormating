//
//  GuestFlowCoordinator.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 14.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation
import UIKit

class GuestFlowCoordinator {
    lazy var initialController = UIStoryboard(name: AppStoryboards.guestMode, bundle: nil)
        .instantiateInitialViewController() as? UINavigationController
    var container: ViewControllerContainer?

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

    func remove(_ completion: (() -> Void)?) {
        guard let initial = initialController, let container = container else { fatalError("initialController is not configured") }

        switch container {
        case .custom:
            initial.dismiss(animated: true, completion: completion)
        case .navigationController(let ctrl):
            guard let index = ctrl.viewControllers.index(of: initial) else { return }

            ctrl.setViewControllers(Array<UIViewController>(ctrl.viewControllers.prefix(upTo: index)), animated: true)
        case .pageViewController:
            initial.dismiss(animated: true, completion: completion)
        case .splitViewController:
            break
        case .tabbarController:
            initial.dismiss(animated: true, completion: completion)
        }
    }
}