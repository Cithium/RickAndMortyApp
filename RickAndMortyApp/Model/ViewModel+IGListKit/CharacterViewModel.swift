//
//  CharacterViewModel.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-10.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation

class CharacterViewModel: NSObject {
    let name: String?
    let status: String?
    let location: Location?
    let origin: Origin?
    let species: String?
    
    init(name: String?, status: String?, location: Location?, origin: Origin?, species: String?) {
        self.name = name
        self.status = status
        self.location = location
        self.origin = origin
        self.species = species
    }
}

extension CharacterViewModel {
    static func fromCoreData(character: Character) -> CharacterViewModel {
        var characterViewModel: CharacterViewModel!
        // - Note: For avoiding Core Data threading violation, the following code should be wrapped in a
        character.managedObjectContext?.performAndWait {
            characterViewModel = CharacterViewModel(name: character.name, status: character.status, location: character.location, origin: character.origin, species: character.species)
        }
        
        return characterViewModel
    }
}
