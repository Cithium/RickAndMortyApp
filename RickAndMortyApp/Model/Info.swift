//
//  Info.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation

struct Info: Decodable {
    var count: Int
    var pages: Int
    var next: String
    var prev: String
}
