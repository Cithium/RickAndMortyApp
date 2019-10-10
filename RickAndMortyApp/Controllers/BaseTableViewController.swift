//
//  BaseTableViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-21.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit
import Hero

class BaseTableViewController: UITableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imageView = UIImageView(image: UIImage(named: "stars"))
        imageView.contentMode = .scaleAspectFill
        self.hero.isEnabled = true
        self.tableView.backgroundView = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        extendedLayoutIncludesOpaqueBars = true
    }
}
