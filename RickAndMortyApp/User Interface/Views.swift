//
//  Views.swift
//  RickAndMortyApp
//
//  Created by Hamza Abdulilah on 2019-09-12.
//  Copyright © 2019 Hamza Abdulilah. All rights reserved.
//

import Foundation
import UIKit
import Lottie

@IBDesignable
class LottieAnimationView: CustomView {
    var animationView: AnimationView!
    
    @IBInspectable var resourceName: String? {
        didSet {
            configure()
        }
    }
    
    @IBInspectable var autoPlay: Bool = false {
        didSet {
            configure()
        }
    }
    
    override func configure() {
        super.configure()
        
        if let view = self.animationView {
            view.removeFromSuperview()
        }
        
        guard let resourceName = resourceName else {
            return
        }
        
        animationView = AnimationView(name: resourceName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = autoPlay ? .loop: .playOnce
        
        self.addEdgeToEdge(subview: animationView)
        if (autoPlay) {
            animationView.play()
        }
    }
    
    func playAnimation() {
        configure()
        animationView.play()
    }
}

@IBDesignable
class CustomRefreshControl: UIRefreshControl {
    override init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        tintColor = UIColor.neonGreen
        attributedTitle = NSAttributedString(string: "Refreshing character list...", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.neonGreen,
            NSAttributedString.Key.font: UIFont(name: "LCD Solid", size: 10.0)
        ])
    }
}

@IBDesignable
class ArrowImageView: CustomImageView {
    override func configure() {
        let arrowImage = UIImage(named: "ico_arrow_right")?.withRenderingMode(.alwaysTemplate)
        image = arrowImage
        tintColor = UIColor.neonGreen
        contentMode = .center
    }
}

@IBDesignable
class HeartImageView: CustomImageView {
    override func configure() {
        let emptyHeartImage = UIImage(named: "emptyHeart")?.withRenderingMode(.alwaysTemplate)
        let filledHeartImage = UIImage(named: "filledHeart")?.withRenderingMode(.alwaysTemplate)
        image = emptyHeartImage
        highlightedImage = filledHeartImage
        tintColor = UIColor.neonGreen
    }
}

@IBDesignable
class RoundedImageView: CustomImageView {
    override func configure() {
        backgroundColor = UIColor.darkBlue
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.neonGreen.cgColor
    }
}

@IBDesignable
class RoundedCardView: CustomView {
    override func configure() {
        backgroundColor = UIColor.darkBlue
        layer.cornerRadius = 20.0
        layer.shadowColor = UIColor.neonGreen.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 12.0
        layer.shadowOpacity = 0.7
    }
}

open class CustomView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configure()
    }
    
    open func configure() {
        
    }
}

open class CustomImageView: UIImageView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configure()
    }
    
    open func configure() {
        
    }
}

public extension UIView {
    func addEdgeToEdge(subview view: UIView) {
        addEdgeToEdge(subview: view, insets: .zero)
    }
    
    func addEdgeToEdge(subview view: UIView, inset: CGFloat) {
        addEdgeToEdge(subview: view, insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }
    
    func addEdgeToEdge(subview view: UIView, insets edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        let views: [String: UIView] = ["view": view]
        let insets = [edgeInsets.top, edgeInsets.left, edgeInsets.right, edgeInsets.bottom].map { Double($0) }.map { NSNumber(value: $0) }
        let metrics: [String: NSNumber] = ["top": insets[0], "left": insets[1], "right": insets[2], "bottom": insets[3]]
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[view]-bottom-|", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[view]-right-|", options: [], metrics: metrics, views: views))
    }
}

