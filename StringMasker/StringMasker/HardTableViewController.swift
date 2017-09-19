//
//  HardTableViewController.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 19.09.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit

class HardTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "SuperHardCell", for: indexPath)
    }

    var cellHeights: [IndexPath : CGFloat] = [:]

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cellHeights[indexPath] {
            return height
        } else {
            let height = CGFloat(arc4random_uniform(250) + 150)
            cellHeights[indexPath] = height
            return height
        }

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(#function), \(#line)")
        print("\(NSStringFromCGPoint(scrollView.contentOffset))")
        if let visible = tableView.indexPathsForVisibleRows {
            for path in visible {
                print(tableView.cellForRow(at: path) ?? "No cell for \(path)")
            }
        }

        print("============================================================\n\n\n")
    }
}

class SuperHardCell: UITableViewCell {
    @IBOutlet private var topLabel: UILabel!
    @IBOutlet private var bottomLabel: UILabel!
    @IBOutlet private var dot: UIImageView!
    @IBOutlet private var dotCenterY: NSLayoutConstraint!
}
