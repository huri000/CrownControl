//
//  HapticFeedbackGenerator.swift
//  CrownControl
//
//  Created by Daniel Huri on 4/20/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

struct HapticFeedbackGenerator {
    
    @discardableResult
    static func generate(impact: CrownAttributes.Feedback.Descripter.ImpactHaptic) -> Bool {
        guard #available(iOS 10.0, *) else {
            return false
        }
        guard let value = impact.value else {
            return false
        }
        let generator = UIImpactFeedbackGenerator(style: value)
        generator.impactOccurred()
        return true
    }
    
    @discardableResult
    static func select() -> Bool {
        guard #available(iOS 10.0, *) else {
            return false
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        return true
    }
}
