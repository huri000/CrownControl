//
//  CGPoint+Utils.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/10/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}
