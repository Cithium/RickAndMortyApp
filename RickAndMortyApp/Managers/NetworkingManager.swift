//
//  NetworkingManager.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

class NetworkingManger: Networkable {
    static let shared = NetworkingManger()
    var service = MoyaProvider<Service>()
    
    func getCharacters(page: String) -> Promise<Info> {
        return Promise { seal in
            service.request(.getCharacters(page: page)) { (response) in
                switch (response) {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let result = try JSONDecoder().decode(JSONCharacterResult.self, from: response.data)
                        
                        result.results.forEach { Character.fromJSONToCoreData(jsonPlaceholder: $0) }
                        seal.fulfill(result.info)
                    } catch {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    
}
