//
//  CrownAttributes+UserInteraction.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/14/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import Foundation

public extension CrownAttributes {
    
    /** Describes the interactions of the user with the crown */
    public struct UserInteraction {
        
        /** Desrcribes a certain action that takes place upon user gestures */
        public enum TapAction {
            
            /** A custom user action type */
            public typealias Custom = () -> Void
            
            /** Scrolls forward to an additional given offset. Corresponds to *ScrollAxis* */
            case scrollsForwardWithOffset(value: CGFloat)
            
            /** Subtract value form the current offset. Corresponds to *ScrollAxis* */
            case scrollsBackwardWithOffset(value: CGFloat)
            
            /** Scrolls to the fathest leading edge of the scroll-view */
            case scrollsToLeadingEdge
            
            /**
             Scrolls to the farthest trailing edge of the scroll-view.
             Warning: In some cases the scroll view uses auto-layout (table view with estimated cell height),
             this might not work. Recommanded for small
             */
            case scrollsToTrailingEdge
            
            /** Scrolls to the leading **page** of the scroll-view (which is an edge length of the scroll-view itself) */
            case scrollsToLeadingPage
            
            /** Scrolls to the trailing **page** of the scroll-view (which is an edge length of the scroll-view itself) */
            case scrollsToTrailingPage
            
            /** Customizable action */
            case custom(action: Custom)
            
            /** No action at all */
            case none
            
            var isInteractable: Bool {
                switch self {
                case .none:
                    return false
                default:
                    return true
                }
            }
        }
        
        /** Drag and drop action */
        public enum RepositionGesture {
            
            public struct Attributes {
                
                public struct ForceTouch {
                    public var maxScale: CGFloat = 1.5
                    public var scaleUpThreshold: CGFloat = 1.25
                    public var scaleDownThreshold: CGFloat = 1.05

                    public init() {}
                }
                
                public struct LongPress {
                    public var minimalDuration: TimeInterval = 0.5
                    
                    public init() {}
                }
            }
            
            /** Force touch enables the user to drag-and-drop. Prefer to use force touch in case the device hardware supports it. */
            case prefersForceTouch(attributes: Attributes.ForceTouch)
            
            /** Prefer long press over force touch. Works on all the devices */
            case longPress(attributes: Attributes.LongPress)
            
            var isForceTouch: Bool {
                switch self {
                case .prefersForceTouch:
                    return true
                default:
                    return false
                }
            }
            
            var isLongPress: Bool {
                switch self {
                case .longPress:
                    return true
                default:
                    return false
                }
            }
            
            var longPressDuration: TimeInterval {
                switch self {
                case .longPress(attributes: let attributes):
                    return attributes.minimalDuration
                default:
                    fatalError("longPressDuration is not implemented")
                }
            }
        }

        /** Describes the action that takes place upon a single tap on the crown */
        public var singleTap = TapAction.scrollsToTrailingPage
        
        /** Describes the action that takes place upon a double tap on the crown */
        public var doubleTap = TapAction.scrollsToLeadingEdge
        
        /** The gesture that invokes the reposition action */
        public var repositionGesture = RepositionGesture.prefersForceTouch(attributes: .init())

        /** Initializer */
        public init() {}
    }
}
