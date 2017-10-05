//
//  CustomCancelableOperation.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 05.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

protocol RequiredOperationDependency {
    var isRequired: Bool { get }
}

class CustomCancelableOperation: Operation, LabeledEntity, RequiredOperationDependency {
    private(set) var label: String
    private(set) var isRequired: Bool

    init(label: String, isRequired: Bool = false) {
        self.label = label
        self.isRequired = isRequired
    }

    // MARK: - Finished state managment
    private var _finished: Bool = false {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }

    func finish() {
        _finished = true
    }

    override var isFinished: Bool {
        return _finished
    }

    // MARK: - Canceling
    override func cancel() {
        debugLog(action: CustomCancelableOperationAction.willCancel(reason: "Canceled by user."))
        super.cancel()
        _finished = true
    }

    // MARK: - Deinit
    deinit {
        debugLog(action: CustomCancelableOperationAction.willDeinit)
    }
}

extension CustomCancelableOperation {
    // MARK: - Validate execution
    var canRun: Bool {
        guard !isCancelled else { return false }

        for dependency in dependencies {
            if let op = dependency as? RequiredOperationDependency, op.isRequired, dependency.isCancelled {
                debugLog(action: CustomCancelableOperationAction.willCancel(reason: "Required dependecy was canceled."))
                cancel()
                return false
            }
        }

        return true
    }
}

// MARK: - Action logger
extension CustomCancelableOperation: ActionLogger {
    enum CustomCancelableOperationAction: CustomDebugStringConvertible {
        case willExecuteAction(String)
        case willCancel(reason: String)
        case willDeinit

        var debugDescription: String {
            switch self {
                case .willExecuteAction(let actionName):
                    return "💬 performing ➟ \(actionName)"
                case .willCancel(let reason):
                    return "⛔️ canceling because ➟ \(reason)"
                case .willDeinit:
                    return "✅ ➟ will deinit"
            }
        }
    }
}
