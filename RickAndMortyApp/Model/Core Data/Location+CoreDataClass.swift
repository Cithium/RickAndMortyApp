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

extension Location {
    var residentIdsString: String {
        get {
            var stringForUrl = ""
            guard let idsList = trimResidentIdsFromUrl() else { return "" }
            
            for id in idsList {
                if (id == idsList.last) {
                    stringForUrl.append(id)
                } else {
                    stringForUrl.append(id + ",")
                }
            }
            
            return stringForUrl
        }
    }
    
    var residentIds: [Int]? {
        get {
            guard let list = trimResidentIdsFromUrl() else {
                return nil
            }
            return list.compactMap { Int($0) }
        }
    }
    
    private func trimResidentIdsFromUrl() -> [String]? {
        guard let residentUrls = residents else { return nil }
        
        
        var idsList = [String]()
        for url in residentUrls {
            if let range = url.range(of: "character/") {
                let subString = url[range.upperBound...]
                let id = String(subString)
                
                idsList.append(id)
            }
        }
        
        return idsList
    }
}
