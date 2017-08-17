//
//  AlfaApplicationController.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 14.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

final class AlfaAppFlowCoordinator {
    required init(rootContainer: ViewControllerContainer) {
        self.rootContainer = rootContainer
    }

    // MARK: Private
    fileprivate var rootContainer: ViewControllerContainer
}

// MARK: Logic
fileprivate extension AlfaAppFlowCoordinator {
}

// MARK: Types
fileprivate extension AlfaAppFlowCoordinator {
    enum AuthenticationType: Equatable {
        case credentials
        case pin(remainingAttempts: Int)
        case touchID
        case auto

        static func == (lhs: AuthenticationType, rhs: AuthenticationType) -> Bool {
            switch (lhs, rhs) {
            case (.credentials, .credentials), (.touchID, .touchID), (.auto, .auto): return true
            case (.pin(let lhsAttempts), .pin(let rhsAttempts)): return lhsAttempts == rhsAttempts
            default: return false
            }
        }
    }

    enum AuthorizationStatus: Equatable {
        case authorized(AuthenticationType)
        case guest

        static func == (lhs: AuthorizationStatus, rhs: AuthorizationStatus) -> Bool {
            switch (lhs, rhs) {
                case (.authorized(let lhsType), .authorized(let rhsType)): return lhsType == rhsType
                case (.guest, .guest): return true
                default: return false
            }
        }
    }

    struct ApplicationStateDescriptor {
        var isFirstLaunch: Bool
        var authStatus: AuthorizationStatus
    }
}
