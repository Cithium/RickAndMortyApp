//
//  FavoriteTableViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-22.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import UIKit
import Moya
import CoreData
import PromiseKit
import Nuke

class FavoriteTableViewController: BaseTableViewController {
    let networkingManager = NetworkingManger.shared
    let coreDataManager = CoreDataManager.shared
    var loading: Bool = false
    var info: Info!
    
    var favoritesDataSource: TableViewDataSource<Character>!
    private let customRefreshControl = CustomRefreshControl()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            firstly {
                self.coreDataManager.fetchFavoriteCharacters()
            }.done { (chars) in
                self.charactersDidLoad(chars)
                self.tableView.reloadData()
            }.catch { error in
                print(error.localizedDescription)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorites"
        setupViews()
    }
}

extension FavoriteTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = favoritesDataSource.models[indexPath.row]
        
        let targetStoryBoard = UIStoryboard(name: "CharacterDetails", bundle: nil)
        if let navController = targetStoryBoard.instantiateInitialViewController() as? UINavigationController, let controller = navController.topViewController as? CharacterDetailsViewController {
            controller.character = character
            
            DispatchQueue.main.async {
                self.present(navController, animated: true, completion: nil)
            }
        }
        
    }
    
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
        
        self.favoritesDataSource = dataSource
        tableView.dataSource = dataSource
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.favoritesDataSource.models[indexPath.row].isFavorite = false
            self.favoritesDataSource.models.remove(at: indexPath.row)
            tableView.reloadData()
            
            /* This results in UI glitch for the TableView background image
            tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            tableView.endUpdates()
            */
            //  self.coreDataManager.save()
            print("delete favorite")
        }
        delete.backgroundColor = .neonGreen
        return [delete]
    }
    
    func setupViews() {
        let spinner = LottieAnimationView()
        spinner.resourceName = "galaxy-orbit"
        spinner.autoPlay = true
        spinner.playAnimation()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = true
    }
}

extension FavoriteTableViewController: CharacterCellDelegate {
    func didFavorite(with character: Character) {
        character.isFavorite = !character.isFavorite
        firstly {
            self.coreDataManager.fetchFavoriteCharacters()
            }.done { (chars) in
                self.charactersDidLoad(chars)
                self.tableView.reloadData()
            }.catch { error in
                print(error.localizedDescription)
            }.finally {
                self.coreDataManager.save()
                NotificationCenter.default.post(name: .favoritesChanged, object: nil, userInfo: ["id": character.id])
            }
        
    }
}



