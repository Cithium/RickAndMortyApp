//
//  Character+CoreDataClass.swift
//  
//
//  Created by Hamza Abdulilah on 2019-09-07.
//
//

import Foundation
import CoreData


public class Character: NSManagedObject {

}

struct JSONCharacter: Decodable {
    var id: Int64
    var name: String
    var status: String
    var species: String
    var episode: [String]
    var location: JSONLocation
    var origin: JSONOrigin
}
