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
    func start()
}


enum AppStoryboards {
    static var main = "Main"
    static var intro = "Intro"
    static var guestMode = "GuestMode"
    static var signIn = "SignIn"
    static var signUp = "SignUp"
    static var signInSettings = "SignInSettings"
    static var userMode = "UserMode"
}
