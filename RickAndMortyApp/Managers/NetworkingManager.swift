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
    
    func getCharactersWith(ids: String) -> Promise<Void> {
        return Promise { seal in
            service.request(.getCharactersWith(ids: ids)) { (response) in
                switch (response) {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        
                        if (ids.count == 1) {
                            let result = try JSONDecoder().decode(JSONCharacter.self, from: response.data)
                            Character.fromJSONToCoreData(jsonPlaceholder: result)
                        } else {
                            let result = try JSONDecoder().decode([JSONCharacter].self, from: response.data)
                            result.forEach { Character.fromJSONToCoreData(jsonPlaceholder: $0) }
                        }
                        
                        seal.fulfill(())
                    } catch {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func getLocation(id: String) -> Promise<Void> {
        return Promise { seal in
            service.request(.getLocation(id: id)) { (response) in
                switch (response) {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        let result = try JSONDecoder().decode(JSONLocation.self, from: response.data)
                        Location.fromJSONToCoreData(jsonPlaceholder: result)
                        seal.fulfill(())
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
