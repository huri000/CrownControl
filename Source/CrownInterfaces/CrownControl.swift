//
//  CrownControl.swift
//  CrownControl
//
//  Created by Daniel Huri on 12/1/18.
//

import Foundation

/** Clean crown provider */
public class CrownControl {
    
    // MARK: - Properties
    
    /** The crown surface controller */
    private let crownSurfaceController: CrownSurfaceController
    
    /** Transmits the information about the crown progress*/
    private weak var delegate: CrownControlDelegate!
    
    /** The reported progress of the foreground, represented at a float value in the range [0...1] */
    public var progress: CGFloat {
        return crownSurfaceController.progress
    }
    
    /** The current angle of the foreground view within the crown surface */
    public var foregroundAngle: CGFloat {
        return crownSurfaceController.currentForegroundAngle
    }
    
    // MARK: - Setup

    public init(attributes: CrownAttributes, delegate: CrownControlDelegate? = nil) {
        crownSurfaceController = CrownSurfaceController(attributes: attributes, delegate: delegate)
    }
    
    // MARK: - Exposed
    
    /**
     Add the crown view controller as a child of a parent view controller and layout it vertically and horizontally.
     - parameter superview: The superview.
     - parameter horizontalConstaint: Horizontal constraint construct.
     - parameter verticalConstraint: Vertical constraint construct.
     */
    public func layout(in superview: UIView, horizontalConstaint: CrownAttributes.AxisConstraint, verticalConstraint: CrownAttributes.AxisConstraint) {
        crownSurfaceController.view.layout(in: superview, horizontalConstaint: horizontalConstaint, verticalConstraint: verticalConstraint)
    }
    
    /**
     Spins the crown's foreground to a given progress in the range of [0...1].
     - parameter progress: The progress of the spin from 0 to 1. Reflects the offset in the bound scroll view.
     */
    public func spin(to progress: CGFloat) {
        crownSurfaceController.spin(to: progress)
    }
    
    /**
     Spins the crown's foreground to match the scroll view offset
     */
    public func spinToMatchScrollViewOffset() {
        crownSurfaceController.spinToMatchScrollViewOffset()
    }
}

// MARK: - CrownFunctionalDelegate

extension CrownControl: CrownFunctionalDelegate {
    func crownDidBeginSpinning() {
        delegate?.crownDidBeginSpinning(self)
    }
    
    func crownDidEndSpinning() {
        delegate?.crownDidEndSpinning(self)
    }
    
    func crownWillUpdate() {
        delegate?.crown(self, willUpdate: progress)
    }
    
    func crownDidUpdate() {
        delegate?.crown(self, didUpdate: progress)
    }
}
