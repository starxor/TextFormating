//
//  UIComponent.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 18.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation


struct UIComponent<Model> {
    typealias ResultClosure = (Model) -> Void

    var model: Model
    var flowCoordinator: FlowCoordinator

    func start() {
        flowCoordinator.start()
    }
}
