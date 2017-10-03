//
// TimestampLightTransformer
// EE Utilities
//
// Copyright (c) 2015 Eugene Egorov.
// License: MIT, https://github.com/eugeneego/utilities-ios/blob/master/LICENSE
//

import Foundation

public struct TimestampLightTransformer: LightTransformer {
    public typealias T = Date

    private let numberTransformer = CastLightTransformer<Int64>()
    private let scale: TimeInterval

    public init(scale: TimeInterval = 1) {
        self.scale = scale
    }

    public func from(any value: Any?) -> T? {
        return numberTransformer.from(any: value).map { Date(timeIntervalSince1970: TimeInterval($0) * scale) }
    }

    public func to(any value: T?) -> Any? {
        return value.flatMap { numberTransformer.to(any: Int64($0.timeIntervalSince1970 / scale)) }
    }
}
