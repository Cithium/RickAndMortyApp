//
//  ResidentsTableViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-10-06.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import UIKit
import Moya
import CoreData
import PromiseKit
import Nuke

class ResidentsTableViewController: BaseTableViewController {
    let networkingManager = NetworkingManger.shared
    let coreDataManager = CoreDataManager.shared
    var loading: Bool = false
    var info: Info!
    var spinner: LottieAnimationView!
    
    var residents: [Character]?
    var location: Location!
    var selectedCharacter: Character?
    
    var characterDataSource: TableViewDataSource<Character>!
    private let customRefreshControl = CustomRefreshControl()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ResidentDetailsViewController {
            destinationVC.character = selectedCharacter
        }
    }
    
    @objc func dismissFlow() {
        guard let navController = navigationController else { return }
        
        navController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard (residents == nil) else { return }
        
            firstly {
                networkingManager.getCharactersWith(ids: self.location.residentIdsString)
            }.then {
                self.coreDataManager.fetchResidents(ids: self.location.residentIds)
            }.done { (chars) in
                self.residents = chars
                self.charactersDidLoad(chars)
                self.tableView.reloadData()
                self.spinner.isHidden = true
                self.tableView.tableHeaderView = nil
            }.catch { error in
                print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Residents"
        setupViews()
    }
}

extension ResidentsTableViewController {
    func charactersDidLoad(_ characters: [Character]) {
        let dataSource = TableViewDataSource(
            models: characters,
            reuseIdentifier: "CharacterCell"
        ) { character, cell in
            cell.contentView.alpha = 0.0
            
            guard let characterCell = cell as? CharacterCell else { return }
            characterCell.character = character
            characterCell.heartImageView.isHighlighted = character.isFavorite
            characterCell.delegate = self
            
            if let stringURL = character.image, let url = URL(string: stringURL) {
                Nuke.loadImage(with: url, into: characterCell.characterImageView)
            }
        }
        
        self.characterDataSource = dataSource
        tableView.dataSource = dataSource
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characterDataSource.models[indexPath.row]
        selectedCharacter = character
        performSegue(withIdentifier: "residentDetailsSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell is CharacterCell) {
            UIView.animate(withDuration: 0.55, delay: 0.0, options: .allowUserInteraction, animations: {
                cell.contentView.alpha = 1.0
            }, completion: nil)
        }
    }
    
    
    func setupViews() {
        let closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ico_close"), style: .plain, target: self, action: #selector(dismissFlow))
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.neonGreen
        
        spinner = LottieAnimationView()
        spinner.resourceName = "galaxy-orbit"
        spinner.isHidden = false
        spinner.autoPlay = true
        spinner.playAnimation()
        spinner.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        self.tableView.tableHeaderView = spinner
    }
}

extension ResidentsTableViewController: CharacterCellDelegate {
    func didFavorite(with character: Character) {
        character.isFavorite = !character.isFavorite
        coreDataManager.save()
    }
}

