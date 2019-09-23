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
    var loading: Bool = false
    var info: Info!
    
    var characters =  [Character]()
    
    private let customRefreshControl = CustomRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Characters"
        setupViews()

            firstly {
                networkingManager.getCharacters(page: "")
            }.map { info in
                self.info = info
            }.then {
                self.coreDataManager.fetchCharacters()
            }.done { (chars) in
                self.characters = chars
                self.tableView.reloadData()
            }.catch { error in
                print(error.localizedDescription)
            }
    }
    
    @objc func beginRefreshing() {
        
        firstly {
            self.coreDataManager.deleteCharacters()
            }.then {
                self.networkingManager.getCharacters(page: "")
            }.map { info in
                self.info = info
            }.then {
                self.coreDataManager.fetchCharacters()
            }.done { (chars) in
                self.characters = chars
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
        let character = characters[indexPath.row]
        
        let targetStoryBoard = UIStoryboard(name: "CharacterDetails", bundle: nil)
        if let navController = targetStoryBoard.instantiateInitialViewController() as? UINavigationController, let controller = navController.topViewController as? CharacterDetailsViewController {
            controller.character = character
            
            DispatchQueue.main.async {
                self.present(navController, animated: true, completion: nil)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
            cell.contentView.alpha = 0
        
            let character = characters[indexPath.row]
            cell.character = character
            
            if let stringURL = character.image, let url = URL(string: stringURL) {
                Nuke.loadImage(with: url, into: cell.characterImageView)
            }
            
            return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell is CharacterCell) {
            UIView.animate(withDuration: 0.65, delay: 0.0, options: .allowUserInteraction, animations: {
                cell.contentView.alpha = 1.0
            }, completion: nil)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height) {
            guard let _ = self.info, (!loading && info.nextPage == "")   else { return }
            fetchMoreCharacters()
        }
    }
    
    func fetchMoreCharacters() {
        loading = true
        self.hideSpinner(false)
       
      // RickAndMorty-API is very fast, used this to make sure spinner works
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                firstly {
                    self.networkingManager.getCharacters(page: self.info.nextPage)
                }.map { info in
                    self.info = info
                }.then {
                    self.coreDataManager.fetchCharacters()
                }.done { (chars) in
                    let filtered = chars.filter { !self.characters.contains($0) }
                    self.characters.append(contentsOf: filtered)
                    
                    let lastRow = self.tableView.numberOfRows(inSection: 0) - 1
                    self.updateTableView(with: lastRow)
                }.ensure {
                    self.hideSpinner(true)
                }.catch { error in
                    print(error.localizedDescription)
                }
        //}
    }
    
    func updateTableView(with lastShownRow: Int) {
        UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
            self.tableView.centerLastShown(row: lastShownRow)
        }, completion: { (_) in
            self.loading = false
        })
    }
    
    func setupViews() {
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
    func hideSpinner(_ bool: Bool) {
        self.tableView.isScrollEnabled = bool
        self.tableView.tableFooterView?.isHidden = bool
    }
}

extension UITableView {
    func centerLastShown(row: Int) {
        let indexPath = IndexPath(row: row, section: 0);
        scrollToRow(at: indexPath, at: .middle, animated: false)
    }
}



