//
// SettingsTests.swift
//
// Created by R on 20.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import XCTest

class SettingsTests: XCTestCase {
    
    func testVariables() {
        XCTAssertGreaterThan(Settings.server.count, 0)
        XCTAssertGreaterThan(Settings.updateInterval, 0)
    }

}

