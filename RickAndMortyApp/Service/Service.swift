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
}

extension Service: TargetType {
    var baseURL: URL { return URL(string: "https://rickandmortyapi.com/api/")! }
    var path: String {
        switch self {
        case .getCharacters:
            return "/character"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharacters:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCharacters(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getCharacters:
            guard let url = Bundle.main.url(forResource: "CharacterSampleData", withExtension: "json"), let data = try? Data(contentsOf: url) else {
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
