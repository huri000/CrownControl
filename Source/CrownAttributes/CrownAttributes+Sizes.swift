//
//  CrownAttributes+Sizes.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/11/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

public extension CrownAttributes {

    /** Sizes and relations */
    public struct Sizes {
                
        /** The crown surface edge size */
        public var backgroundSurfaceDiameter: CGFloat = 65
        
        /** The crown indicator size (relative to the crown background edge) */
        public var foregroundSurfaceEdgeRatio: CGFloat = 0.3
    
        /** The scroll relation - 1 full round, 0.5 make the crown make a full spn before reaching the.
         Must be positive real number in range (0...1] */
        public var scrollRelation: CGFloat = 8
        
        /** The edge insets within the crown superview. The crown frame is unable to exceed those limits. */
        public var superviewEdgeInsets = UIEdgeInsets.zero
        
        /** The maximum possible spin angle (for the crown foreground) */
        public var maximumAngleInRadian: CGFloat {
            return 2 * .pi * scrollRelation
        }
        
        /** The crown foreground edge length */
        var backgroundSurfaceRadius: CGFloat {
            return backgroundSurfaceDiameter * 0.5
        }
        
        /** The center of the crown (in the bounds of the crown) */
        var crownCenter: CGPoint {
            return .init(x: backgroundSurfaceRadius, y: backgroundSurfaceRadius)
        }
        
        /** The crown foreground edge length */
        public var foregroundDiameter: CGFloat {
            return backgroundSurfaceDiameter * foregroundSurfaceEdgeRatio
        }
        
        /** The crown background size as square */
        var backgroundSurfaceSquareSize: CGSize {
            return .init(width: backgroundSurfaceDiameter, height: backgroundSurfaceDiameter)
        }
        
        /** Calculates the inner circle diameter */
        var innerCircleEdgeSize: CGFloat {
            return backgroundSurfaceDiameter - foregroundDiameter
        }
        
        /** Initializer */
        public init() {}
    }
}
