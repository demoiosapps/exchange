//
// APITests.swift
//
// Created by R on 20.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import XCTest

class APITests: XCTestCase {
    
    override func setUp() {
        DataService.defineInMemoryContainer()
        DataService.addExchange(first: "USD", second: "RUB", value: 1)
        Request.session = URLSessionMock()
    }
    
    override func tearDown() {
        DataService.clear()
        Request.session = nil
    }
    
    func testCurrencies() {
        let content = "{\"USDRUB\": 2.0}".data(using: .utf8)
        (Request.session as! URLSessionMock).data = content
        let expectation = self.expectation(description: "currencies")
        API.currencies(exchange: DataService.exchange()) { response in
            switch response {
            case .success(let data):
                if let dict = data as? [String: Double] {
                    XCTAssertEqual(dict.count, 1)
                    XCTAssertEqual(dict["USDRUB"], 2.0)
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            case .error:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testCurrenciesFail() {
        let content = "Text".data(using: .utf8)
        (Request.session as! URLSessionMock).data = content
        let expectation = self.expectation(description: "currencies")
        API.currencies(exchange: DataService.exchange()) { response in
            switch response {
            case .success:
                XCTFail()
            case .error(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
}

