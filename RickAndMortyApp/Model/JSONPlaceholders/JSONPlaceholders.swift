//
//  JSONPlaceholders.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation

struct JSONCharacterResult: Decodable {
    var info: Info
    var results: [JSONCharacter]
}

struct JSONLocationResult: Decodable {
    var info: Info
    var results: [JSONLocation]
}

struct JSONCharacter: Decodable {
    var id: Int64
    var name: String
    var status: String
    var species: String
    var episode: [String]
    var location: JSONLocation
    var origin: JSONOrigin
    var image: String
}

struct JSONLocation: Decodable {
    var id: Int64
    var name: String
    var type: String?
    var dimension: String?
    var residents: [String]?
    var url: String
}

struct JSONOrigin: Decodable {
    var name: String
    var url: String
}
