//
//  MultiSwitch.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 28.11.2017.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import UIKit

class MultiSwitch: UIControl {
    private let _defaultHeight: CGFloat = 36.0

    // MARK: - Subviews
    private let slider = DraggableControl()
    private let optionsContainer = UIView()
    private let backgroundView = UIView()
    private let optionsStack = UIStackView()

    struct Option {
        var title: String
    }

    var options: [Option] = [] {
        didSet {
            update(for: options)
        }
    }

    // MARK: - Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        customInit()
    }

    override var intrinsicContentSize: CGSize {
        // empty slider
        return CGSize(width: _defaultHeight, height: _defaultHeight)
    }

    // MARK: - Private methods
    private func customInit() {
        optionsContainer.frame = self.bounds
        self.addSubview(optionsContainer)

        // background
        layer.cornerRadius = floor(self.bounds.height / 2.0)
        layer.masksToBounds = true
        backgroundView.backgroundColor = UIColor.red//UIColor(white: 0.698, alpha: 1.0)
        backgroundView.frame = self.bounds
        optionsContainer.addSubview(backgroundView)

        // options stack
        optionsStack.frame = self.bounds
        optionsContainer.addSubview(optionsStack)
        optionsStack.alignment = .center
        optionsStack.axis = .horizontal
        optionsStack.distribution = .fillEqually

        // slider
        self.addSubview(slider)
        let frame = CGRect(x: 0, y: 0, width: _defaultHeight - 1, height: self.bounds.height - 2)
        slider.frame = frame
        var center = slider.center
        center.y = self.bounds.midY
        slider.center = center
        slider.backgroundColor = UIColor.white

        slider.onDrag = { [unowned self] deltaX, deltaY in
            self.userHadMovedSlider(for: CGPoint(x: deltaX, y: deltaY))
        }

        slider.layer.cornerRadius = floor(slider.bounds.height / 2.0)
        slider.layer.masksToBounds = true

    }

    private func userHadMovedSlider(for offset: CGPoint) {
        var center = slider.center
        let target = center.x + offset.x
        let maxX = (self.bounds.width - 1) - slider.bounds.width / 2
        let minX = 1 + slider.bounds.width / 2
        let result = min(max(target, minX), maxX)
        center.x = result
        slider.center = center
    }

    func update(for options: [Option]) {
        for view in optionsStack.arrangedSubviews {
            optionsStack.removeArrangedSubview(view)
        }

        var frame = slider.frame
        frame.size.width = (self.bounds.width - 2) / CGFloat(options.count)
        slider.frame = frame

        for option in options {
            let optionButton = UIButton(type: .custom)
            optionButton.setTitle(option.title, for: .normal)
            optionButton.setTitleColor(UIColor.white, for: .normal)
            optionsStack.addArrangedSubview(optionButton)
        }
    }
}

class DraggableControl: UIControl {
    /// @param1 - deltaX
    /// @param2 - deltaY
    typealias DragHandler = (_ deltaX: CGFloat, _ deltaY: CGFloat) -> Void

    /// @param1 - touch
    /// @param2 - event
    typealias UserInteractionHanlder = (_ touch: UITouch?, _ event: UIEvent?) -> Void

    var onInteranctionStart: (UserInteractionHanlder)?
    var onDrag: (DragHandler)?
    var onInteranctionEnd: (UserInteractionHanlder)?

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard
            let view = touch.view,
            view === self
            else { return false }

        print("\(type(of: self)).\(#function)")
        onInteranctionStart?(touch, event)
        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard let view = touch.view, view === self else { return false }

        updateSlider(forTouchPosition: touch.location(in: self), previousPosition: touch.previousLocation(in: self))
        self.setNeedsDisplay()
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        onInteranctionEnd?(touch, event)
    }

    private func updateSlider(forTouchPosition position: CGPoint, previousPosition previous: CGPoint) {
        let deltaX = position.x - previous.x
        let deltaY = position.y - previous.y

        onDrag?(deltaX, deltaY);
    }

    override func draw(_ rect: CGRect) {

        guard
            let view = self.superview?.subviews[0],
            let ctx = UIGraphicsGetCurrentContext()
        else { return }

        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let cg = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return }
        UIGraphicsEndImageContext()

        var cMask : [CGFloat] = []

        let img = UIImage(cgImage: cg)

        guard
            let data = UIImageJPEGRepresentation(img, 1.0),
            let toCopy = UIImage(data: data)?.cgImage
        else { return }

        cMask = [255, 0, 0, 0, 255, 0]
        guard let masked = toCopy.copy(maskingColorComponents: cMask) else { return }

        ctx.draw(masked, in: rect)
    }
}
