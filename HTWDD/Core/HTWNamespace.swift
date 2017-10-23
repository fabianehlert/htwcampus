//
//  HTWNamespace.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 19.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

// shamelessly copied from https://github.com/ReactiveX/RxSwift/blob/master/RxSwift/Reactive.swift

public struct HTWNamespace<Base> {

    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

public protocol HTWNamespaceCompatible {

    associatedtype CompatibleType

    static var htw: HTWNamespace<CompatibleType>.Type { get set }

    var htw: HTWNamespace<CompatibleType> { get set }
}

extension HTWNamespaceCompatible {

    public static var htw: HTWNamespace<Self>.Type {
        get {
            return HTWNamespace<Self>.self
        }
        set {}
    }

    public var htw: HTWNamespace<Self> {
        get {
            return HTWNamespace(self)
        }
        set {}
    }
}

import class Foundation.NSObject

/// Extend NSObject with `htw` proxy.
extension NSObject: HTWNamespaceCompatible { }
