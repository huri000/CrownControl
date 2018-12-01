//
//  CrownInteractionSpec.swift
//  CrownControlTests
//
//  Created by Daniel Huri on 11/28/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import Quick
import Nimble
@testable import CrownControl

// Describes tests that are made through the crown controller
class CrownInteractionSpec: QuickSpec, CrownControlDefaultSetup {
    override func spec() {

        describe("tests on the crown controller") {
            
            var scrollView: UIScrollView!
            var contentHeightRatio: CGFloat!
            var attributes: CrownAttributes!
            var controller: CrownSurfaceController!
            
            // Before each test case perform an app initialization
            beforeEach {
                
                let rootViewController = self.setupRootViewController()
                
                // Define the scrolling content
                contentHeightRatio = 3
                let bounds = UIScreen.main.bounds
                scrollView = UIScrollView(frame: bounds)
                scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height * contentHeightRatio)
                
                // Define the attributes and the crown control
                attributes = CrownAttributes(scrollView: scrollView, scrollAxis: .vertical)
                
                attributes.sizes.scrollRelation = contentHeightRatio
                attributes.anchorPosition = .right
                
                // Cling the bottom of the crown to the bottom of the web view with -35 offset
                let verticalConstraint = CrownAttributes.AxisConstraint(crownEdge: .bottom, anchorView: rootViewController.view, anchorViewEdge: .bottom, offset: -35)
                
                // Cling the bottom of the crown to the bottom of its superview with -50 offset
                let horizontalConstraint = CrownAttributes.AxisConstraint(crownEdge: .trailing, anchorView: rootViewController.view, anchorViewEdge: .trailing, offset: -50)
                
                controller = CrownSurfaceController(attributes: attributes)
                controller.view.layout(in: rootViewController.view, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
            }
            
            describe("tests of how user interaction affects the scroll-view content-offset") {
                
                it("scrolls to the trailing edge") {
                    controller.performTapActionIfNeeded(.scrollsToTrailingEdge(animated: false))
                    let maxOffsetY = scrollView.maxContentOffset(for: attributes.scrollAxis).y
                    let maxExpectedOffsetY = scrollView.contentSize.height - scrollView.bounds.height
                    expect(maxOffsetY).to(equal(maxExpectedOffsetY))
                }
                
                it("scrolls to the leading edge") {
                    // Offset the content by a constant
                    scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
                    
                    // Perform the action - scroll to leading edge so *contentOffset.y* would be 0
                    controller.performTapActionIfNeeded(.scrollsToLeadingEdge(animated: false))
                    
                    expect(scrollView.contentOffset.y).to(equal(0))
                }
                
                it("scrolls a page forward") {
                    let pageHeight = UIScreen.main.bounds.height
                    controller.performTapActionIfNeeded(.scrollsToTrailingPage(animated: false))
                    expect(scrollView.contentOffset.y).to(equal(pageHeight))
                }
                
                it("scrolls a page backward") {
                    let pageHeight = UIScreen.main.bounds.height
                    let initialOffsetY = scrollView.maxContentOffset(for: attributes.scrollAxis).y
                    let expectedOffsetAfterAssertion = initialOffsetY - pageHeight
                    scrollView.setContentOffset(CGPoint(x: 0, y: initialOffsetY), animated: false)
                    controller.performTapActionIfNeeded(.scrollsToLeadingPage(animated: false))
                    expect(scrollView.contentOffset.y).to(equal(expectedOffsetAfterAssertion))
                }
                
                it("scrolls forward by a constant offset") {
                    controller.performTapActionIfNeeded(.scrollsForwardWithOffset(value: 10, animated: false))
                    expect(scrollView.contentOffset.y).to(equal(10))
                }
                
                it("scrolls backward by a constant offset") {
                    let initialOffsetY: CGFloat = 50
                    let subtractedOffsetY: CGFloat = 10
                    scrollView.setContentOffset(CGPoint(x: 0, y: initialOffsetY), animated: false)
                    controller.performTapActionIfNeeded(.scrollsBackwardWithOffset(value: subtractedOffsetY, animated: false))
                    
                    let expectedOffsetAfterSubtraction = initialOffsetY - subtractedOffsetY
                    
                    expect(scrollView.contentOffset.y).to(equal(expectedOffsetAfterSubtraction))
                }
                
                it("performs a custom action") {
                    var isActionPerformed = false
                    controller.performTapActionIfNeeded(.custom(action: {
                        isActionPerformed = true
                    }))
                    expect(isActionPerformed).to(equal(true))
                }
            }
            
            describe("tests of the crown foreground ability to spin") {
                it("is able to spin") {
                    expect(controller.isAbleToSpin).to(beTrue())
                }
            }
            
            it("superview bounds equal to the root view controller's view bounds") {
                expect(controller.superviewBounds).to(equal(controller.view.superview!.bounds))
            }
            
            describe("tests of the surface location change") {
            
                var superviewBounds: CGRect!
                var newCenter: CGPoint!
                
                beforeEach {
                    superviewBounds = controller.superviewBounds
                    newCenter = CGPoint(x: superviewBounds.midX, y: superviewBounds.midY)
                    controller.changeCrownLocation(to: newCenter)
                }
                
                it("changes location if the location is legit") {
                    expect(controller.view.center).to(equal(newCenter))
                }
                
                it("update its frame after location change") {
                    expect(controller.view.frame).to(equal(controller.crownFrame))
                }
                
                it("is within superview horizontal bounds") {
                    let isCrownWithinHorizontalBounds = controller.isCrownWithinHorizontalBounds(after: 10, velocity: 1)
                    expect(isCrownWithinHorizontalBounds).to(beTrue())
                }
                
                it("is isn't within superview horizontal bounds") {
                    let isCrownWithinHorizontalBounds = controller.isCrownWithinHorizontalBounds(after: UIScreen.main.bounds.width, velocity: 1)
                    expect(isCrownWithinHorizontalBounds).to(beFalse())
                }
                
                it("is within superview vertical bounds") {
                    let isCrownWithinHorizontalBounds = controller.isCrownWithinVerticalBounds(after: 10, velocity: 1)
                    expect(isCrownWithinHorizontalBounds).to(beTrue())
                }
                
                it("is isn't within superview vertical bounds") {
                    let isCrownWithinHorizontalBounds = controller.isCrownWithinVerticalBounds(after: UIScreen.main.bounds.height, velocity: 1)
                    expect(isCrownWithinHorizontalBounds).to(beFalse())
                }
            }
            
            describe("simulation of the surface location change using the long press controller logic") {
                it("changes pan subject when long press begins") {
                    controller.longPress(with: .began)
                    expect(controller.panSubject).to(equal(.crown))
                }
                
                it("changes pan subject when long press begins") {
                    controller.longPress(with: .began)
                    controller.longPress(with: .ended)
                    expect(controller.panSubject).to(equal(.indicator))
                }
                
                it("changes crown surface center when long press *changed* state is received") {
                    let superviewBounds = controller.superviewBounds
                    let newCenter = CGPoint(x: superviewBounds.midX, y: superviewBounds.midY)
                    controller.longPress(with: .changed, location: newCenter)
                    expect(controller.view.center).to(equal(newCenter))
                }
            }
            
            describe("simulation of force touch upon the crown surface") {
                
                var maxForce: CGFloat!
                var inflationForce: CGFloat!
                var deflationForce: CGFloat!
                
                beforeEach {
                    maxForce = 10
                    deflationForce = 0
                    if case CrownAttributes.UserInteraction.RepositionGesture.prefersForceTouch(attributes: let forceTouchAttributes) = attributes.userInteraction.repositionGesture {
                        inflationForce = forceTouchAttributes.scaleUpThreshold / forceTouchAttributes.maxScale * maxForce + 0.1
                    } else {
                        inflationForce = maxForce
                    }
                }
                
                it("changes pan subject when force touch is applied") {
                    controller.force(force: inflationForce, max: maxForce, animateIfNeeded: false)
                    expect(controller.panSubject).to(equal(.crown))
                }
                
                it("changes pan subject when force touch is removed") {
                    controller.force(force: inflationForce, max: maxForce, animateIfNeeded: false)
                    controller.force(force: deflationForce, max: maxForce, animateIfNeeded: false)
                    expect(controller.panSubject).to(equal(.indicator))
                }
            }
            
            describe("simulation of the crown foreground location change using the controller logic") {
                var foregroundView: UIView!
                beforeEach {
                    foregroundView = controller.view.indicatorView
                }
                
                it("responds to pan in *began* state") {
                    let crownFrameBeforeAction = controller.crownFrame
                    controller.pan(foregroundView: foregroundView, with: .began)
                    expect(crownFrameBeforeAction).to(equal(controller.crownFrame))
                }
                
                it("responds to pan in *ended* state") {
                    let crownFrameBeforeAction = controller.crownFrame
                    controller.pan(foregroundView: foregroundView, with: .ended)
                    expect(crownFrameBeforeAction).to(equal(controller.crownFrame))
                }
                
                it("responds to pan in *changed* state - pan left") {
                    let translation = CGPoint(x: .min, y: 0)
                    controller.pan(foregroundView: foregroundView, with: .changed, translation: translation, enforceEdgeNormalization: false)
                    expect(controller.currentForegroundAngle).to(equal(.pi))
                }
                
                it("responds to pan in *changed* state - pan downward") {
                    let translation = CGPoint(x: 0, y: .max)
                    controller.pan(foregroundView: foregroundView, with: .changed, translation: translation, enforceEdgeNormalization: false)
                    expect(controller.currentForegroundAngle).to(equal(.pi * 0.5))
                }
            }
        }
    }
}
