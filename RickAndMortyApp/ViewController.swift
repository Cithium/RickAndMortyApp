//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import UIKit
import Moya
import PromiseKit

class TableViewController: UITableViewController {
    
    let networkingManager = NetworkingManger.shared
    var info: Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly {
            networkingManager.getCharacters(page: "")
            }.done { (info) in
                self.info = info
            }.catch { (error) in
                print(error.localizedDescription)
        }
    }


}

