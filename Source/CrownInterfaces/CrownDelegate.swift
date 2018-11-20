//
//  CrownDelegate.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/19/18.
//

import Foundation

/** Delegate for crown spin events */
public protocol CrownDelegate: class {
    
    /** Called after the crown begins spinning */
    func crownDidBeginSpinning(_ crownViewController: CrownViewController)
    
    /** Called after the crown ends spinning */
    func crownDidEndSpinning(_ crownViewController: CrownViewController)
    
    /** Called after the crown updates */
    func crown(_ crownViewController: CrownViewController, didUpdate progress: CGFloat)
    
    /** Called before the crown updates */
    func crown(_ crownViewController: CrownViewController, willUpdate progress: CGFloat)
}

/** Default empty implementation of the crown delegation methods */
public extension CrownDelegate {
    func crownDidBeginSpinning(_ crownViewController: CrownViewController) {}
    func crownDidEndSpinning(_ crownViewController: CrownViewController) {}
    func crown(_ crownViewController: CrownViewController, didUpdate progress: CGFloat) {}
    func crown(_ crownViewController: CrownViewController, willUpdate progress: CGFloat) {}
}
