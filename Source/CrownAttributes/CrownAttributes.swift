//
//  CrownAttributes.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/10/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

/** Crown attributes descriptor */
public class CrownAttributes {

    /** A scroll view which is bound to the crown */
    weak var scrollView: UIScrollView?
    
    /** The scroll axis */
    public var scrollAxis = ScrollAxis.vertical
    
    /** The anchor position of the indicator (Where the it points) */
    public var anchorPosition = AnchorPosition.right
    
    /** The direction of the spin */
    public var spinDirection = SpinDirection.clockwise
    
    /** Describes the user interactions with the crown */
    public var userInteractions = UserInteractions()
    
    /** The background style, shadow, and border */
    public var backgroundStyle = Style()
    
    /** The foreground style, shadow, and border */
    public var forgroundStyle = Style()

    /** The size of the crown and indicator */
    public var sizes = Sizes()
    
    /** Feedback descriptor for reaching the leading or trailing edges of the crown */
    public var feedback = Feedback()
    
    /** Initializer */
    public init(using scrollView: UIScrollView? = nil) {
        self.scrollView = scrollView
    }
}
