//
//  DataService.swift
//  Exchange
//
//  Created by R on 08.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation
import CoreData

final class DataService {
   
    static var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("data - unresolved error \(error), \(error.userInfo)")
            }
        })
        return persistentContainer
    }()
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                #if DEBUG
                print("data - \(error.localizedDescription)")
                #endif
            }
        }
    }
    
    static func remove(_ object: NSManagedObject) {
        context.delete(object)
        save()
    }
    
    static func clear() {
        exchange().forEach {
            remove($0)
        }
    }
    
    // MARK: - Exchange
    
    static func exchangeResultsController(_ delegate: NSFetchedResultsControllerDelegate? = nil) -> NSFetchedResultsController<Exchange> {
        let request: NSFetchRequest<Exchange> = Exchange.fetchRequest()
        let sort = NSSortDescriptor(key: "createDate", ascending: false)
        request.sortDescriptors = [sort]
        let resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataService.context, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = delegate
        return resultsController
    }
    
    static func exchange() -> [Exchange] {
        let request = NSFetchRequest<Exchange>(entityName: "Exchange")
        let sort = NSSortDescriptor(key: "createDate", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do {
            return try context.fetch(request)
        } catch {
            #if DEBUG
            print("data - \(error.localizedDescription)")
            #endif
            return []
        }
    }
    
    static var exchangeCount: Int {
        let request = NSFetchRequest<Exchange>(entityName: "Exchange")
        do {
            return try context.count(for: request)
        } catch {
            #if DEBUG
            print("data - \(error.localizedDescription)")
            #endif
            return 0
        }
    }
    
    static func exchange(for first: String, and second: String) -> Exchange? {
        let request = NSFetchRequest<Exchange>(entityName: "Exchange")
        request.predicate = NSPredicate(format: "first == %@ AND second == %@", first, second)
        request.returnsObjectsAsFaults = false
        do {
            return try context.fetch(request).first
        } catch {
            #if DEBUG
            print("data - \(error.localizedDescription)")
            #endif
            return nil
        }
    }
    
    static func addExchange(first: String, second: String, value: Double = 0) {
        let exchange = Exchange(context: context)
        exchange.createDate = Date()
        exchange.first = first
        exchange.second = second
        exchange.value = value
        save()
    }
    
    static func save(exchange: Exchange) {
        exchange.updateDate = Date()
        save()
    }

    // Currerncies
    
    private static var _currencies: [String]?
    static var currencies: [String] {
        if _currencies != nil {
            return _currencies!
        }
        guard
            let path = Bundle.main.path(forResource: "currencies", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
            let currencies = jsonResult as? Array<String> else {
                _currencies = []
                return []
        }
        _currencies = currencies.map { $0.uppercased() }
        return _currencies!
    }
}
