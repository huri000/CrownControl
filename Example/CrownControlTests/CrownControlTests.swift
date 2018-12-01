//
//  CrownControlSpec.swift
//  CrownControlTests
//
//  Created by Daniel Huri on 12/1/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import Quick
import Nimble
@testable import CrownControl

// Tests the public / open APIs
class CrownControlSpec: QuickSpec, CrownControlDefaultSetup {

    override func spec() {
        describe("test crown control external api") {
            
            var attributes: CrownAttributes!
            var scrollView: UIScrollView!
            var contentHeightRatio: CGFloat!
            var crownControl: CrownControl!
            
            // Before each test case perform a whole app initialization
            beforeEach {
                
                let rootViewController = self.setupRootViewController()
                
                // Define the scrolling content
                contentHeightRatio = 10
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
                
                crownControl = CrownControl(attributes: attributes)
                crownControl.layout(in: rootViewController.view, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
            }
            
            it("test the spinning of the crown and progress correspond with one another on 0 progress") {
                crownControl.spin(to: 0)
                expect(crownControl.progress).to(equal(0))
            }
            
            it("test the spinning of the crown snd progress correspond with one another on 1 progres") {
                crownControl.spin(to: 1)
                expect(crownControl.progress).to(equal(1))
            }
            
            it("test the angle of the foreground indicator after 0 progress") {
                crownControl.spin(to: 0)
                expect(crownControl.foregroundAngle).to(equal(0))
            }
            
            it("test the angle of the foreground indicator after 1 progress") {
                crownControl.spin(to: 1)
                expect(crownControl.foregroundAngle).to(equal(.pi * 2 * contentHeightRatio))
            }
            
            it("test the angle of the foreground indicator after 0.5 progress") {
                crownControl.spin(to: 0.5)
                expect(crownControl.foregroundAngle).to(equal(.pi * contentHeightRatio))
            }
            
            it("test the angle of the foreground after spinning to match scroll view offset") {
                let maxOffset = scrollView.maxContentOffset(for: attributes.scrollAxis)
                scrollView.setContentOffset(maxOffset, animated: false)
                crownControl.spinToMatchScrollViewOffset()
                expect(crownControl.foregroundAngle).to(equal(.pi * 2 * contentHeightRatio))
            }
        }
    }
}
