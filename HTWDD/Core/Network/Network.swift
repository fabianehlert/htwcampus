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

class Network {

    enum Parameter {
        case none
        case url([String: String])
        case json(Any)

        var data: Data? {
            switch self {
            case .none:
                return nil
            case .url(let dic):
                return dic.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
            case .json(let obj):
                return try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
            }
        }

        var contentType: String? {
            switch self {
            case .json(_): return "application/json"
            default: return nil
            }
        }
    }

    enum Error: Swift.Error {
        case invalidURL(String)
        case wrongType(expected: Any, got: Any)
    }

    private func get(url: String, params: [String: String]) -> Observable<Any> {

        let p = params.map { "\($0)=\($1)" }
        let urlString = "\(url)?\(p.joined(separator: "&"))"
        guard let url = URL(string: urlString) else {
            return Observable.error(Error.invalidURL(urlString))
        }

        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)

        return URLSession.shared.rx.json(request: req).map { $0 as Any }
    }

    func get<T: Unmarshaling>(url: String, params: [String: String] = [:]) -> Observable<T> {
        return get(url: url, params: params).map(self.mapSingleObject)
    }

    func getArray<T: Unmarshaling>(url: String, params: [String: String] = [:]) -> Observable<[T]> {
        return get(url: url, params: params).map(self.mapArray)
    }

    private func post(url: String, params: Parameter) -> Observable<Any> {

        guard let u = URL(string: url) else {
            return Observable.error(Error.invalidURL(url))
        }

        var r = URLRequest(url: u, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        r.httpBody = params.data
        r.httpMethod = "POST"
        if let contentType = params.contentType {
            r.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        return URLSession.shared.rx.json(request: r).map { $0 as Any }
    }

    func post<T: Unmarshaling>(url: String, params: Parameter) -> Observable<T> {
        return post(url: url, params: params).map(self.mapSingleObject)
    }

    func postArray<T: Unmarshaling>(url: String, params: Parameter) -> Observable<[T]> {
        return post(url: url, params: params).map(self.mapArray)
    }

    private func mapSingleObject<T: Unmarshaling>(json: Any) throws -> T {
        guard let jsonObject = json as? [String: Any] else {
            throw Error.wrongType(expected: [String: Any].self, got: type(of: json))
        }
        return try T(object: jsonObject)
    }

    private func mapArray<T: Unmarshaling>(json: Any) throws -> [T] {
        guard let jsonArray = json as? [[String: Any]] else {
            throw Error.wrongType(expected: [[String: Any]].self, got: type(of: json))
        }
        return try jsonArray.map(T.init)
    }
}
