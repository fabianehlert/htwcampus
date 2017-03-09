//
//  Network.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 04/01/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Marshal

enum Network {

    enum ParameterEncoding {
        case url, json
    }

    enum Error: Swift.Error {
        case wrongType(expected: Any, got: Any)
    }

    private static func data(parameters: [String: String], encoding: ParameterEncoding) -> Data? {
        switch encoding {
        case .json:
            return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        case .url:
            return parameters.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
        }
    }

    private static func get(url: String, params: [String: String]) -> Observable<Any?> {

        let p = params.map { "\($0)=\($1)" }
        guard let url = URL(string: "\(url)?\(p.joined(separator: "&"))") else {
            return Observable.just(nil)
        }

        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)

        return URLSession.shared.rx.json(request: req).map { $0 as Any? }
    }

    static func get<T: Unmarshaling>(url: String, params: [String: String] = [:]) -> Observable<T> {
        return get(url: url, params: params).map(self.mapSingleObject)
    }

    static func getArray<T: Unmarshaling>(url: String, params: [String: String] = [:]) -> Observable<[T]> {
        return get(url: url, params: params).map(self.mapArray)
    }

    private static func post(url: String, params: [String: String], encoding: ParameterEncoding) -> Observable<Any?> {

        guard let u = URL(string: "\(url)") else {
            return Observable.just(nil)
        }

        var r = URLRequest(url: u, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        r.httpBody = data(parameters: params, encoding: encoding)
        r.httpMethod = "POST"
        if encoding == .json {
            r.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return URLSession.shared.rx.json(request: r).map { $0 as Any? }
    }

    static func post<T: Unmarshaling>(url: String, params: [String: String] = [:], encoding: ParameterEncoding = .json) -> Observable<T> {
        return post(url: url, params: params, encoding: encoding).map(self.mapSingleObject)
    }

    static func postArray<T: Unmarshaling>(url: String, params: [String: String] = [:], encoding: ParameterEncoding = .json) -> Observable<[T]> {
        return post(url: url, params: params, encoding: encoding).map(self.mapArray)
    }

    private static func mapSingleObject<T: Unmarshaling>(json: Any?) throws -> T {
        guard let jsonObject = json as? [String: Any] else {
            throw Error.wrongType(expected: [String: Any].self, got: type(of: json))
        }
        return try T(object: jsonObject)
    }

    private static func mapArray<T: Unmarshaling>(json: Any?) throws -> [T] {
        guard let jsonArray = json as? [[String: Any]] else {
            throw Error.wrongType(expected: [[String: Any]].self, got: type(of: json))
        }
        return try jsonArray.map(T.init)
    }
}
