//
// ExchangeCellTests.swift
//
// Created by R on 20.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import XCTest

class ExchangeCellTests: XCTestCase {
    
    override func setUp() {
        DataService.defineInMemoryContainer()
        DataService.addExchange(first: "USD", second: "RUB", value: 1.0102)
    }
    
    override func tearDown() {
        DataService.clear()
    }

    func testPrepare() {
        let cell = ExchangeCell()
        let firstValueLabel = UILabel()
        let firstNameLabel = UILabel()
        let secondValueLabel = UILabel()
        let secondNameLabel = UILabel()
        let secondCodeLabel = UILabel()
        cell.firstValueLabel = firstValueLabel
        cell.firstNameLabel = firstNameLabel
        cell.secondValueLabel = secondValueLabel
        cell.secondNameLabel = secondNameLabel
        cell.secondCodeLabel = secondCodeLabel
        cell.prepare(with: DataService.exchange()[0])
        XCTAssertEqual(cell.firstValueLabel.text, "1 USD")
        XCTAssertNotNil(cell.firstNameLabel.text)
        XCTAssertGreaterThan(cell.firstNameLabel.text!.count, 3)
        XCTAssertEqual(cell.secondCodeLabel.text, "RUB")
        XCTAssertNotNil(cell.secondNameLabel.text)
        XCTAssertGreaterThan(cell.secondNameLabel.text!.count, 3)
        XCTAssertEqual(cell.secondValueLabel.attributedText?.string, "1.0102")
    }
}

