//
//  CharacterNavigator.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-10-08.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit

class CharacterNavigator: Navigator {
    enum Destination {
        case characterDetails(charater: Character)
    }
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        
        if let navigationController = viewController as? CustomNavigationController, let firstViewController = navigationController.viewControllers.first, (firstViewController is CharacterDetailsViewController) {
            
            /* For some reason, animation doesnt work unless this is used.
             Very strange, considiring the code already executes on the main thread.
             Seems to be some kind of iOS bug and not the Hero library.
             */
                DispatchQueue.main.async {
                    self.navigationController?.present(viewController, animated: true, completion: nil)
                }
        } else {
            navigationController?.present(viewController, animated: true, completion: nil)
        }
        
    }

    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .characterDetails(let character):
            let targetStoryBoard = UIStoryboard(name: "CharacterDetails", bundle: nil)
            if let navController = targetStoryBoard.instantiateInitialViewController() as? UINavigationController, let controller = navController.topViewController as? CharacterDetailsViewController {
                controller.character = character
                
                return navController
            }
            
            return UIViewController()
        }
    }
}
