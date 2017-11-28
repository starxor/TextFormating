//
//  CustomButton.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 08.11.2017.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit

@IBDesignable
@objc
class CustomButton: UIControl {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

    override func draw(_ rect: CGRect) {
        // Drawing code
        print("\(#line) - \(#function)")
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        ctx.setStrokeColor(defaultColor?.cgColor ?? UIColor.white.cgColor)
        let rect = bounds.insetBy(dx: 4, dy: 4)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 8)
        ctx.addPath(path.cgPath)
        ctx.strokePath()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    override func sendActions(for controlEvents: UIControlEvents) {
        print(controlEvents)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64)
    }

    @IBInspectable var defaultTitle: String?
    @IBInspectable var defaultColor: UIColor?

    @IBInspectable var isHighlightedState: Bool = false
    @IBInspectable var highlighthedTitle: String?
    @IBInspectable var highlighthedColor: UIColor?

    @IBInspectable var selectedState: Bool = false
    @IBInspectable var selectedTitle: String?
    @IBInspectable var selectedColor: UIColor?
}
