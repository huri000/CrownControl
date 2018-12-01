//
//  CrownSurfaceView.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/11/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import QuickLayout

/** The crown surface view */
class CrownSurfaceView: UIView {

    // Delegate for the crown spin events
    private weak var delegate: CrownControlDelegate!
    
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

    var progress: CGFloat {
        return controller.progress
    }
    
    var foregroundAngle: CGFloat {
        return controller.currentForegroundAngle
    }
    
    // The crown attributes descriptor
    let attributes: CrownAttributes
    var controller: CrownSurfaceController!
    
    // MARK: UI Elements
    
    private lazy var backgroundView: BackgroundView = {
        let backgroundView = BackgroundView(background: attributes.backgroundStyle)
        contentView.addSubview(backgroundView)
        backgroundView.fillSuperview()
        return backgroundView
    }()
    
    // MARK: - Lifecycle
    
    init(with attributes: CrownAttributes, controller: CrownSurfaceController, delegate: CrownControlDelegate? = nil) {
        self.attributes = attributes
        self.delegate = delegate
        self.controller = controller
        
        super.init(frame: CGRect(origin: .zero, size: attributes.sizes.backgroundSurfaceSquareSize))
        addSubview(contentView)
        isExclusiveTouch = true
        
        contentView.set(.width, .height, of: attributes.sizes.backgroundSurfaceDiameter)
        contentView.layoutToSuperview(.left, .right, .top, .bottom)
        contentView.addSubview(backgroundView)
        
        setupUserInteraction()
        
        transform = attributes.crownTransform
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUserInteraction() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized))
        panGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(panGestureRecognizer)

        if attributes.userInteraction.doubleTap.isInteractable {
            doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureRecognized))
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            addGestureRecognizer(doubleTapGestureRecognizer)
        }
        
        if attributes.userInteraction.singleTap.isInteractable {
            singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapGestureRecognized))
            singleTapGestureRecognizer.numberOfTapsRequired = 1
            if let doubleTapGestureRecognizer = doubleTapGestureRecognizer {
                singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
            }
            addGestureRecognizer(singleTapGestureRecognizer)
        }
        
        if controller.shouldLongPressBeApplied {
            longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
            longPressGestureRecognizer.minimumPressDuration = attributes.userInteraction.repositionGesture.longPressDuration
            addGestureRecognizer(longPressGestureRecognizer)
        }
    }
    
    // MARK: - Orientation
    
    // Normalize the position of the crown surface after device orientation change
    @objc private func deviceOrientationDidChange() {
        controller.spin(to: progress)
        
        let superviewBounds = controller.superviewBounds
        
        if minX < superviewBounds.minX {
            horizontalConstraint.constant = originalHorizontalOffset
        } else if maxX > superviewBounds.maxX {
            horizontalConstraint.constant = originalHorizontalOffset
        }

        if minY < superviewBounds.minY {
            verticalConstraint.constant = originalVerticalOffset
        } else if maxY > superviewBounds.maxY {
            verticalConstraint.constant = originalVerticalOffset
        }
    }
    
    // MARK: - User Interaction
    
    @objc private func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch (controller.panSubject, attributes.userInteraction.repositionGesture.isForceTouch) {
        case (.indicator, _):
            panForeground(using: gestureRecognizer)
        case (.crown, true):
            panCrownSurface(using: gestureRecognizer)
        default:
            break
        }
    }
    
    @objc private func doubleTapGestureRecognized(_ gestureRecognizer: UITapGestureRecognizer) {
        controller.performTapActionIfNeeded(attributes.userInteraction.doubleTap)
    }
    
    @objc private func singleTapGestureRecognized(_ gestureRecognizer: UITapGestureRecognizer) {
        controller.performTapActionIfNeeded(attributes.userInteraction.singleTap)
    }
    
    @objc private func longPressGestureRecognized(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let superview = superview else {
            return
        }
        let location = gestureRecognizer.location(in: superview)
        controller.longPress(with: gestureRecognizer.state, location: location)
    }
    
    private func panCrownSurface(using gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = superview else {
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
            
            if controller.isCrownWithinHorizontalBounds(after: translation.x, velocity: velocity.x) {
                horizontalConstraint.constant += translation.x
            }
            
            if controller.isCrownWithinVerticalBounds(after: translation.y, velocity: velocity.y) {
                verticalConstraint.constant += translation.y
            }
            
        case .cancelled, .ended, .failed:
            break
        case .possible:
            break
        }
    }
    
    private func panForeground(using gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = superview else {
            return
        }
        let state = gestureRecognizer.state
        let translation = gestureRecognizer.translation(in: superview)
        defer {
            gestureRecognizer.setTranslation(.zero, in: superview)
        }
        controller.pan(foregroundView: indicatorView, with: state, translation: translation)
    }
    
    // MARK: - Feedback Generation
    
    private func generateEdgeFeedbackIfNecessary() {
        if controller.hasForegroundReachedLeadingEdge {
            generate(edgeFeedback: attributes.feedback.leading)
        } else if controller.hasForegroundReachedTrailingEdge {
            generate(edgeFeedback: attributes.feedback.trailing)
        }
    }
    
    func generate(edgeFeedback: CrownAttributes.Feedback.Descripter) {
        HapticFeedbackGenerator.generate(impact: edgeFeedback.impactHaptic)
        backgroundView.flash(with: edgeFeedback.backgroundFlash)
    }
    
    // MARK: - UIResponder
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            controller.force(force: touch.force, max: touch.maximumPossibleForce)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            controller.force(force: 0, max: touch.maximumPossibleForce)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            controller.force(force: 0, max: touch.maximumPossibleForce)
        }
    }
    
    /**
     Layout the crown horizontally in relation to another given view.
     - parameter edge: Crown edge.
     - parameter otherEdge: Other view edge.
     - parameter otherView: The other view to which the crown clings horizontally.
     - parameter offset: The horizontal offset from the edge.
     */
    private func layoutHorizontally(_ edge: NSLayoutConstraint.Attribute, to otherEdge: NSLayoutConstraint.Attribute, of otherView: UIView, offset: CGFloat = 0) {
        originalHorizontalOffset = offset
        horizontalConstraint = layout(edge, to: otherEdge, of: otherView, offset: offset, priority: .must)
    }
    
    /**
     Layout the crown vertically in relation to another given view.
     - parameter edge: Crown edge.
     - parameter otherEdge: Other view edge.
     - parameter otherView: The other view to which the crown clings vertically.
     - parameter offset: The vertical offset from the edge.
     */
    private func layoutVertically(_ edge: NSLayoutConstraint.Attribute, to otherEdge: NSLayoutConstraint.Attribute, of otherView: UIView, offset: CGFloat = 0) {
        originalVerticalOffset = offset
        verticalConstraint = layout(edge, to: otherEdge, of: otherView, offset: offset, priority: .must)
    }
    
    /**
     Add the crown view controller as a child of a parent view controller and layout it vertically and horizontally.
     - parameter superview: A superview to be positioned within
     - parameter horizontalConstaint: Horizontal constraint construct.
     - parameter verticalConstraint: Vertical constraint construct.
     */
    func layout(in superview: UIView, horizontalConstaint: CrownAttributes.AxisConstraint, verticalConstraint: CrownAttributes.AxisConstraint) {
        superview.addSubview(self)
        layoutHorizontally(horizontalConstaint.crownEdge, to: horizontalConstaint.anchorViewEdge, of: horizontalConstaint.anchorView, offset: horizontalConstaint.offset)
        layoutVertically(verticalConstraint.crownEdge, to: verticalConstraint.anchorViewEdge, of: verticalConstraint.anchorView, offset: verticalConstraint.offset)
    }
    
    func peformForegroundTranslation() {
        preconditionFailure("Must be implemented by subclass")
    }
}

// MARK: CrownSurfaceControllerDelegate

extension CrownSurfaceView: CrownSurfaceControllerDelegate {
    
    func crownDidBeginSpinning() {
//        delegate?.crownDidBeginSpinning(self)
    }
    
    func crownDidEndSpinning() {
//        delegate?.crownDidEndSpinning(self)
    }
    
    func crownWillUpdate() {
//        delegate?.crown(self, willUpdate: viewModel.progress)
    }
    
    func crownDidUpdate() {
        // Generate haptic feedback if needed
        generateEdgeFeedbackIfNecessary()
        
//        delegate?.crown(self, didUpdate: viewModel.progress)
    }
}
