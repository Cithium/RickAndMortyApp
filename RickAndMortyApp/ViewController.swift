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

class TableViewController: UITableViewController {
    
    let networkingManager = NetworkingManger.shared
    let coreDataManager = CoreDataManager.shared
    var loading: Bool = false
    var info: Info!
    
    var characters =  [Character]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imageView = UIImageView(image: UIImage(named: "stars"))
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        title = "Characters"
        
        
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
}


extension TableViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
            
            let character = characters[indexPath.row]
            cell.character = character
            
            if let stringURL = character.image, let url = URL(string: stringURL) {
                Nuke.loadImage(with: url, into: cell.characterImageView)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return characters.count
        } else if section == 1 && loading {
            return 1
        }
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 200
        } else {
            return 100
        }
        
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell is CharacterCell) {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
            cell.layer.transform = rotationTransform
            
            UIView.animate(withDuration: 0.5) {
                cell.layer.transform = CATransform3DIdentity
            }
        }
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height) {
            if (!loading) {
                fetchMoreCharacters()
            }
        }
    }
    
    
    
    func fetchMoreCharacters() {
        loading = true
        
            firstly {
                networkingManager.getCharacters(page: info.nextPage)
            }.map { info in
                self.info = info
            }.then {
                self.coreDataManager.fetchCharacters()
            }.done { (chars) in
                let filtered = chars.filter { !self.characters.contains($0) }
                self.characters.append(contentsOf: filtered)
                
                UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                    self.tableView.reloadData()
                }, completion: { (_) in
                    self.loading = false
                })
                
            }.catch { error in
                print(error.localizedDescription)
            }
    }
}


