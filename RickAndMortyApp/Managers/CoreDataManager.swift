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
    
    func fetchPersistedLocation(locationName: String) -> Location? {
        guard let context = backgroundContext else { return nil }
        
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "name == %@", locationName)
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            return fetchResult.first
        } catch let fetchErr {
            print("Failed to fetch location:", fetchErr)
            return nil
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
    
    func fetchFavoriteCharacters() -> Promise<[Character]> {
        return Promise { seal in
            let context = persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<Character>(entityName: "Character")
            fetchRequest.predicate = NSPredicate(format: "isFavorite = %d", true)
            
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
