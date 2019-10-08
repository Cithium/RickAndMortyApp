//
//  LocationDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-10-04.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class LocationDetailsViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimension: UILabel!
    
    
    let networkManager = NetworkingManger.shared
    let coreDataManager = CoreDataManager.shared
    
    var navigator: CharacterDetailsNavigator!
    
    var character: Character!
    var location: Location?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ResidentsTableViewController {
            destinationVC.location = location
        }
    }
    
    @IBAction func residentsTapped(_ sender: Any) {
        performSegue(withIdentifier: "residentsSegue", sender: self)
    }
    
    @objc func dismissFlow() {
        guard let navController = navigationController else { return }
        
        navController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Location"
        
        let closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ico_close"), style: .plain, target: self, action: #selector(dismissFlow))
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.neonGreen
        
        firstly {
            networkManager.getLocation(id: character.locationId)
        }.then {
            self.coreDataManager.fetchLocation(with: self.character.location?.name)
        }.done { (location) in
            self.location = location
        }.catch { error in
            print(error.localizedDescription)
        }.finally {
            self.setupView()
        }
        
    }
    
    private func setupView() {
        nameLabel.text = location?.name ?? "-"
        typeLabel.text = location?.type ?? "-"
        dimension.text = location?.dimension ?? "-"
    }
}
