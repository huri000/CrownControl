//
//  ClockCrownAttributes.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/13/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

// TODO: WIP right now
class ClockCrownAttributes: CrownAttributes {
    
    struct HandStyle {
        var radiusRatio: CGFloat
        var color: UIColor
    }
    
    var minutesHandStyle = HandStyle(radiusRatio: 0.8, color: .white)
    var hoursHandStyle = HandStyle(radiusRatio: 0.5, color: .white)
}
