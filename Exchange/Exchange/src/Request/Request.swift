//
//  Request.swift
//  Exchange
//
//  Created by R on 02.09.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

class Request {
    
    static var requestTimeout: TimeInterval = 60
    static var responseTimeout: TimeInterval = 60
    static var isPretty = true
    #if DEBUG
    static var isDebug = true
    #endif
    
    enum Method {
        case get
        case post
        case put
        case patch
        case delete
        case custom(String)
    }
    
    enum RequestType {
        case none
        case text(String)
        case json([String: Any])
        case jsonData(Data)
        case custom(String, Data?)
    }
    
    enum ResponseType {
        case data
        case text(String.Encoding)
        case json
    }
    
    enum Error: Swift.Error {
        case urlNotSpecified
        case emptyResponse
        case parseFailed
        case server(Int, Data?, URLResponse?)
    }
    
    public enum Result {
        case success(Any?)
        case error(Error)
    }
    
    static var session: URLSession?
    
    typealias ResultClosure = (_ result: Result) -> Void
    
    static func get(_ url: String, query: [String: Any]? = nil, type: RequestType = .none, responseType: ResponseType = .data, headers: [String: Any]? = nil, result: ResultClosure? = nil) {
        request(url, query: query, method: .get, type: type, responseType: responseType, headers: headers, result: result)
    }
    
    static func post(_ url: String, query: [String: Any]? = nil, type: RequestType = .none, responseType: ResponseType = .data, headers: [String: Any]? = nil, result: ResultClosure? = nil) {
        request(url, query: query, method: .post, type: type, responseType: responseType, headers: headers, result: result)
    }
    
    static func delete(_ url: String, query: [String: Any]? = nil, type: RequestType = .none, responseType: ResponseType = .data, headers: [String: Any]? = nil, result: ResultClosure? = nil) {
        request(url, query: query, method: .delete, type: type, responseType: responseType, headers: headers, result: result)
    }
    
    static func put(_ url: String, query: [String: Any]? = nil, type: RequestType = .none, responseType: ResponseType = .data, headers: [String: Any]? = nil, result: ResultClosure? = nil) {
        request(url, query: query, method: .put, type: type, responseType: responseType, headers: headers, result: result)
    }
    
    static func patch(_ url: String, query: [String: Any]? = nil, type: RequestType = .none, responseType: ResponseType = .data, headers: [String: Any]? = nil, result: ResultClosure? = nil) {
        request(url, query: query, method: .patch, type: type, responseType: responseType, headers: headers, result: result)
    }
    
    static func request(_ url: String, query: [String: Any]? = nil, method: Method = .get, type: RequestType = .none, responseType: ResponseType = .data, headers: [String: Any]? = nil, result: ResultClosure? = nil) {
        guard let url = URL(string: url) else {
            result?(.error(.urlNotSpecified))
            return
        }
        request(url, query: query, method: method, type: type, responseType: responseType, headers: headers, result: result)
    }
    
    static func request(_ url: URL, query: [String: Any]? = nil, method: Method = .get, type: RequestType = .none, responseType: ResponseType = .data, headers: [String: Any]? = nil, result: ResultClosure? = nil) {
        
        let request = NSMutableURLRequest(url: url)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Request.requestTimeout
        configuration.timeoutIntervalForResource = Request.responseTimeout
        let session = Request.session ?? URLSession(configuration: configuration)
        
        if let query = query {
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                result?(.error(.urlNotSpecified))
                return
            }
            var queryItems: [URLQueryItem] = []
            for (key, value) in query {
                if let value = value as? Array<Any> {
                    for value in value {
                        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                    }
                } else {
                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            components.queryItems = queryItems
            request.url = components.url
        }
        
        switch method {
        case .get:
            request.httpMethod = "GET"
        case .post:
            request.httpMethod = "POST"
        case .put:
            request.httpMethod = "PUT"
        case .patch:
            request.httpMethod = "PATCH"
        case .delete:
            request.httpMethod = "DELETE"
        case .custom(let name):
            request.httpMethod = name.uppercased()
        }
        
        #if DEBUG
        if isDebug {
            print("request - \(request.httpMethod) \(request.url?.absoluteString ?? "")")
        }
        #endif
        
        headers?.forEach() { arg in
            let (key, value) = arg
            request.addValue("\(value)", forHTTPHeaderField: key)
            #if DEBUG
            if isDebug {
                print("request - header \(key): \(value)")
            }
            #endif
        }
        
        switch type {
        case .none: break
        case .text(let text):
            request.httpBody = text.data(using: .utf8)
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            #if DEBUG
            if isDebug {
                print("request - text\n\(text)")
            }
            #endif
        case .json(let params):
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: Request.isPretty ? .prettyPrinted : [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            #if DEBUG
            if isDebug,
                let data = request.httpBody {
                print("request - json\n\(String(data: data, encoding: .utf8) ?? "")")
            }
            #endif
        case .jsonData(let data):
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            #if DEBUG
            if isDebug,
                let data = request.httpBody {
                print("request - json\n\(String(data: data, encoding: .utf8) ?? "")")
            }
            #endif
        case .custom(let type, let data):
            request.httpBody = data
            request.addValue(type, forHTTPHeaderField: "Content-Type")
            #if DEBUG
            if isDebug {
                print("request - \(type) data length \(data?.count ?? 0)")
            }
            #endif
        }
        
        session.dataTask(with: request as URLRequest) { data, response, error -> Void in
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            #if DEBUG
            if isDebug {
                print("response - \(statusCode) data length \(data?.count ?? 0)")
            }
            #endif
            
            if 200..<300 ~= statusCode {
                switch responseType {
                case .data:
                    result?(.success(data))
                case .text(let encoding):
                    if let data = data {
                        if let text = String(data: data, encoding: encoding) {
                            #if DEBUG
                            if isDebug {
                                print("response - text\n\(text)")
                            }
                            #endif
                            result?(.success(text))
                        } else {
                            result?(.error(.parseFailed))
                        }
                    } else {
                        result?(.error(.emptyResponse))
                    }
                case .json:
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with:
                                data, options: [])
                            #if DEBUG
                            if isDebug {
                                print("response - json\n\(String(data: data, encoding: .utf8) ?? "")")
                            }
                            #endif
                            result?(.success(json))
                        } catch {
                            result?(.error(.parseFailed))
                        }
                    } else {
                        result?(.error(.emptyResponse))
                    }
                }
            } else {
                result?(.error(.server(statusCode, data, response)))
            }
        }.resume()
    }
}
