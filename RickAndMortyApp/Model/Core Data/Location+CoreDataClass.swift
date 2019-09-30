//
//  Location+CoreDataClass.swift
//  
//
//  Created by Hamza Abdulilah on 2019-09-10.
//
//

import Foundation
import CoreData


public class Location: NSManagedObject, JSONConvertible {
    static func fromJSONToCoreData(jsonPlaceholder: Decodable) {
        guard let jsonLocation = jsonPlaceholder as? JSONLocation else { return }
        
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
        
        
        CoreDataManager.shared.save()
    }
    

}
