//
//  CharacterLocationNavigator.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-10-14.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class CharacterLocationNavigator: Navigator {
    enum Destination {
        case locationResidents(location: Location)
    }
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func dismissFlow() {
        guard let navController = navigationController else { return }
        
        navController.dismiss(animated: true, completion: nil)
    }
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .locationResidents(let location):
            let storyBoard : UIStoryboard = UIStoryboard(name: "CharacterLocation", bundle: nil)
            let locationViewController = storyBoard.instantiateViewController(withIdentifier: "ResidentsTableViewController") as! ResidentsTableViewController
            locationViewController.location = location
            return locationViewController
        }
    }
}
