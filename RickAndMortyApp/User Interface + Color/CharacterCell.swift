//
//  CharacterCell.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-12.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit

class CharacterCell: UITableViewCell {
    var character: Character? {
        didSet {
            print(character?.name)
        }
    }
}
