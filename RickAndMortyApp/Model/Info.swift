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
    var prev: String?
}

extension Info {
    var nextPage: String {
        get {
           return trimPageFromUrl(url: next)
        }
    }
    
    var prevPage: String? {
        get {
            return trimPageFromUrl(url: prev!)
        }
    }
    
    func trimPageFromUrl(url: String) -> String {
        if let range = url.range(of: "page=") {
            let subString = url[range.upperBound...]
            let nbr = String(subString)
            
            return nbr
        }
        return ""
    }
}
