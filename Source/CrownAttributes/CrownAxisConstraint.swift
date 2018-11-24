//
//  CrownAxisConstraint.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/24/18.
//

import UIKit
import QuickLayout

public struct CrownAxisConstraint {
    public let crownEdge: QLAttribute
    public let anchorView: UIView
    public let anchorViewEdge: QLAttribute
    public let offset: CGFloat
    
    public init(crownEdge: QLAttribute, anchorView: UIView, anchorViewEdge: QLAttribute, offset: CGFloat = 0) {
        self.crownEdge = crownEdge
        self.anchorView = anchorView
        self.anchorViewEdge = anchorViewEdge
        self.offset = offset
    }
}
