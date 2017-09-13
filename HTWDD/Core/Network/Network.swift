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

public class Network {

    /// Errors that can occur during network requests.
    ///
    /// - invalidURL: the given or created url was not valid.
    /// - wrongType: the mapping failed
    public enum Error: Swift.Error {
        case invalidURL(String)
        case wrongType(expected: Any.Type, got: Any.Type)
    }

    /// The authenticator thats used (or nil if no authentication)
    public let authenticator: Authenticator?

    /// Initialize a new instance of Network.
    ///
    /// - Parameter authenticator: optional authenticator for HTTP authentication
    public init(authenticator: Authenticator? = nil) {
        self.authenticator = authenticator
    }

    // MARK: - GET

    private func get(url: String, params: [String: String]) -> Observable<Any> {

        let p: [String] = params.map { $0.key + "=" + $0.value }
        let joinedParameters = p.joined(separator: "&")
        let urlString = url + "?" + joinedParameters
        guard let url = URL(string: urlString) else {
            return Observable.error(Error.invalidURL(urlString))
        }

        var req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        self.authenticator?.authenticate(request: &req)
        return URLSession.shared.rx.json(request: req).map { $0 as Any }
    }

    /// get a single object as response.
    ///
    /// - Parameters:
    ///   - url: url to load the object from
    ///   - params: optional parameters to add to the url
    /// - Returns: Observable containing the loaded object
    public func get<T: Unmarshaling>(url: String, params: [String: String] = [:]) -> Observable<T> {
        return get(url: url, params: params).map(self.mapSingleObject)
    }

    /// get an array of objects as response
    ///
    /// - Parameters:
    ///   - url: url to load the object from
    ///   - params: optional parameters to add to the url
    /// - Returns: Observable containing the loaded objects
    public func getArray<T: Unmarshaling>(url: String, params: [String: String] = [:]) -> Observable<[T]> {
        return get(url: url, params: params).map(self.mapArray)
    }

    // MARK: - POST

    private func post(url: String, params: Parameter) -> Observable<Any> {

        guard let u = URL(string: url) else {
            return Observable.error(Error.invalidURL(url))
        }

        var req = URLRequest(url: u, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        req.httpBody = params.data
        req.httpMethod = "POST"
        if let contentType = params.contentType {
            req.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        self.authenticator?.authenticate(request: &req)

        return URLSession.shared.rx.json(request: req).map { $0 as Any }
    }

    /// post a request and expect a single object as response
    ///
    /// - Parameters:
    ///   - url: url to load the object from
    ///   - params: parameters to attach to the request (http body)
    /// - Returns: Observable containing the loaded object
    public func post<T: Unmarshaling>(url: String, params: Parameter) -> Observable<T> {
        return post(url: url, params: params).map(self.mapSingleObject)
    }

    /// post a request and expect an array of objects as response
    ///
    /// - Parameters:
    ///   - url: url to load the object from
    ///   - params: parameters to attach to the request (http body)
    /// - Returns: Observable containing the loaded objects
    public func postArray<T: Unmarshaling>(url: String, params: Parameter) -> Observable<[T]> {
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
