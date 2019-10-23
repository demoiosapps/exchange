//
//  UpdateService.swift
//  Exchange
//
//  Created by R on 08.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

final class UpdateService {

    private static var timer: Timer?
    
    static func start() {
        timer = Timer.scheduledTimer(withTimeInterval: Settings.updateInterval, repeats: true) { _ in
            update()
        }
        timer?.fire()
    }
    
    static func stop() {
        timer?.invalidate()
    }
    
    private static func update() {
        let exchange = DataService.exchange()
        if exchange.count > 0 {
            DispatchQueue.global(qos: .userInitiated).async {
                API.currencies(exchange: exchange) { response in
                    if case .success(let data) = response,
                        let values = data as? [String: Double] {
                        DataService.exchange().forEach {
                            if let value = values[$0.first! + $0.second!] {
                                $0.value = value
                            }
                        }
                    }
                }
            }
        }
    }
}
