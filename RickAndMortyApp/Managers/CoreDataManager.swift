//
//  CoreDataManager.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var mainContext: NSManagedObjectContext!
    var backgroundContext: NSManagedObjectContext!
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RickAndMortyApp")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    init() {
        setup()
    }
    
    func setup() {
        mainContext = persistentContainer.viewContext
        mainContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = mainContext
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        backgroundContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        do {
            try backgroundContext.save()
            
            if (mainContext.hasChanges) {
                try mainContext.save()
            }
        } catch let saveErr {
            print("Failed to save Core Data:", saveErr)
        }
    }
    
    func fetchCharacters() -> Promise<[Character]> {
        return Promise { seal in
            let context = persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<Character>(entityName: "Character")
            do {
                let characters = try context.fetch(fetchRequest)
                seal.fulfill(characters)
            } catch let fetchErr {
                print("Failed to fetch characters:", fetchErr)
                seal.reject(fetchErr)
            }
            
        }
    }
    
    func deleteCharacters() -> Promise<Void> {
        return Promise { seal in
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                save()
                seal.fulfill(())
            } catch let error {
                print("Failed to delete characters:", error)
                seal.reject(error)
            }
        }
    }
}
