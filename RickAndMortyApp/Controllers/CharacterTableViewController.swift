//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import UIKit
import Moya
import CoreData
import PromiseKit
import Nuke

class CharacterTableViewController: BaseTableViewController {
    let networkingManager = NetworkingManger.shared
    let coreDataManager = CoreDataManager.shared
    
    var favoriteObserver: NSObjectProtocol!
    var loading: Bool = false
    var info: Info!
    
    var characterDataSource: TableViewDataSource<Character>!
    private let customRefreshControl = CustomRefreshControl()
    
    private var navigator: CharacterNavigator!
    
    private func handleTapCell(with character: Character) {
        self.navigator.navigate(to: .characterDetails(charater: character))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteObserver = Foundation.NotificationCenter.default.addObserver(forName: .favoritesChanged, object: nil, queue: nil, using: updateFavorites)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigator = CharacterNavigator(navigationController: navigationController!)
        
        setupViews()

            firstly {
                networkingManager.getCharacters(page: "1")
            }.map { info in
                self.info = info
            }.then {
                self.coreDataManager.fetchCharacters(page: "1")
            }.done { (chars) in
                self.charactersDidLoad(chars)
                self.tableView.reloadData()
            }.catch { error in
                print(error.localizedDescription)
            }
    }
    
    @objc func beginRefreshing() {
        
            firstly {
                self.coreDataManager.deleteCharacters()
            }.then {
                self.networkingManager.getCharacters(page: "1")
            }.map { info in
                self.info = info
            }.then {
                self.coreDataManager.fetchCharacters(page: "1")
            }.done { (chars) in
                self.characterDataSource.models = chars
                self.tableView.reloadData()
                self.loading = false
            }.ensure {
                self.endRefreshing()
            }.catch { error in
                print(error.localizedDescription)
            }
    }
    
    func endRefreshing() {
        guard customRefreshControl.isRefreshing else {
            return
        }
        
        customRefreshControl.endRefreshing()
    }
}

extension CharacterTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characterDataSource.models[indexPath.row]
        /*
        let targetStoryBoard = UIStoryboard(name: "CharacterDetails", bundle: nil)
        if let navController = targetStoryBoard.instantiateInitialViewController() as? UINavigationController, let controller = navController.topViewController as? CharacterDetailsViewController {
            controller.character = character
            
            DispatchQueue.main.async {
                self.present(navController, animated: true, completion: nil)
            }
        }*/
        handleTapCell(with: character)
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
        
        self.characterDataSource = dataSource
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height) {
            guard let _ = self.info, (!loading) ,!(info.nextPage == "") else { return }
            fetchMoreCharacters()
        }
    }
    
    func fetchMoreCharacters() {
        loading = true
        self.hideSpinner(false)
       
      // RickAndMorty-API is very fast, used this to make sure spinner shows
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                firstly {
                    self.networkingManager.getCharacters(page: self.info.nextPage)
                }.map { info in
                    self.info = info
                }.then {
                    self.coreDataManager.fetchCharacters(page: self.info.nextPage)
                }.done { (chars) in
                    let filtered = chars.filter { !self.characterDataSource.models.contains($0) }
                    self.characterDataSource.models.append(contentsOf: filtered)
                    
                    let lastRow = self.tableView.numberOfRows(inSection: 0) - 1
                    self.updateTableView(with: lastRow)
                }.ensure {
                    self.hideSpinner(true)
                }.catch { error in
                    print(error.localizedDescription)
                }
        }
    }
    
    func setupViews() {
        navigationItem.title = "Characters"
        
        let spinner = LottieAnimationView()
        spinner.resourceName = "galaxy-orbit"
        spinner.autoPlay = true
        spinner.playAnimation()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = true
        
        self.customRefreshControl.addTarget(self, action: #selector(beginRefreshing), for: .valueChanged)
        self.tableView.refreshControl = customRefreshControl
    }
}

extension CharacterTableViewController {
    func updateTableView(with lastShownRow: Int) {
        UIView.transition(with: self.tableView, duration: 0.65, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
            self.tableView.centerLastShown(row: lastShownRow)
        }, completion: { (_) in
            self.loading = false
        })
    }
    
    func hideSpinner(_ bool: Bool) {
        self.tableView.isScrollEnabled = bool
        self.tableView.tableFooterView?.isHidden = bool
        
        if let lottieSpinner = self.tableView.tableFooterView as? LottieAnimationView, (bool == false) {
            lottieSpinner.playAnimation()
        }
    }
}

extension CharacterTableViewController: CharacterCellDelegate {
    func didFavorite(with character: Character) {
        character.isFavorite = !character.isFavorite
        coreDataManager.save()
    }
}

extension CharacterTableViewController {
    private func updateFavorites(note: Notification) {
        if let characterId = note.userInfo?["id"] as? Int64, let index = (self.characterDataSource.models.firstIndex { $0.id == characterId }) {
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)

        }
    }
}


extension UITableView {
    func centerLastShown(row: Int) {
        let indexPath = IndexPath(row: row, section: 0);
        scrollToRow(at: indexPath, at: .middle, animated: false)
    }
}

extension NSNotification.Name {
    static let favoritesChanged = Notification.Name("favoritesChanged")
}



