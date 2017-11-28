//
//  ViewController.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.08.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet var webView: WKWebView!

    var onReady: () -> Void = {}

    let opQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = view.subviews.first as? MultiSwitch else { return }

        view.options = [MultiSwitch.Option(title: "Мои"), MultiSwitch.Option(title: "На меня"), MultiSwitch.Option(title: "В поиске")]
//
//        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//        animation.fromValue = 0
//        let full = CGFloat.pi * 2
//        animation.toValue = NSNumber(value: Double(full))
//        animation.isCumulative = true
//        animation.repeatCount = .greatestFiniteMagnitude
//        animation.duration = 1
//
//        view.layer.add(animation, forKey: "RotationAnimationKey")
        // Do any additional setup after loading the view, typically from a nib.
//        textFieldController = TextFieldController(
//            textField: textField,
//            asYouTypeFormatter: PhoneNumberFormatter(predefinedAreaCode: 7, maxNumberLength: 10)
//        )

//        opQueue.qualityOfService = .default

//        let op1 = TestOperation(label: "OP1")
//        let op2 = TestOperation(label: "OP2")
//        let op3 = TestOperation(label: "OP3")
//        let op4 = TestOperation(label: "OP4")
//        let op5 = TestOperation(label: "OP5")
//
//        op3.isRequired = true
//        op4.isRequired = true
//
//        op2.addDependency(op1)
//        op3.addDependency(op2)
//        op4.addDependency(op3)
//        op5.addDependency(op4)
//
//        opQueue.addOperations([op1, op2, op3, op4, op5], waitUntilFinished: false)

//        let testPath = "https://images7.alphacoders.com/320/320986.jpg"
//        let op6 = NetworkDownloadOperation(url: URL(string: testPath)!, label: "TestDownload")
//        let op7 = NetworkDownloadOperation(url: URL(string: testPath)!, label: "TestDownload2")

//        opQueue.addOperation(op6)
//        opQueue.addOperation(op7)

//        let oneSecond = DispatchTime.now() + DispatchTimeInterval.seconds(1)
//        DispatchQueue.main.asyncAfter(deadline: oneSecond) {
//            op2.cancel()
//            op4.cancel()
//        }

//        let config = WKWebViewConfiguration()
//        webView = WKWebView(frame: view.frame, configuration: config)
//        view.addSubview(webView)
//
//        webView.navigationDelegate = self
//
//        guard let url = URL(string: "https://alfastrah.ru") else { assert(false, "Broken URL") }
//
//        let req = URLRequest(url: url)
//
//        webView.load(req)
//
//        webViewLoading = webView
//            .observe(\.estimatedProgress, options: NSKeyValueObservingOptions.new) { webView, change in
//                guard let newValue = change.newValue else { return }
//
//                print("newValue: \(newValue)")
//        }

    }

    private var webViewLoading: NSKeyValueObservation!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onReady()
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(#line), \(#function)")
        print("\(navigation)")
        print("\(webView.url)")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\(#line), \(#function)")
        print("\(navigation)")
        print("\(webView.url)")
    }
}
