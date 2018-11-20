//
//  UIView+PositionUtils.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/19/18.
//

import Foundation

extension UIView {
    
    var minX: CGFloat {
        return center.x - bounds.width * 0.5
    }
    
    var maxX: CGFloat {
        return center.x + bounds.width * 0.5
    }
    
    var minY: CGFloat {
        return center.y - bounds.height * 0.5
    }
    
    var maxY: CGFloat {
        return center.y + bounds.height * 0.5
    }
}
