//
// CurrencyCellTests.swift
//
// Created by R on 20.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import XCTest

final class CurrencyCellTests: XCTestCase {
    
    func testPrepare() {
        let cell = CurrencyCell()
        let flagImageView = UIImageView()
        let codeLabel = UILabel()
        let nameLabel = UILabel()
        cell.flagImageView = flagImageView
        cell.codeLabel = codeLabel
        cell.nameLabel = nameLabel
        cell.prepare(with: "USD")
        XCTAssertEqual(cell.codeLabel.text, "USD")
        XCTAssertNotNil(cell.nameLabel.text)
        XCTAssertGreaterThan(cell.nameLabel.text!.count, 3)
    }
}

