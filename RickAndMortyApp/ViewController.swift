//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-07.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    
    var service = MoyaProvider<Service>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.request(.getCharacters) { (result) in
            switch (result) {
            case let .success(response):
                do {
                    try _ = response.filterSuccessfulStatusCodes()
                    let data = try response.mapJSON()
                    print(data)
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        
    }


}

