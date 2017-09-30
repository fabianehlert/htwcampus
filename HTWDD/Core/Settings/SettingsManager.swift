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

private let saveInterval: TimeInterval = 5.seconds
private var saveTimer: Timer?

final class SettingsManager {

    enum Err: Error {
        case typeMismatch(expected: String, got: String)
        case unknownKey(String)
    }

    private enum Const {
        static let userDefaultsKey = "HTW_Settings_Key"

        // keys
        enum Key {
            static let scheduleYear = "scheduleYear"
            static let scheduleMajor = "scheduleMajor"
            static let scheduleGroup = "scheduleGroup"

            static let sNumber = "sNumber"
            static let unixPassword = "unixPassword"
        }
    }

    let sNumber = Setting<String>(Const.Key.sNumber)
    let unixPassword = Setting<String>(Const.Key.unixPassword)

    let scheduleYear = Setting<Int>(Const.Key.scheduleYear)
    let scheduleMajor = Setting<Int>(Const.Key.scheduleMajor)
    let scheduleGroup = Setting<Int>(Const.Key.scheduleGroup)

    private let disposeBag = DisposeBag()

    static let shared = SettingsManager()

    func loadInitial() {
        self.sNumber.settingsManager = self
        self.unixPassword.settingsManager = self

        do {
            try self.load()
        } catch {
            Log.error(error)
        }
        observeNotifications()
    }

    deinit {
        self.save()
    }

    private func observeNotifications() {
        let terminate = NotificationCenter.default.rx.notification(.UIApplicationWillTerminate)
        let background = NotificationCenter.default.rx.notification(.UIApplicationDidEnterBackground)
        let memoryWarning = NotificationCenter.default.rx.notification(.UIApplicationDidReceiveMemoryWarning)

        let merged = Observable.combineLatest(terminate, background, memoryWarning) { _, _, _ in
            return true
        }

        merged.subscribe(onNext: { [weak self] _ in
            self?.save()
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
        case Const.Key.scheduleYear:
            try self.scheduleYear.setValue(value)
        case Const.Key.scheduleMajor:
            try self.scheduleMajor.setValue(value)
        case Const.Key.scheduleGroup:
            try self.scheduleGroup.setValue(value)
        default:
            throw Err.unknownKey(key)
        }
    }

    @objc
    func save() {
        var object = [String: Any]()

        object[self.sNumber.key] = self.sNumber.value
        object[self.unixPassword.key] = self.unixPassword.value
        object[self.scheduleYear.key] = self.scheduleYear.value
        object[self.scheduleMajor.key] = self.scheduleMajor.value
        object[self.scheduleGroup.key] = self.scheduleGroup.value

        guard let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) else {
            Log.error("Failed at saving settings to user defaults")
            return
        }
        // TODO: Don't use user defaults for sensitive information!
        UserDefaults.standard.set(data, forKey: Const.userDefaultsKey)
    }

}

final class Setting<T> {

    let key: String
    init(_ key: String) {
        self.key = key
    }

    fileprivate weak var settingsManager: SettingsManager?

    var value: T? {
        didSet {
            saveTimer?.invalidate()
            guard let manager = self.settingsManager else {
                return
            }
            saveTimer = Timer.scheduledTimer(timeInterval: saveInterval, target: manager, selector: #selector(SettingsManager.save), userInfo: nil, repeats: false)
        }
    }

    fileprivate func setValue(_ newValue: Any) throws {
        if let n = newValue as? T {
            self.value = n
        } else {
            throw SettingsManager.Err.typeMismatch(expected: String(describing: T.self), got: Log.typeAsString(newValue))
        }
    }

}
