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
    @IBOutlet weak var cardView: RoundedCardView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    var character: Character? {
        didSet {
            nameLabel.text = character?.name ?? "-"
            statusLabel.text = character?.status ?? "-"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

