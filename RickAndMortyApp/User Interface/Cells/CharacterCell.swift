//
//  CharacterCell.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-12.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterCellDelegate: class {
    func didFavorite(with character: Character)
}

class CharacterCell: UITableViewCell {
    @IBOutlet weak var cardView: RoundedCardView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var heartImageView: HeartImageView!
    
    weak var delegate: CharacterCellDelegate?
    
    @IBAction func favoriteAction(_ sender: Any) {
        guard let character = self.character else { return }
        heartImageView.isHighlighted = !heartImageView.isHighlighted
        delegate?.didFavorite(with: character)
    }
    
    
    var character: Character? {
        didSet {
            nameLabel.text = character?.name ?? "-"
            statusLabel.text = character?.status ?? "-"
            if let char = character { cardView.hero.id = String(describing: char.id) }
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

