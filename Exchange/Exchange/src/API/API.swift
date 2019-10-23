//
// API.swift
// Exchange
//
// Created by R on 02.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import Foundation

final class API {
    
    static func currencies(exchange: [Exchange], result: @escaping Request.ResultClosure) {
        let params = exchange.map { $0.first! + $0.second! }
        Request.get(Settings.server, query: ["pairs": params], responseType: .json) { response in
            switch response {
            case .success(let data):
                if let values = data as? [String: Double] {
                    result(.success(values))
                } else {
                    result(.error(.parseFailed))
                }
            case .error(let error):
                result(.error(error))
            }
        }
    }
}

