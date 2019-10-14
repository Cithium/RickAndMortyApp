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
    @IBOutlet weak var spinnerView: LottieAnimationView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimension: UILabel!
    
    
    let networkManager = NetworkingManger.shared
    let coreDataManager = CoreDataManager.shared
    
    var navigator: CharacterLocationNavigator!
    
    var character: Character!
    var location: Location?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ResidentsTableViewController {
            destinationVC.location = location
        }
    }
    
    @IBAction func residentsTapped(_ sender: Any) {
        guard let location = self.location else { return }
        navigator.navigate(to: .locationResidents(location: location))
    }
    
    @objc func dismissFlow() {
        guard let navController = navigationController else { return }
        
        navController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigator = CharacterLocationNavigator(navigationController: self.navigationController!)
        self.navigationItem.title = "Location"
        setupViews()
        
        firstly {
            networkManager.getLocation(id: character.locationId)
        }.then {
            self.coreDataManager.fetchLocation(with: self.character.location?.name)
        }.done { (location) in
            self.location = location
        }.catch { error in
            print(error.localizedDescription)
        }.finally {
            self.setupAndAnimateView()
        }
        
    }
    
    private func setupViews() {
        imageView.alpha = 0.0
        imageTitle.alpha = 0.0
        contentStackView.alpha = 0.0
        
        spinnerView.alpha = 1.0
        
        let closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ico_close"), style: .plain, target: self, action: #selector(dismissFlow))
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.neonGreen
        
    }
    
    private func setupAndAnimateView() {
        nameLabel.text = location?.name ?? "-"
        typeLabel.text = location?.type ?? "-"
        dimension.text = location?.dimension ?? "-"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            UIView.animate(withDuration: 0.4, animations: {
                self.spinnerView.alpha = 0.0
            }) { _ in
                UIView.animate(withDuration: 0.4, animations: {
                    self.imageView.alpha = 1.0
                    self.imageTitle.alpha = 1.0
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.contentStackView.alpha = 1.0
                    })
                })
            }
        }
        
        
    }
}
