//
//  LocationDetailsNavigator.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-10-08.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit

class CharacterDetailsNavigator: Navigator {
    enum Destination {
        case locationDetails(charater: Character)
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
        case .locationDetails(let character):
            let storyBoard : UIStoryboard = UIStoryboard(name: "CharacterDetails", bundle:nil)
            let locationViewController = storyBoard.instantiateViewController(withIdentifier: "LocationDetailsViewController") as! LocationDetailsViewController
            locationViewController.character = character
            return locationViewController
        }
    }
}
