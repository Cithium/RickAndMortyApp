//
//  Networkable+Characters.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import PromiseKit

protocol Networkable {
    func getCharacters(page: String) -> Promise<Info>
}
