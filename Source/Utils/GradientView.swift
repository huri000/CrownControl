//
//  GradientView.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/13/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    // MARK: - Properties
    
    private let gradientLayer = CAGradientLayer()
    
    var gradient: CrownAttributes.Style.Content.Gradient? {
        didSet {
            gradientLayer.colors = gradient?.colors.map { $0.cgColor }
            gradientLayer.startPoint = gradient?.startPoint ?? .zero
            gradientLayer.endPoint = gradient?.endPoint ?? .zero
        }
    }
    
    // MARK: - Setup
    
    init() {
        super.init(frame: .zero)
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
