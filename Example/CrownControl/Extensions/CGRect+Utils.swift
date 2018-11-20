//
//  CGRect+Utils.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/19/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
