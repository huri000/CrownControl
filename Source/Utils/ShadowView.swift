//
//  ShadowView.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/13/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    private lazy var shadowLayer: CAShapeLayer = {
        let shadowLayer = CAShapeLayer()
        layer.addSublayer(shadowLayer)//(shadowLayer, at: 0)
        return shadowLayer
    }()
    
    var shadow = CrownAttributes.Style.Shadow.none {
        didSet {
            switch shadow {
            case .active(with: let value):
                applyDropShadow(withOffset: value.offset, opacity: value.opacity, radius: value.radius, color: value.color)
            case .none:
                removeDropShadow()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let minEdge = min(bounds.width, bounds.height) * 0.5
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: minEdge).cgPath
    }
}

extension UIView {
    func applyDropShadow(withOffset offset: CGSize, opacity: Float, radius: CGFloat, color: UIColor) {
        layer.applyDropShadow(withOffset: offset, opacity: opacity, radius: radius, color: color)
    }
    
    func removeDropShadow() {
        layer.removeDropShadow()
    }
}

extension CALayer {
    func applyDropShadow(withOffset offset: CGSize, opacity: Float, radius: CGFloat, color: UIColor) {
        shadowOffset = offset
        shadowOpacity = opacity
        shadowRadius = radius
        shadowColor = color.cgColor
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
    
    func removeDropShadow() {
        shadowOffset = .zero
        shadowOpacity = 0
        shadowRadius = 0
        shadowColor = UIColor.clear.cgColor
        shouldRasterize = false
    }
}

