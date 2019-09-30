//
//  Character+CoreDataClass.swift
//  
//
//  Created by Hamza Abdulilah on 2019-09-10.
//
//

import Foundation
import CoreData


public class Character: NSManagedObject, JSONConvertible {
    static func fromJSONToCoreData(jsonPlaceholder: Decodable) {
        guard let jsonCharacter = jsonPlaceholder as? JSONCharacter else { return }
        
        let character       = Character(context: CoreDataManager.shared.backgroundContext)
        character.id        = jsonCharacter.id
        character.name      = jsonCharacter.name
        character.status    = jsonCharacter.status
        character.species   = jsonCharacter.species
        character.episode   = jsonCharacter.episode
        character.image     = jsonCharacter.image
        
        let jsonLocation    = jsonCharacter.location
        
        var location: Location!
        if let persistedLocation = CoreDataManager.shared.fetchPersistedLocation(locationName: jsonLocation.name) {
            location        = persistedLocation
        } else {
            location        = Location(context: CoreDataManager.shared.backgroundContext)
        }
        
        location.name       = jsonLocation.name
        location.type       = jsonLocation.type
        location.dimension  = jsonLocation.dimension
        location.residents  = jsonLocation.residents
        location.url        = jsonLocation.url
        
        let jsonOrigin      = jsonCharacter.origin
        let origin          = Origin(context: CoreDataManager.shared.backgroundContext)
        origin.name         = jsonOrigin.name
        origin.url          = jsonOrigin.url
        
        character.location  = location
        character.origin    = origin
        
        CoreDataManager.shared.save()
        
    }
    

}
