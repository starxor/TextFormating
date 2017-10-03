//
// UIView (Screenshot)
// EE Utilities
//
// Copyright (c) 2015 Eugene Egorov.
// License: MIT, https://github.com/eugeneego/utilities-ios/blob/master/LICENSE
//

import UIKit

public extension UIView {
    public func screenshot(afterUpdate: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: afterUpdate)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("Cannot get image from context for screenshot.")
        }
        UIGraphicsEndImageContext()
        return image
    }
}
