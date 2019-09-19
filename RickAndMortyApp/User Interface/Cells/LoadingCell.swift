//
//  LoadingCell.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-18.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var lottieAnimation: LottieAnimationView!
    
    var loadingToken: String? {
        didSet {
            lottieAnimation.playAnimation()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
