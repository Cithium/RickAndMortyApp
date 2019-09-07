//
//  JSONConvertible.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation

protocol JSONConvertible {
    static func fromJSONToCoreData(jsonData: Data)
}
