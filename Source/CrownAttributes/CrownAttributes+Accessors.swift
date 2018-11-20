//
//  CrownAttributes+Accessors.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/19/18.
//

import Foundation

extension CrownAttributes {
    var crownTransform: CGAffineTransform {
        switch spinDirection {
        case .clockwise:
            return .identity
        case .counterClockwise:
            switch anchorPosition {
            case .bottom, .top:
                return CGAffineTransform(scaleX: -1, y: 1)
            case .left, .right:
                return CGAffineTransform(scaleX: 1, y: -1)
            }
        }
    }
}
