//
//  CharacterDataSource.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-23.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit
import Nuke
import CoreData

class CharacterDataSource: NSObject, UITableViewDataSource {
    var characters: [Character]
    
    init(characters: [Character]) {
        self.characters = characters
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        cell.contentView.alpha = 0.0
        
        let character = characters[indexPath.row]
        cell.character = character
        
        let resourceName = character.isFavorite ? "filledHeart": "emptyHeart"
        cell.heartImageView.resourceName = resourceName
        
        if let stringURL = character.image, let url = URL(string: stringURL) {
            Nuke.loadImage(with: url, into: cell.characterImageView)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
