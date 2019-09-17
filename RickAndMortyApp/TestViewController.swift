//
//  TestViewController.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-17.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UIViewController {
    @IBOutlet weak var viewLot: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkBlue
        viewLot.resourceName = "galaxy-orbit"
        viewLot.playAnimation()
    }
}
