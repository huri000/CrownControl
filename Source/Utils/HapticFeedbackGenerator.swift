//
//  HapticFeedbackGenerator.swift
//  CrownControl
//
//  Created by Daniel Huri on 4/20/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

struct HapticFeedbackGenerator {
    static func generate(impact: CrownAttributes.Feedback.Descripter.ImpactHaptic) {
        guard #available(iOS 10.0, *) else {
            return
        }
        guard let value = impact.value else {
            return
        }
        let generator = UIImpactFeedbackGenerator(style: value)
        generator.impactOccurred()
    }
    
    static func select() {
        guard #available(iOS 10.0, *) else {
            return
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
