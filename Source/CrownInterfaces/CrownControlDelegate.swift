//
//  CrownControlDelegate.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/19/18.
//

import Foundation

/** Delegate for crown spin events */
public protocol CrownControlDelegate: class {
    
    /** Called after the crown begins spinning */
    func crownDidBeginSpinning(_ crownControl: CrownControl)
    
    /** Called after the crown ends spinning */
    func crownDidEndSpinning(_ crownControl: CrownControl)
    
    /** Called after the crown updates */
    func crown(_ crownControl: CrownControl, didUpdate progress: CGFloat)
    
    /** Called before the crown updates */
    func crown(_ crownControl: CrownControl, willUpdate progress: CGFloat)
}

/** Default empty implementation of the crown delegation methods */
public extension CrownControlDelegate {
    func crownDidBeginSpinning(_ crownControl: CrownControl) {}
    func crownDidEndSpinning(_ crownControl: CrownControl) {}
    func crown(_ crownControl: CrownControl, didUpdate progress: CGFloat) {}
    func crown(_ crownControl: CrownControl, willUpdate progress: CGFloat) {}
}
