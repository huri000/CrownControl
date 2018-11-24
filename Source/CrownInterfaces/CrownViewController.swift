//
//  CrownViewController.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/11/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import QuickLayout

/** A crown view controller component */
public class CrownViewController: UIViewController {

    // MARK: - Types
    
    private enum PanSubject {
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
    private var panSubject = PanSubject.indicator
    
    // Delegate for the crown spin events
    private weak var delegate: CrownDelegate!
    
    private var previousAngleInRadians: CGFloat = 0
    private(set) var currentAngleInRadians: CGFloat = 0
    
    private var lockPanGesture = false

    let crownAnchorPoint: CGPoint
    
    /** The progress of the foreground indicator */
    public private(set) var progress: CGFloat = 0
    
    var indicatorView: UIView {
        preconditionFailure("\(#function) be overridden by subclass")
    }
    
    private let contentView = UIView()

    // Gesture Recognizers
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var singleTapGestureRecognizer: UITapGestureRecognizer!
    private var doubleTapGestureRecognizer: UITapGestureRecognizer!
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!

    // Size constraints
    private var horizontalConstraint: NSLayoutConstraint!
    private var verticalConstraint: NSLayoutConstraint!
    
    private var originalHorizontalOffset: CGFloat = 0
    private var originalVerticalOffset: CGFloat = 0
    
    private var isForceTouchAvailable: Bool {
        return traitCollection.forceTouchCapability == .available && attributes.userInteractions.placementGesture.isForceTouch
    }
    
    // Returns true when the crown indicator reaches the leading edge
    private var hasReachedLeadingEdge: Bool {
        let currentAngle = currentAngleInRadians - attributes.anchorPosition.radians
        let previousAngle = previousAngleInRadians - attributes.anchorPosition.radians
        return currentAngle == 0 && previousAngle != currentAngle
    }
    
    // Returns true when the crown indicator reaches the trailing edge
    private var hasReachedTrailingEdge: Bool {
        return (currentAngleInRadians == attributes.sizes.maximumAngleInRadian + attributes.anchorPosition.radians)
            && previousAngleInRadians != currentAngleInRadians
    }
    
    // Returns the bounds of the crown's superview
    private var superviewBounds: CGRect {
        guard let superview = view.superview else {
            return .zero
        }
        let insets = attributes.sizes.superviewEdgeInsets
        return CGRect(x: insets.left, y: insets.top, width: superview.bounds.width - insets.right - insets.left, height: superview.bounds.height - insets.bottom - insets.top)
    }
    
    private var crownFrame: CGRect {
        let minX = view.minX
        let minY = view.minY
        return CGRect(x: minX, y: minY, width: view.maxX - minX, height: view.maxY - minY)
    }
    
    // The crown attributes descriptor
    let attributes: CrownAttributes
    
    // MARK: UI Elements
    
    private lazy var backgroundView: BackgroundView = {
        let backgroundView = BackgroundView(background: attributes.backgroundStyle)
        contentView.addSubview(backgroundView)
        backgroundView.fillSuperview()
        return backgroundView
    }()
    
    // MARK: - Lifecycle
    
    public init(with attributes: CrownAttributes, delegate: CrownDelegate? = nil) {
        self.attributes = attributes
        self.delegate = delegate
        crownAnchorPoint = attributes.sizes.crownCenter
        currentAngleInRadians = attributes.anchorPosition.radians
        previousAngleInRadians = currentAngleInRadians
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = UIView()
        view.frame = CGRect(origin: .zero, size: attributes.sizes.backgroundSurfaceSquareSize)
        view.addSubview(contentView)
        view.isExclusiveTouch = true
        
        contentView.set(.width, .height, of: attributes.sizes.backgroundSurfaceDiameter)
        contentView.layoutToSuperview(.left, .right, .top, .bottom)
        contentView.addSubview(backgroundView)
        
        setupUserInteractions()
        
        view.transform = attributes.crownTransform
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Setup
    
    private func setupUserInteractions() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized))
        panGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(panGestureRecognizer)

        if attributes.userInteractions.doubleTap.isInteractable {
            doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureRecognized))
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            view.addGestureRecognizer(doubleTapGestureRecognizer)
        }
        
        if attributes.userInteractions.singleTap.isInteractable {
            singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapGestureRecognized))
            singleTapGestureRecognizer.numberOfTapsRequired = 1
            if let doubleTapGestureRecognizer = doubleTapGestureRecognizer {
                singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
            }
            view.addGestureRecognizer(singleTapGestureRecognizer)
        }
        
        if !isForceTouchAvailable && attributes.userInteractions.placementGesture.isLongPress {
            longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
            longPressGestureRecognizer.minimumPressDuration = attributes.userInteractions.placementGesture.longPressDuration
            view.addGestureRecognizer(longPressGestureRecognizer)
        }
    }
    
    // MARK: - Orientation
    
    // Normalize the position of the crown surface after device orientation change
    @objc private func deviceOrientationDidChange() {
        spin(to: progress)
        
        let superviewBounds = self.superviewBounds
        
        if view.minX < superviewBounds.minX {
            horizontalConstraint.constant = originalHorizontalOffset
        } else if view.maxX > superviewBounds.maxX {
            horizontalConstraint.constant = originalHorizontalOffset
        }

        if view.minY < superviewBounds.minY {
            verticalConstraint.constant = originalVerticalOffset
        } else if view.maxY > superviewBounds.maxY {
            verticalConstraint.constant = originalVerticalOffset
        }
    }
    
    // MARK: - User Interactions
    
    private func crownTapped(using action: CrownAttributes.UserInteractions.TapAction) {
        guard panSubject == .indicator else {
            return
        }
        
        switch action {
        case .scrollsForwardWithOffset(value: let offset):
            attributes.scrollView?.add(offset: offset, to: attributes.scrollAxis)
        case .scrollsBackwardWithOffset(value: let offset):
            attributes.scrollView?.subtract(offset: offset, from: attributes.scrollAxis)
        case .scrollsToLeadingEdge:
            attributes.scrollView?.scrollToLeadingEdge(using: attributes.scrollAxis)
        case .scrollsToTrailingEdge:
            attributes.scrollView?.scrollToTrailingEdge(using: attributes.scrollAxis)
        case .scrollsToLeadingPage:
            attributes.scrollView?.scrollToLeadingPage(using: attributes.scrollAxis)
        case .scrollsToTrailingPage:
            attributes.scrollView?.scrollToTrailingPage(using: attributes.scrollAxis)
        case .custom(action: let action):
            action()
        case .none:
            break
        }
    }
    
    @objc private func doubleTapGestureRecognized(_ gestureRecognizer: UITapGestureRecognizer) {
        crownTapped(using: attributes.userInteractions.doubleTap)
    }
    
    @objc private func singleTapGestureRecognized(_ gestureRecognizer: UITapGestureRecognizer) {
        crownTapped(using: attributes.userInteractions.singleTap)
    }
    
    @objc private func longPressGestureRecognized(_ gestureRecognizer: UILongPressGestureRecognizer) {
        longPressCrownSurface(using: gestureRecognizer)
    }
    
    @objc private func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch (panSubject, attributes.userInteractions.placementGesture.isForceTouch) {
        case (.indicator, _):
            panIndicator(using: gestureRecognizer)
        case (.crown, true):
            panCrownSurface(using: gestureRecognizer)
        default:
            break
        }
    }

    private func longPressCrownSurface(using gestureRecognizer: UILongPressGestureRecognizer) {
        guard let superview = view.superview else {
            return
        }
        let state = gestureRecognizer.state
        switch state {
        case .began:
            panSubject = .crown
            HapticFeedbackGenerator.select()
            view.alpha = panSubject.alpha
        case .changed:
            let location = gestureRecognizer.location(in: superview)
            
            if superviewBounds.contains(location) {
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
        case .cancelled, .ended, .failed:
            HapticFeedbackGenerator.select()
            panSubject = .indicator
            view.alpha = panSubject.alpha
        case .possible:
            break
        }
    }
    
    private func panCrownSurface(using gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = view.superview else {
            return
        }
        let state = gestureRecognizer.state
        switch state {
        case .began:
            break
        case .changed:
            defer {
                gestureRecognizer.setTranslation(.zero, in: superview)
            }
            
            let translation = gestureRecognizer.translation(in: superview)
            let velocity = gestureRecognizer.velocity(in: superview)
            
            if isCrownWithinHorizontalBounds(after: translation.x, velocity: velocity.x) {
                horizontalConstraint.constant += translation.x
            }
            
            if isCrownWithinVerticalBounds(after: translation.y, velocity: velocity.y) {
                verticalConstraint.constant += translation.y
            }
            
        case .cancelled, .ended, .failed:
            break
        case .possible:
            break
        }
    }
    
    private func panIndicator(using gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = view.superview else {
            return
        }
        let state = gestureRecognizer.state
        switch state {
        case .began:
            delegate?.crownDidBeginSpinning(self)
        case .changed:
            
            lockPanGesture = true
            
            let translation = gestureRecognizer.translation(in: superview)
            
            // Update current angle
            currentAngleInRadians = updateAngle(of: indicatorView, by: indicatorView.center + translation)
            
            // Inform delegate pre update
            delegate?.crown(self, willUpdate: progress)
            
            // Make the translation
            translate()
            
            // Update progress
            progress = (currentAngleInRadians - attributes.anchorPosition.radians) / attributes.sizes.maximumAngleInRadian
            
            // Update scroll view offset by progress
            updateScrollViewOffset()
            
            // Update delegate after the progress update
            delegate?.crown(self, didUpdate: progress)
            
            // Generate haptic feedback
            generateEdgeFeedbackIfNecessary()
            
            // Update previous angle
            previousAngleInRadians = currentAngleInRadians
            
            gestureRecognizer.setTranslation(.zero, in: superview)
            lockPanGesture = false
            
        case .cancelled, .ended, .failed:
            delegate?.crownDidEndSpinning(self)
        case .possible:
            break
        }
    }
    
    // MARK: - Feedback Generation
    
    private func generateEdgeFeedbackIfNecessary() {
        if hasReachedLeadingEdge {
            generate(edgeFeedback: attributes.feedback.leading)
        } else if hasReachedTrailingEdge {
            generate(edgeFeedback: attributes.feedback.trailing)
        }
    }
    
    func generate(edgeFeedback: CrownAttributes.Feedback.Descripter) {
        HapticFeedbackGenerator.generate(impact: edgeFeedback.impactHaptic)
        backgroundView.flash(with: edgeFeedback.backgroundFlash)
    }
    
    // MARK: - Calculation Accessors
    
    @discardableResult
    private func updateAngle(of view: UIView, by center: CGPoint) -> CGFloat {
        let v1 = CGVector(dx: view.center.x - crownAnchorPoint.x, dy: view.center.y - crownAnchorPoint.y)
        let v2 = CGVector(dx: center.x - crownAnchorPoint.x, dy: center.y - crownAnchorPoint.y)
        
        var newAngleAddition = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        if newAngleAddition > .pi * 1.5 {
            newAngleAddition = newAngleAddition - .pi * 2
        } else if newAngleAddition < -.pi * 1.5 {
            newAngleAddition = .pi * 2 + newAngleAddition
        }
        var currentAngleInRadians = self.currentAngleInRadians
        currentAngleInRadians += newAngleAddition
        
        let startingPoint = attributes.anchorPosition.radians
        let endingPoint = attributes.sizes.maximumAngleInRadian + startingPoint
        if currentAngleInRadians < startingPoint {
            currentAngleInRadians = startingPoint
        } else if currentAngleInRadians > endingPoint {
            currentAngleInRadians = endingPoint
        }
        
        // TODO: Improve edge block caclulation
        if abs(currentAngleInRadians - previousAngleInRadians) >= .pi * 0.05 &&
            (previousAngleInRadians == startingPoint || previousAngleInRadians == endingPoint) {
            return self.currentAngleInRadians
        } else {
            return currentAngleInRadians
        }
    }
    
    func calculateCenter(by radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = crownAnchorPoint.x + radius * cos(angle)
        let y = crownAnchorPoint.y + radius * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    func translate() {
        preconditionFailure("Must be implemented by subclass")
    }
    
    private func updateScrollViewOffset() {
        guard let scrollView = attributes.scrollView else {
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
    
    private func isCrownWithinHorizontalBounds(after translation: CGFloat, velocity: CGFloat) -> Bool {
        let superviewBounds = self.superviewBounds
        let minX = view.minX + translation
        let maxX = view.maxX + translation
        return (minX >= superviewBounds.minX || velocity >= 0) && (maxX <= superviewBounds.maxX || velocity <= 0)
    }
    
    private func isCrownWithinVerticalBounds(after translation: CGFloat, velocity: CGFloat) -> Bool {
        let superviewBounds = self.superviewBounds
        let minY = view.minY + translation
        let maxY = view.maxY + translation
        return (minY >= superviewBounds.minY || velocity >= 0) && (maxY <= superviewBounds.maxY || velocity <= 0)
    }
    
    // MARK: - UIResponder
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            force(force: touch.force, max: touch.maximumPossibleForce)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            force(force: 0, max: touch.maximumPossibleForce)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            force(force: 0, max: touch.maximumPossibleForce)
        }
    }
        
    private func force(force: CGFloat, max: CGFloat) {
        guard isForceTouchAvailable else {
            return
        }
        
        guard case CrownAttributes.UserInteractions.PlacementGesture.prefersForceTouch(attributes: let forceTouchAttributes) = attributes.userInteractions.placementGesture else {
            return
        }
    
        let newScale = (forceTouchAttributes.maxScale - 1.0) * force / max + 1.0
        if newScale > forceTouchAttributes.scaleUpThreshold {
            if panSubject == .indicator {
                HapticFeedbackGenerator.select()
                panSubject = .crown
            }
            view.alpha = panSubject.alpha
        } else if newScale < forceTouchAttributes.scaleDownThreshold {
            if panSubject == .crown {
                HapticFeedbackGenerator.select()
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
    
    // MARK: - Exposed
    
    /**
     Layout the crown horizontally in relation to another given view.
     - parameter edge: Crown edge.
     - parameter otherEdge: Other view edge.
     - parameter otherView: The other view to which the crown clings horizontally.
     - parameter offset: The horizontal offset from the edge.
     */
    public func layoutHorizontally(_ edge: NSLayoutConstraint.Attribute, to otherEdge: NSLayoutConstraint.Attribute, of otherView: UIView, offset: CGFloat = 0) {
        originalHorizontalOffset = offset
        horizontalConstraint = view.layout(edge, to: otherEdge, of: otherView, offset: offset, priority: .must)
    }
    
    /**
     Layout the crown vertically in relation to another given view.
     - parameter edge: Crown edge.
     - parameter otherEdge: Other view edge.
     - parameter otherView: The other view to which the crown clings vertically.
     - parameter offset: The vertical offset from the edge.
     */
    public func layoutVertically(_ edge: NSLayoutConstraint.Attribute, to otherEdge: NSLayoutConstraint.Attribute, of otherView: UIView, offset: CGFloat = 0) {
        originalVerticalOffset = offset
        verticalConstraint = view.layout(edge, to: otherEdge, of: otherView, offset: offset, priority: .must)
    }
    
    /**
     Spins the crown's foreground to a given progress in the range of [0...1].
     - parameter progress: The progress of the spin from 0 to 1. Reflects the offset in the bound scroll view.
     */
    public func spin(to progress: CGFloat) {
        guard !lockPanGesture else {
            return
        }
        currentAngleInRadians = progress * attributes.sizes.maximumAngleInRadian + attributes.anchorPosition.radians
        self.progress = progress
        translate()
        previousAngleInRadians = currentAngleInRadians
    }
}
