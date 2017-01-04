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

protocol JSONInitializable {
    init?(json: Any?)
}

enum Network {

    enum ParameterEncoding {
        case url, json
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

    static func get<T: JSONInitializable>(url: String, params: [String: String] = [:]) -> Observable<T?> {
        return get(url: url, params: params).map { T(json: $0) }
    }

    static func getArray<T: JSONInitializable>(url: String, params: [String: String] = [:]) -> Observable<[T]> {
        return get(url: url, params: params).map { ($0 as? [Any])?.flatMap(T.init) ?? [] }
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

    static func post<T: JSONInitializable>(url: String, params: [String: String] = [:], encoding: ParameterEncoding = .json) -> Observable<T?> {
        return post(url: url, params: params, encoding: encoding).map { T(json: $0) }
    }

    static func postArray<T: JSONInitializable>(url: String, params: [String: String] = [:], encoding: ParameterEncoding = .json) -> Observable<[T]> {
        return post(url: url, params: params, encoding: encoding).map { ($0 as? [Any])?.flatMap(T.init) ?? [] }
    }

}
