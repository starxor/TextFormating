//
//  IntroViewController.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 18.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIPageViewControllerDataSource {

    enum Segues {
        static var embedPageVC = "embedPageVC"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var onExitClosure: () -> Void = {}

    private var pageVC: UIPageViewController!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.embedPageVC, let dest = segue.destination as? UIPageViewController {
            self.pageVC = dest
            configure(dest)
        }
    }

    func configure(_ pageViewController: UIPageViewController) {
        pageViewController.dataSource = self
        pageViewController.setViewControllers([pageOneVC], direction: .forward, animated: true, completion: nil)
    }

    // MARK: Page controller data source

    enum PagesSBIDs {
        static var pageOne = "IntroPageOne"
        static var pageTwo = "IntroPageTwo"
    }

    lazy var pageOneVC: IntroPageViewController = {
        let pageOne = UIStoryboard(
            name: AppStoryboards.intro, bundle: nil).instantiateViewController(withIdentifier: PagesSBIDs.pageOne
        ) as? IntroPageViewController
        pageOne?.customAction = { [unowned self] in
            self.pageVC.setViewControllers([self.pageTwoVC], direction: .forward, animated: true, completion: nil)
        }
        return pageOne ?? IntroPageViewController()
    }()

    lazy var pageTwoVC: IntroPageViewController = {
        let pageTwo = UIStoryboard(
            name: AppStoryboards.intro, bundle: nil).instantiateViewController(withIdentifier: PagesSBIDs.pageTwo
            ) as? IntroPageViewController
        pageTwo?.customAction = { [unowned self] in
            self.onExitClosure()
        }
        return pageTwo ?? IntroPageViewController()
    }()

    func pageViewController(
        _ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isEqual(pageTwoVC) {
            return pageOneVC
        }

        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isEqual(pageOneVC) {
            return pageTwoVC
        }
        return nil
    }
}
