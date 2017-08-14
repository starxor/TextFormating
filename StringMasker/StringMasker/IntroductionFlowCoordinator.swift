//
//  IntroductionFlowCoordinator.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 14.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation
import UIKit

class IntroductionFlowCoordinator: FlowCoordinator {
    private var navigationRoot: ViewControllerContainer
    required init(navigationRoot: ViewControllerContainer) {
        self.navigationRoot = navigationRoot
    }

    func start() {
        showIntroduction(from: navigationRoot)
    }

    func showIntroduction(from viewController: ViewControllerContainer) {
        navigationRoot.unboxed.present(introductionController, animated: true, completion: nil)
    }

    private var introductionController: UIViewController = {
        return UIViewController()
    }()
}
