//
// Optional (With)
// EE Utilities
//
// Copyright (c) 2016 Eugene Egorov.
// License: MIT, https://github.com/eugeneego/utilities-ios/blob/master/LICENSE
//

public extension Optional {
    @discardableResult
    public func with(_ action: (Wrapped) throws -> Void) rethrows -> Optional {
        if let value = self {
            try action(value)
        }
        return self
    }
}
