//
//  Settings.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsManager {

    enum Err: Error {
        case typeMismatch(expected: String, got: String)
        case unknownKey(String)
    }

    private enum Const {
        static let userDefaultsKey = "HTW_Settings_Key"

        // keys
        enum Key {
            static let sNumber = "sNumber"
            static let unixPassword = "unixPassword"
        }
    }

    private(set) var sNumber = Setting<String>()
    private(set) var unixPassword = Setting<String>()

    private let disposeBag = DisposeBag()

    static let shared = SettingsManager()

    func loadInitial() {
        do {
            try self.load()
        } catch {
            Log.error(error)
        }
        observeNotifications()
    }

    private func observeNotifications() {
        let terminate = NotificationCenter.default.rx.notification(.UIApplicationWillTerminate)
        let background = NotificationCenter.default.rx.notification(.UIApplicationDidEnterBackground)
        let memoryWarning = NotificationCenter.default.rx.notification(.UIApplicationDidReceiveMemoryWarning)

        let merged = Observable.combineLatest(terminate, background, memoryWarning) { _, _, _ in
            return true
        }

        merged.subscribe(onNext: { [weak self] _ in
            do {
                try self?.save()
            } catch {
                Log.error(error)
            }
        }).addDisposableTo(self.disposeBag)
    }

    private func load() throws {
        guard
            let data = UserDefaults.standard.object(forKey: Const.userDefaultsKey) as? Data,
            let values = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        else {
            return
        }

        for (key, value) in values {
            try self.set(value: value, for: key)
        }
    }

    private func set(value: Any, for key: String) throws {
        switch key {
        case Const.Key.sNumber:
            try self.sNumber.setValue(value)
        case Const.Key.unixPassword:
            try self.unixPassword.setValue(value)
        default:
            throw Err.unknownKey(key)
        }
    }

    func save() throws {
        var object = [String: Any]()
        object[Const.Key.sNumber] = self.sNumber.value
        object[Const.Key.unixPassword] = self.unixPassword.value

        let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) // for better readability
        UserDefaults.standard.set(data, forKey: Const.userDefaultsKey)
    }

}

struct Setting<T> {

    private(set) var value: T?

    fileprivate mutating func setValue(_ newValue: Any) throws {
        if let n = newValue as? T {
            self.value = n
        } else {
            throw SettingsManager.Err.typeMismatch(expected: String(describing: T.self), got: Log.typeAsString(newValue))
        }
    }

}
