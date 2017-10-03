//
// SimpleSubscription
// EE Utilities
//
// Copyright (c) 2016 Eugene Egorov.
// License: MIT, https://github.com/eugeneego/utilities-ios/blob/master/LICENSE
//

open class SimpleSubscription: Subscription {
    private let unsubscribeClosure: () -> Void

    public init(unsubscribeClosure: @escaping () -> Void) {
        self.unsubscribeClosure = unsubscribeClosure
    }

    deinit {
        unsubscribe()
    }

    open func unsubscribe() {
        unsubscribeClosure()
    }
}
