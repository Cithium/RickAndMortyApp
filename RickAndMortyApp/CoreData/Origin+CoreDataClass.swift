//
//  Origin+CoreDataClass.swift
//  
//
//  Created by Hamza Abdulilah on 2019-09-07.
//
//

import Foundation
import CoreData


public class Origin: NSManagedObject {

}

struct JSONOrigin: Decodable {
    var id: Int64
    var url: String
}
