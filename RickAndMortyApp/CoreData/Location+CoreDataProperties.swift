//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Hamza Abdulilah on 2019-09-07.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var locationCharacters: NSSet?

}

// MARK: Generated accessors for locationCharacters
extension Location {

    @objc(addLocationCharactersObject:)
    @NSManaged public func addToLocationCharacters(_ value: Character)

    @objc(removeLocationCharactersObject:)
    @NSManaged public func removeFromLocationCharacters(_ value: Character)

    @objc(addLocationCharacters:)
    @NSManaged public func addToLocationCharacters(_ values: NSSet)

    @objc(removeLocationCharacters:)
    @NSManaged public func removeFromLocationCharacters(_ values: NSSet)

}
