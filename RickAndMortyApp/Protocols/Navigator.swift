//
//  Navigator.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-10-08.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation

protocol Navigator {
    associatedtype Destination
    
    func navigate(to destination: Destination)
}
