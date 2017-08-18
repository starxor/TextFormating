//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 09.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
    private var rootContainer: ViewControllerContainer
    init(rootContainer: ViewControllerContainer) {
        self.rootContainer = rootContainer
    }

    var currentComponents: [AnyObject] = []

    fileprivate var _isRuning = false

    var isRuning: Bool {
        return _isRuning
    }

    func start() {
        _isRuning = true
        let intro = introFlowComponent()
        currentComponents.append(intro)
        intro.start(from: rootContainer)
    }

    func introFlowComponent() -> IntroComponent {
        // TODO: maybe some view controller swapper to handle the transitions?
        return IntroComponent(model: IntroModel()) { [unowned self] cmp in
            cmp.remove {
                let compare: (AnyObject) -> Bool = { some in
                    some === cmp
                }

                let index = self.currentComponents.index(where: compare)

                if let index = index {
                    self.currentComponents.remove(at: index)
                }

                self.proceedToGuestMode() }
            print("intro has finished")
        }

    }

    func guestModeFlowComponent() -> GuestModeComponent {
        return GuestModeComponent(model: GuestModeModel()) { _ in
            print("guest mode wants to exit")
        }
    }

    func proceedToGuestMode() {
        let guest = guestModeFlowComponent()
        guest.start(from: rootContainer)
    }
}

enum ViewControllerContainer {
    case navigationController(UINavigationController)
    case tabbarController(UITabBarController)
    case splitViewController(UISplitViewController)
    case pageViewController(UIPageViewController)
    case custom(UIViewController)

    var unboxed: UIViewController {
        switch self {
        case .navigationController(let ctrl): return ctrl
        case .tabbarController(let ctrl): return ctrl
        case .splitViewController(let ctrl): return ctrl
        case .pageViewController(let ctrl): return ctrl
        case .custom(let ctrl): return ctrl
        }
    }
}

enum AppFlowComponents {
    case intro
    case guest
    case signIn
    case signUp
    case signInSettings
    case user
}

