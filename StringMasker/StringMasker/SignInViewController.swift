//
//  SignInViewController.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 21.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var onLogIn: ((String?, String?) -> Void)?

    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    @IBAction func logIn() {
        onLogIn?(loginTextField.text, passwordTextField.text)
    }

}
