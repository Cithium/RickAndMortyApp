//
//  CharacterDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-23.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import UIKit
import Nuke

class CharacterDetailsViewController: UIViewController {
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var cardView: RoundedCardView!
    @IBOutlet weak var nameLabel: GreenLCDLabel!
    @IBOutlet weak var statusLabel: GreenLCDLabel!
    @IBOutlet weak var originLabel: GreenLCDLabel!
    @IBOutlet weak var locationLabel: GreenLCDLabel!
    
    var character: Character!
    
    @objc func dismissFlow() {
        guard let navController = navigationController else { return }
        
        navController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.hero.id = String(describing: character.id)
        
        let closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ico_close"), style: .plain, target: self, action: #selector(dismissFlow))
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.neonGreen
        navigationItem.title = "Details"
        
        setupView()
    }
    
    private func setupView() {
        nameLabel.text = character.name ?? "-"
        statusLabel.text = character.status ?? "-"
        originLabel.text = character.origin?.name ?? "-"
        locationLabel.text = character.location?.name ?? ""
        
        guard let urlString = character.image, let url = URL(string: urlString) else {
            return
        }
        loadImage(with: url, into: characterImageView)
    }
}
