//
//  CrownViewControllerTests.swift
//  CrownControlTests
//
//  Created by Daniel Huri on 11/28/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import Quick
import Nimble
@testable import CrownControl

class CrownViewControllerTests: QuickSpec {
    override func spec() {
        var attributes: CrownAttributes!
        var scrollView: UIScrollView!
        var crownViewController: CrownViewController!
        var contentHeightRatio: CGFloat!
        
        // Before each test case perform a whole app initialization
        beforeEach {
            // Define the scrolling content
            contentHeightRatio = 10
            let bounds = UIScreen.main.bounds
            scrollView = UIScrollView(frame: bounds)
            scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height * contentHeightRatio)
            
            // Define the attributes and the crown control
            attributes = CrownAttributes(scrollView: scrollView, scrollAxis: .vertical)
            
            // ONe round is
            attributes.sizes.scrollRelation = contentHeightRatio
            attributes.anchorPosition = .right
            crownViewController = CrownIndicatorViewController(with: attributes)
            
            let rootViewController = UIViewController()
            UIApplication.shared.keyWindow!.rootViewController = rootViewController
            rootViewController.view.layoutIfNeeded()
            
            // Cling the bottom of the crown to the bottom of the web view with -35 offset
            let verticalConstraint = CrownAttributes.AxisConstraint(crownEdge: .bottom, anchorView: rootViewController.view, anchorViewEdge: .bottom, offset: -35)
            
            // Cling the bottom of the crown to the bottom of its superview with -50 offset
            let horizontalConstraint = CrownAttributes.AxisConstraint(crownEdge: .trailing, anchorView: rootViewController.view, anchorViewEdge: .trailing, offset: -50)
            
            crownViewController.layout(in: rootViewController, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
        }
        
//        it("Test the spinning of the crown and progress correspond with one another on 0 progress") {
//            crownViewController.spin(to: 0)
//            expect(crownViewController.progress).to(equal(0))
//        }
        
//        it("Test the spinning of the crown snd progress correspond with one another on 1 progres") {
//            crownViewController.spin(to: 1)
//            expect(crownViewController.progress).to(equal(1))
//        }
//
//        it("Test the angle of the foreground indicator after 0 progress") {
//            crownViewController.spin(to: 0)
//            expect(crownViewController.currentAngleInRadians).to(equal(0))
//        }
//
//        it("Test the angle of the foreground indicator after 1 progress") {
//            crownViewController.spin(to: 1)
//            expect(crownViewController.currentAngleInRadians).to(equal(.pi * 2 * contentHeightRatio))
//        }
//
//        it("Test the angle of the foreground indicator after 0.5 progress") {
//            crownViewController.spin(to: 0.5)
//            expect(crownViewController.currentAngleInRadians).to(equal(.pi * contentHeightRatio))
//        }
        
        context("scroll view extension abilities") {
            it("scrolls to leading edge") {
                scrollView.scrollToLeadingEdge(using: attributes.scrollAxis, animated: false)
                expect(scrollView.contentOffset.y).to(equal(0))
            }

            it("scrolls to trailing edge") {
                scrollView.scrollToTrailingEdge(using: attributes.scrollAxis, animated: false)
                expect(scrollView.bounds.maxY).to(equal(scrollView.bounds.height * contentHeightRatio))
            }
        }
    }
}
