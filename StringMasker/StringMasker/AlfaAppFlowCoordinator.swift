//
//  AlfaApplicationController.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 14.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

final class AlfaAppFlowCoordinator: ApplicationController {
    required init(rootContainer: ViewControllerContainer) {
        self.rootContainer = rootContainer
        self.initialSetup()
    }

    // MARK: Private
    fileprivate var flowCoordinators: [FlowCoordinator] = []

    fileprivate var rootContainer: ViewControllerContainer

    // MARK: Coordinators
    func introCoordinator() -> IntroductionFlowCoordinator {
        let intro = IntroductionFlowCoordinator(navigationRoot: rootContainer)
        return intro
    }

    func authCoordinator() -> AuthorizationFlowCoordinator {
        return AuthorizationFlowCoordinator(navigationRoot: rootContainer)
    }

    func guestCoordinator() -> GuestFlowCoordinator {
        return GuestFlowCoordinator(navigationRoot: rootContainer)
    }
}

// MARK: Logic
fileprivate extension AlfaAppFlowCoordinator {
    var initialState: ApplicationState {
        guard let stored = getStoredInitialState() else { return .intro }

        return stored
    }

    func initialSetup() {
        let state = initialState
        let initialCoord = flowCoordinator(for: state)
        initialCoord.start()
    }

    func flowCoordinator(for initialState: ApplicationState) -> FlowCoordinator {
        switch initialState {
            case .auth: return authCoordinator()
            case .guest: return guestCoordinator()
            case .intro: return introCoordinator()
        }
    }

    func getStoredInitialState() -> ApplicationState? {
        // TODO: Request this from service
        return .intro
    }
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
