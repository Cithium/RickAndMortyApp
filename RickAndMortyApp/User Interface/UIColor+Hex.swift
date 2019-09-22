//
//  UIColor+Hex.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-12.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    @nonobjc public static var neonGreen         =   UIColor(rgba: "#39ff14")
    @nonobjc public static var darkBlue          =   UIColor(rgba: "#131D36")
    @nonobjc public static var lighterBlue       =   UIColor(rgba: "#1d2b4f")
    @nonobjc public static var neonBlue          =   UIColor(rgba: "#4EAFC0")
    
}

extension UIColor {
    public convenience init(_ hex: UInt32, alpha: CGFloat = 1) {
        let red     = CGFloat((hex & 0xFF0000) >> 16) / CGFloat(255)
        let green   = CGFloat((hex & 0x00FF00) >>  8) / CGFloat(255)
        let blue    = CGFloat( hex & 0x0000FF       ) / CGFloat(255)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(rgba: String) {
        guard rgba.hasPrefix("#"), rgba.count == 7 else {
            self.init()
            return
        }
        
        let hexString = rgba[rgba.index(rgba.startIndex, offsetBy: 1)...]
        var hex: UInt32 = 0
        
        Scanner(string: String(hexString)).scanHexInt32(&hex)
        
        self.init(hex, alpha: 1.0)
    }
}
