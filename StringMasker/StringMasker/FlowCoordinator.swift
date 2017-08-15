//
//  FlowCoordinator.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 14.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

/*
 Flow coordinator
 */
protocol FlowCoordinator {
    typealias ExitFlowClosure = (Self) -> Void
    init(navigationRoot: ViewControllerContainer, successTransition: ApplicationState,
         onCancel: ExitFlowClosure?, onSuccess: ExitFlowClosure?)
    func start()
    var onCancel: ExitFlowClosure? { get set }
    var onSuccess: ExitFlowClosure? { get set }
}
