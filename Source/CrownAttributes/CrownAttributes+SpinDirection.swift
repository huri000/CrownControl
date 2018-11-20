//
//  CrownAttributes+SpinDirection.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/15/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import Foundation

public extension CrownAttributes {
    
    /** The direction of the foreground spin */
    public enum SpinDirection {
        
        /** Clockwise */
        case clockwise
        
        /** Counter clockwise */
        case counterClockwise
        
        /** Returns *true* if the direction is *clockwise* */
        var isClockwise: Bool {
            return self == .clockwise
        }
    }
}
