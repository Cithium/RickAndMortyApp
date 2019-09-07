//
//  Origin+CoreDataProperties.swift
//  
//
//  Created by Hamza Abdulilah on 2019-09-07.
//
//

import Foundation
import CoreData


extension Origin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Origin> {
        return NSFetchRequest<Origin>(entityName: "Origin")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var originCharacters: NSSet?

}

// MARK: Generated accessors for originCharacters
extension Origin {

    @objc(addOriginCharactersObject:)
    @NSManaged public func addToOriginCharacters(_ value: Character)

    @objc(removeOriginCharactersObject:)
    @NSManaged public func removeFromOriginCharacters(_ value: Character)

    @objc(addOriginCharacters:)
    @NSManaged public func addToOriginCharacters(_ values: NSSet)

    @objc(removeOriginCharacters:)
    @NSManaged public func removeFromOriginCharacters(_ values: NSSet)

}
