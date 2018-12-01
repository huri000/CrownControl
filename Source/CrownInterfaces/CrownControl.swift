//
//  CrownControl.swift
//  CrownControl
//
//  Created by Daniel Huri on 12/1/18.
//

import Foundation

/** Clean crown provider */
public struct CrownControl {
    
    // MARK: - Types
    
    public enum Style {
        case indicator
    }
    
    // MARK: - Properties
    
    private let crownViewController: CrownViewController
    
    public var progress: CGFloat {
        return crownViewController.progress
    }
    
    public var foregroundAngle: CGFloat {
        return crownViewController.foregroundAngle
    }
    
    // MARK: - Types
    
    public init(attributes: CrownAttributes, delegate: CrownControlDelegate? = nil, style: Style = .indicator) {
        crownViewController = CrownIndicatorViewController(with: attributes, delegate: delegate)
    }
    
    // MARK: - Exposed
    
    /**
     Add the crown view controller as a child of a parent view controller and layout it vertically and horizontally.
     - parameter parent: A parent view controller.
     - parameter horizontalConstaint: Horizontal constraint construct.
     - parameter verticalConstraint: Vertical constraint construct.
     */
    public func layout(in parent: UIViewController, horizontalConstaint: CrownAttributes.AxisConstraint, verticalConstraint: CrownAttributes.AxisConstraint) {
        crownViewController.layout(in: parent, horizontalConstaint: horizontalConstaint, verticalConstraint: verticalConstraint)
    }
    
    /**
     Spins the crown's foreground to a given progress in the range of [0...1].
     - parameter progress: The progress of the spin from 0 to 1. Reflects the offset in the bound scroll view.
     */
    public func spin(to progress: CGFloat) {
        crownViewController.spin(to: progress)
    }
    
    /**
     Spins the crown's foreground to match the scroll view offset
     */
    public func spinToMatchScrollViewOffset() {
        crownViewController.spinToMatchScrollViewOffset()
    }
}
