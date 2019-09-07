//
//  Character+CoreDataProperties.swift
//  
//
//  Created by Hamza Abdulilah on 2019-09-07.
//
//

import Foundation
import CoreData


extension Character {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var species: String?
    @NSManaged public var episode: [String]?
    @NSManaged public var location: Location?
    @NSManaged public var origin: Origin?

}
