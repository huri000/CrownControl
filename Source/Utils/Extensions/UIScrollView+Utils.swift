//
//  UIScrollView+Utils.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/14/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func progress(by axis: CrownAttributes.ScrollAxis) -> CGFloat {
        var offset: CGFloat = 0
        switch axis {
        case .vertical where contentSize.height > bounds.height:
            offset = contentOffset.y / (contentSize.height - bounds.height)
        case .horizontal where contentSize.width > bounds.width:
            offset = contentOffset.x / (contentSize.width - bounds.width)
        default:
            break
        }
        return offset
    }
    
    func scrollToLeadingEdge(using axis: CrownAttributes.ScrollAxis, animated: Bool = true) {
        let point: CGPoint
        switch axis {
        case .vertical:
            point = CGPoint(x: contentOffset.x, y: 0)
        case .horizontal:
            point = CGPoint(x: 0, y: contentOffset.y)
        }
        setContentOffset(point, animated: animated)
    }
    
    func scrollToTrailingEdge(using axis: CrownAttributes.ScrollAxis, animated: Bool = true) {
        switch axis {
        case .vertical where contentSize.height > bounds.size.height:
            let frame = CGRect(x: contentOffset.x, y: contentSize.height - 1.0, width: contentSize.width, height: 1.0)
            scrollRectToVisible(frame, animated: animated)
        case .horizontal where contentSize.width > bounds.size.width:
            let frame = CGRect(x: contentSize.width - 1.0, y: contentOffset.y, width: 1, height: contentSize.height)
            scrollRectToVisible(frame, animated: animated)
        default:
            break
        }
    }
    
    func scrollToLeadingPage(using axis: CrownAttributes.ScrollAxis, animated: Bool = true) {
        let additionalOffset: CGFloat
        switch axis {
        case .vertical:
            additionalOffset = bounds.height
        case .horizontal:
            additionalOffset = bounds.width
        }
        subtract(offset: additionalOffset, from: axis)
    }
    
    func scrollToTrailingPage(using axis: CrownAttributes.ScrollAxis, animated: Bool = true) {
        let additionalOffset: CGFloat
        switch axis {
        case .vertical:
            additionalOffset = bounds.height
        case .horizontal:
            additionalOffset = bounds.width
        }
        add(offset: additionalOffset, to: axis)
    }
    
    func subtract(offset: CGFloat, from axis: CrownAttributes.ScrollAxis, animated: Bool = true) {
        let point: CGPoint
        switch axis {
        case .vertical:
            let yOffset = contentOffset.y - offset
            if yOffset >= 0 {
                point = CGPoint(x: contentOffset.x, y: yOffset)
            } else {
                point = CGPoint(x: contentOffset.x, y: 0)
            }
        case .horizontal:
            let xOffset = contentOffset.x - offset
            if xOffset >= 0 {
                point = CGPoint(x: xOffset, y: contentOffset.y)
            } else {
                point = CGPoint(x: 0, y: contentOffset.y)
            }
        }
        setContentOffset(point, animated: animated)
    }
    
    func add(offset: CGFloat, to axis: CrownAttributes.ScrollAxis, animated: Bool = true) {
        let maxOffset = maxContentOffset(for: axis)
        var point = contentOffset
        switch axis {
        case .vertical:
            let yOffset = contentOffset.y + offset
            if yOffset <= maxOffset.y {
                point = CGPoint(x: contentOffset.x, y: yOffset)
            } else {
                point = CGPoint(x: contentOffset.x, y: maxOffset.y)
            }
        case .horizontal:
            let xOffset = contentOffset.x + offset
            if xOffset < maxOffset.x {
                point = CGPoint(x: xOffset, y: contentOffset.y)
            } else {
                point = CGPoint(x: maxOffset.x, y: contentOffset.y)
            }
        }
        setContentOffset(point, animated: animated)
    }

    func maxContentOffset(for axis: CrownAttributes.ScrollAxis, animated: Bool = true) -> CGPoint {
        var offset = contentOffset
        switch axis {
        case .vertical:
            offset.y = contentSize.height - bounds.height
            if offset.y < 0 {
                offset.y = 0
            }
        case .horizontal:
            offset.x = contentSize.width - bounds.width
            if offset.x < 0 {
               offset.x = 0
            }
        }
        return offset
    }
}
