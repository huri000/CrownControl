//
//  CrownAttributesViewModel.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/30/18.
//

import Foundation

/** This construct's purpose is using CrownAttributes instance to peform actions in the name of the controller itself */
class CrownAttributesViewModel {
    
    // MARK: - Types
    
    // Convenience typealias for using attributes' nested typed tap action descriptor in the class context
    typealias TapAction = CrownAttributes.UserInteraction.TapAction
    
    // Pan subject
    enum PanSubject {
        case indicator
        case crown
        
        var alpha: CGFloat {
            switch self {
            case .crown:
                return 0.8
            case .indicator:
                return 1
            }
        }
    }
    
    // The subject of the pan gesture recognizer
    var panSubject = PanSubject.indicator {
        didSet {
            HapticFeedbackGenerator.select()
        }
    }

    // MARK: - Poperties
    
    private let attributes: CrownAttributes
    
    let crownAnchorPoint: CGPoint
    
    private(set) lazy var view: UIView = {
        return UIView()
    }()
    
    // Syntactic sugar for accessing the scroll view
    private var scrollView: UIScrollView? {
        return attributes.scrollView
    }
    
    var isForceTouchAvailable: Bool {
        return view.traitCollection.forceTouchCapability == .available && attributes.userInteraction.repositionGesture.isForceTouch
    }
    
    /** The progress of the foreground indicator */
    public var progress: CGFloat = 0
    
    var previousForegroundAngle: CGFloat = 0
    var currentForegroundAngle: CGFloat = 0
    
    // MARK: - Setup
    
    init(using attributes: CrownAttributes) {
        self.attributes = attributes
        currentForegroundAngle = attributes.anchorPosition.radians
        previousForegroundAngle = currentForegroundAngle
        crownAnchorPoint = attributes.sizes.crownCenter
    }
    
    /** Perform a given tap action */
    func performTapActionIfNeeded(_ tapAction: TapAction) {
        guard let scrollView = scrollView, panSubject == .indicator else {
            return
        }
        
        switch tapAction {
        case .scrollsForwardWithOffset(value: let offset):
            scrollView.add(offset: offset, to: attributes.scrollAxis)
        case .scrollsBackwardWithOffset(value: let offset):
            scrollView.subtract(offset: offset, from: attributes.scrollAxis)
        case .scrollsToLeadingEdge:
            scrollView.scrollToLeadingEdge(using: attributes.scrollAxis)
        case .scrollsToTrailingEdge:
            scrollView.scrollToTrailingEdge(using: attributes.scrollAxis)
        case .scrollsToLeadingPage:
            scrollView.scrollToLeadingPage(using: attributes.scrollAxis)
        case .scrollsToTrailingPage:
            scrollView.scrollToTrailingPage(using: attributes.scrollAxis)
        case .custom(action: let action):
            action()
        case .none:
            break
        }
    }
}

// MARK: - Bounds / Frames / Movement related logic

extension CrownAttributesViewModel {
    
    var isAbleToSpin: Bool {
        guard let scrollView = attributes.scrollView else {
            return false
        }
        let contentSize: CGFloat
        let edgeSize: CGFloat
        
        switch attributes.scrollAxis {
        case .vertical:
            contentSize = scrollView.contentSize.height
            edgeSize = scrollView.bounds.height
        case .horizontal:
            contentSize = scrollView.contentSize.width
            edgeSize = scrollView.bounds.width
        }
        return contentSize - edgeSize > 0
    }
    
    // Returns true when the crown indicator reaches the leading edge
    var hasForegroundReachedLeadingEdge: Bool {
        let currentAngle = currentForegroundAngle - attributes.anchorPosition.radians
        let previousAngle = previousForegroundAngle - attributes.anchorPosition.radians
        return currentAngle == 0 && previousAngle != currentAngle
    }
    
    // Returns true when the crown indicator reaches the trailing edge
    var hasForegroundReachedTrailingEdge: Bool {
        return (currentForegroundAngle == attributes.sizes.maximumAngleInRadian + attributes.anchorPosition.radians)
            && previousForegroundAngle != currentForegroundAngle
    }

    /** The frame of the crown surface superview */
    var superviewBounds: CGRect {
        guard let superview = view.superview else {
            return .zero
        }
        let insets = attributes.sizes.superviewEdgeInsets
        return CGRect(x: insets.left, y: insets.top, width: superview.bounds.width - insets.right - insets.left, height: superview.bounds.height - insets.bottom - insets.top)
    }
    
    /** The frame of the crown within its superview */
    var crownFrame: CGRect {
        let minX = view.minX
        let minY = view.minY
        return CGRect(x: minX, y: minY, width: view.maxX - minX, height: view.maxY - minY)
    }

    /** Test if the crown surface is within predetermind horizontal bounds */
    func isCrownWithinHorizontalBounds(after translation: CGFloat, velocity: CGFloat) -> Bool {
        let superviewBounds = self.superviewBounds
        let minX = view.minX + translation
        let maxX = view.maxX + translation
        return (minX >= superviewBounds.minX || velocity >= 0) && (maxX <= superviewBounds.maxX || velocity <= 0)
    }
    
    /** Test if the crown surface is within predetermind vertical bounds */
    func isCrownWithinVerticalBounds(after translation: CGFloat, velocity: CGFloat) -> Bool {
        let superviewBounds = self.superviewBounds
        let minY = view.minY + translation
        let maxY = view.maxY + translation
        return (minY >= superviewBounds.minY || velocity >= 0) && (maxY <= superviewBounds.maxY || velocity <= 0)
    }
    
    /** Move the crown surface to a selected location */
    func changeCrownLocation(to location: CGPoint) {
        guard superviewBounds.contains(location) else {
            return
        }
        let currentLocation = view.center
        
        let xDiff = (location.x - currentLocation.x)
        let yDiff = (location.y - currentLocation.y)
        let distance = sqrt(xDiff * xDiff + yDiff * yDiff)
        
        let duration: TimeInterval
        if distance > 1 {
            duration = 0.1
        } else {
            duration = 0
        }
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction], animations: {
            self.view.center = location
        }, completion: nil)
    }
    
    // MARK: - Calculation Accessors
    
    func calculateForegroundCenter(by radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = crownAnchorPoint.x + radius * cos(angle)
        let y = crownAnchorPoint.y + radius * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    /** Get angle of a single foreground view within the crown surface */
    @discardableResult
    func angle(of foregroundView: UIView, by center: CGPoint) -> CGFloat {
        let v1 = CGVector(dx: foregroundView.center.x - crownAnchorPoint.x, dy: foregroundView.center.y - crownAnchorPoint.y)
        let v2 = CGVector(dx: center.x - crownAnchorPoint.x, dy: center.y - crownAnchorPoint.y)
        
        var newAngleAddition = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        if newAngleAddition > .pi * 1.5 {
            newAngleAddition = newAngleAddition - .pi * 2
        } else if newAngleAddition < -.pi * 1.5 {
            newAngleAddition = .pi * 2 + newAngleAddition
        }
        var currentForegroundAngle = self.currentForegroundAngle
        currentForegroundAngle += newAngleAddition
        
        let startingPoint = attributes.anchorPosition.radians
        let endingPoint = attributes.sizes.maximumAngleInRadian + startingPoint
        if currentForegroundAngle < startingPoint {
            currentForegroundAngle = startingPoint
        } else if currentForegroundAngle > endingPoint {
            currentForegroundAngle = endingPoint
        }
        
        // TODO: Improve edge block caclulation
        if abs(currentForegroundAngle - previousForegroundAngle) >= .pi * 0.05 &&
            (previousForegroundAngle == startingPoint || previousForegroundAngle == endingPoint) {
            return self.currentForegroundAngle
        } else {
            return currentForegroundAngle
        }
    }
    
    /** Updates the scroll-view offset in accordance with the progress and the scroll axis */
    func updateScrollViewOffset() {
        guard let scrollView = scrollView else {
            return
        }
        
        let contentSize: CGFloat
        let edgeSize: CGFloat
        
        switch attributes.scrollAxis {
        case .vertical:
            contentSize = scrollView.contentSize.height
            edgeSize = scrollView.bounds.height
        case .horizontal:
            contentSize = scrollView.contentSize.width
            edgeSize = scrollView.bounds.width
        }
        
        var newAxisOffset = progress * (contentSize - edgeSize)
        
        if newAxisOffset < 0 {
            newAxisOffset = 0
        } else if contentSize >= edgeSize {
            let maxAxisOffset = contentSize - edgeSize
            if newAxisOffset > maxAxisOffset {
                newAxisOffset = maxAxisOffset
            }
        }
        
        var contentOffset = scrollView.contentOffset
        
        switch attributes.scrollAxis {
        case .vertical:
            contentOffset.y = newAxisOffset
        case .horizontal:
            contentOffset.x = newAxisOffset
        }
        scrollView.setContentOffset(contentOffset, animated: false)
    }
}

// MARK: - User Actions

extension CrownAttributesViewModel {

    /** Simulate long press of the crown surface */
    func longPress(with state: UIGestureRecognizer.State, location: CGPoint) {
        switch state {
        case .began:
            panSubject = .crown
            view.alpha = panSubject.alpha
        case .changed:
            changeCrownLocation(to: location)
        case .cancelled, .ended, .failed:
            panSubject = .indicator
            view.alpha = panSubject.alpha
        case .possible:
            break
        }
    }
    
    func force(force: CGFloat, max: CGFloat) {
        guard isForceTouchAvailable else {
            return
        }
        
        guard case CrownAttributes.UserInteraction.RepositionGesture.prefersForceTouch(attributes: let forceTouchAttributes) = attributes.userInteraction.repositionGesture else {
            return
        }
        
        let newScale = (forceTouchAttributes.maxScale - 1.0) * force / max + 1.0
        if newScale > forceTouchAttributes.scaleUpThreshold {
            if panSubject == .indicator {
                panSubject = .crown
            }
            view.alpha = panSubject.alpha
        } else if newScale < forceTouchAttributes.scaleDownThreshold {
            if panSubject == .crown {
                panSubject = .indicator
            }
            view.alpha = panSubject.alpha
        }
        
        let transform = {
            self.view.transform = self.attributes.crownTransform.concatenating(CGAffineTransform(scaleX: newScale, y: newScale))
        }
        
        if force == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                transform()
            }, completion: nil)
        } else {
            transform()
        }
    }
    
}
