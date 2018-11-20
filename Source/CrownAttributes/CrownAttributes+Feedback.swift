//
//  CrownAttributes+Feedback.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/14/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

public extension CrownAttributes {
    
    /** Describes the feedback that is generated when the crown reaches the leading or the trailing position */
    public struct Feedback {
        
        /** The feedback descriptor */
        public struct Descripter {
            
            /** The impact haptic feedback that is generated */
            public enum ImpactHaptic {
                case light
                case medium
                case heavy
                case none
                
                @available(iOS 10.0, *)
                var value: UIImpactFeedbackGenerator.FeedbackStyle? {
                    switch self {
                    case .light:
                        return .light
                    case .medium:
                        return .medium
                    case .heavy:
                        return .heavy
                    case .none:
                        return nil
                    }
                }
                
                var isValid: Bool {
                    return self != .none
                }
            }
            
            /** Describes a flash animation */
            public enum Flash {
                case active(color: UIColor, fadeDuration: TimeInterval)
                case none
            }
            
            /** Impact haptic feedback type */
            public var impactHaptic = ImpactHaptic.heavy
            
            /** The background flash feedback */
            public var backgroundFlash = Flash.active(color: UIColor(white: 0.8, alpha: 1), fadeDuration: 0.15)
            
            /** The foreground flash feedback */
            public var foregroundFlash = Flash.none
            
            /** Initializer */
            public init() {}
        }
        
        /** Leading edge collision descriptor */
        public var leading = Descripter()
        
        /** Trailing edge collision descriptor */
        public var trailing = Descripter()
        
        /** Initializer */
        public init() {}
    }
}
