//
//  File.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import Moya

enum Service {
    case getCharacters(page: String)
    case getCharactersWith(ids: String)
    case getLocation(id: String)
}

extension Service: TargetType {
    var baseURL: URL { return URL(string: "https://rickandmortyapi.com/api")! }
    var path: String {
        switch self {
        case .getCharacters:
            return "/character"
        case .getCharactersWith(ids: let ids):
            return "/character/\(ids)"
        case .getLocation(let id):
            return "/location/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharacters:
            return .get
        case .getCharactersWith:
            return .get
        case .getLocation:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCharacters(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getCharactersWith:
            return .requestPlain
        case .getLocation(let id):
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getCharacters, .getCharactersWith:
            guard let url = Bundle.main.url(forResource: "CharacterSampleData", withExtension: "json"), let data = try? Data(contentsOf: url) else {
                return Data()
            }
            
            return data
        case .getLocation:
            guard let url = Bundle.main.url(forResource: "LocationSampleData", withExtension: "json"), let data = try? Data(contentsOf: url) else {
                return Data()
            }
            
            return data
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
