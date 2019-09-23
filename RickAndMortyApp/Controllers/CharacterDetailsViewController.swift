//
//  CharacterDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-23.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    @IBOutlet weak var cardView: RoundedCardView!
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
    }
}
