//
// ExchangeUITests.swift
// ExchangeUITests
//
// Created by R on 02.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import XCTest

final class ExchangeUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--tests")
        app.launch()
    }
    
    func addExchange() {
        app.cells.element(boundBy: 3).tap()
        app.cells.element(boundBy: 3).tap()
    }
    
    func addPlus() {
        app.images["addImage"].tap()
        addExchange()
    }
    
    func testAddMain() {
        app.buttons["addButton"].tap()
        app.swipeUp()
        app.cells.element(boundBy: 5).tap()
        app.swipeUp()
        app.cells.element(boundBy: 5).tap()
        let cells = app.tables.cells
        cells.element(boundBy: 0).swipeLeft()
        cells.element(boundBy: 0).buttons.firstMatch.tap()
    }
    
    func testAddMainPlus() {
        addPlus()
        let cells = app.tables.cells
        XCTAssertEqual(cells.count, 1)
        cells.element(boundBy: 0).swipeLeft()
        cells.element(boundBy: 0).buttons.firstMatch.tap()
    }
    
    func testAddFromTable() {
        addPlus()
        app.buttons["addButtonTable"].tap()
        addExchange()
        XCTAssertEqual(app.tables.cells.count, 2)
        app.images["addImageTable"].tap()
        addExchange()
        XCTAssertEqual(app.tables.cells.count, 3)
    }
    
}

