//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 09.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationController {
    init(rootContainer: ViewControllerContainer)
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

enum ApplicationState {
    case intro
    case guest
    case auth
    case user
}
