//
//  DataServiceTests.swift
//  ExchangeTests
//
//  Created by R on 09.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import XCTest
import CoreData

class DataServiceTests: XCTestCase {

    override func setUp() {
        DataService.defineInMemoryContainer()
        DataService.addExchange(first: "USD", second: "RUB", value: 1)
        DataService.addExchange(first: "USD", second: "EUR", value: 2)
    }

    override func tearDown() {
        DataService.clear()
    }

    func testCurrencies() {
        let currencies = DataService.currencies
        XCTAssertGreaterThan(currencies.count, 0)
        XCTAssertEqual(currencies[0].count, 3)
    }
    
    func testExchange() {
        let exchange = DataService.exchange()
        XCTAssertEqual(exchange.count, 2)
        XCTAssertEqual(exchange[0].value, 2)
        XCTAssertEqual(exchange[1].value, 1)
    }
}

extension DataService {
    
    // setup in-memory NSPersistentContainer
    static func defineInMemoryContainer() {
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("store")
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        description.shouldAddStoreAsynchronously = false
        description.type = NSInMemoryStoreType
        
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: DataServiceTests.self)])!
        
        DataService.persistentContainer = NSPersistentContainer(name: "Model", managedObjectModel: managedObjectModel)
        DataService.persistentContainer.persistentStoreDescriptions = [description]
        DataService.persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fail to create CoreData Stack \(error.localizedDescription)")
            } else {
                print("CoreData defined")
            }
        }
    }
}
