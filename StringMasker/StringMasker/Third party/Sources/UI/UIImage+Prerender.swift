//
// UIImage (Prerender)
// EE Utilities
//
// Copyright (c) 2015 Eugene Egorov.
// License: MIT, https://github.com/eugeneego/utilities-ios/blob/master/LICENSE
//

import UIKit

public extension UIImage {
    public func prerender() {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0)
        draw(at: .zero)
        UIGraphicsEndImageContext()
    }

    public func prerenderedImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("Cannot get image from context for prerender.")
        }
        UIGraphicsEndImageContext()
        return image
    }
}
