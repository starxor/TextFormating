//
//  IntroPageViewController.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 18.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit

class IntroPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var customAction: () -> Void = {}

    @IBAction func buttonAction() {
        customAction()
    }
}
