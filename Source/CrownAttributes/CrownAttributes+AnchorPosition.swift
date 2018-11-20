//
//  CrownAttributes+AnchorPosition.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/12/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

public extension CrownAttributes {
    
    /** The starting position of the indicator */
    public enum AnchorPosition {
        
        /** Points to the top of the crown */
        case top
        
        /** Points to the bottom of the crown */
        case bottom
        
        /** Points to the left of the crown */
        case left
        
        /** Points to the right of the crown */
        case right
        
        /** Convert the anchor position to radians */
        var radians: CGFloat {
            switch self {
            case .right:
                return 0
            case .bottom:
                return .pi * 0.5
            case .left:
                return .pi
            case .top:
                return .pi * 1.5
            }
        }
    }
}
