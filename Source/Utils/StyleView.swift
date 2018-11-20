//
//  StyleView.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/13/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

class StyleView: UIView {
    
    // MARK: - Properties
    
    private let visualEffectView: UIVisualEffectView
    private let imageView: UIImageView
    private let gradientView: GradientView
    
    // MARK: - Setup
    
    init() {
        imageView = UIImageView()
        visualEffectView = UIVisualEffectView(effect: nil)
        gradientView = GradientView()
        
        super.init(frame: UIScreen.main.bounds)
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        addSubview(gradientView)
        gradientView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) * 0.5
    }
    
    var border: CrownAttributes.Style.Border = .none {
        didSet {
            guard let values = border.borderValues else {
                return
            }
            layer.borderColor = values.color.cgColor
            layer.borderWidth = values.width
        }
    }
    
    // Background setter
    var background: CrownAttributes.Style.Content! {
        didSet {
            guard let background = background else {
                return
            }
            
            var gradient: CrownAttributes.Style.Content.Gradient?
            var backgroundEffect: UIBlurEffect?
            var backgroundColor: UIColor = .clear
            var backgroundImage: UIImage?
            
            switch background {
            case .color(color: let color):
                backgroundColor = color
            case .gradient(gradient: let value):
                gradient = value
            case .image(image: let image):
                backgroundImage = image
            case .visualEffect(style: let style):
                backgroundEffect = UIBlurEffect(style: style)
            case .clear:
                break
            }
            
            gradientView.gradient = gradient
            visualEffectView.effect = backgroundEffect
            layer.backgroundColor = backgroundColor.cgColor
            imageView.image = backgroundImage
        }
    }
}
