// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import CrownControl

class CrownAttributesSpec: QuickSpec {
    override func spec() {
        describe("testing of crown attributes internal behavior") {
            var scrollView: UIScrollView!
            var attributes: CrownAttributes!
            
            beforeEach {
                // INstantiate the scroll-view
                scrollView = UIScrollView(frame: UIScreen.main.bounds)
                attributes = CrownAttributes(scrollView: scrollView, scrollAxis: .vertical)
            }
            
            context("anchor position") {
                it("right value is 0 in radians") {
                    attributes.anchorPosition = .right
                    expect(attributes.anchorPosition.radians).to(equal(0))
                }
                
                it("bottom value is pi/2 in radians") {
                    attributes.anchorPosition = .bottom
                    expect(attributes.anchorPosition.radians).to(equal(.pi / 2))
                }
                
                it("left value is .pi in radians") {
                    attributes.anchorPosition = .left
                    expect(attributes.anchorPosition.radians).to(equal(.pi))
                }
                
                it("top value is .pi*1.5 in radians") {
                    attributes.anchorPosition = .top
                    expect(attributes.anchorPosition.radians).to(equal(.pi * 1.5))
                }
            }
            
            context("spin direction") {
                it("keeps clockwise spin direction value") {
                    attributes.spinDirection = .clockwise
                    expect(attributes.spinDirection.isClockwise).to(beTrue())
                }
                
                it("keeps counter-clockwise spin direction value") {
                    attributes.spinDirection = .counterClockwise
                    expect(attributes.spinDirection.isClockwise).to(beFalse())
                }
            }
            
            context("scroll view") {
                it("has a scroll view upon initialization") {
                    expect(attributes.scrollView).toNot(beNil())
                }
            }

            context("feedback") {
                
                it("impact haptic feedback is non existant when the given value is nil") {
                    if #available(iOS 10.0, *) {
                        attributes.feedback.leading.impactHaptic = .none
                        expect(attributes.feedback.leading.impactHaptic.value).to(beNil())
                    }
                }
                
                it("impact haptic feedback is light when the given value is light") {
                    if #available(iOS 10.0, *) {
                        attributes.feedback.leading.impactHaptic = .light
                        expect(attributes.feedback.leading.impactHaptic.value).to(equal(.light))
                    }
                }
                
                it("impact haptic feedback is medium when the given value is medium") {
                    if #available(iOS 10.0, *) {
                        attributes.feedback.leading.impactHaptic = .medium
                        expect(attributes.feedback.leading.impactHaptic.value).to(equal(.medium))
                    }
                }
                
                it("impact haptic feedback is heavy when the given value is heavy") {
                    if #available(iOS 10.0, *) {
                        attributes.feedback.leading.impactHaptic = .heavy
                        expect(attributes.feedback.leading.impactHaptic.value).to(equal(.heavy))
                    }
                }
            }
            
            context("user interaction") {
                it("is interactable if needed") {
                    attributes.userInteraction.doubleTap = .scrollsToTrailingEdge
                    expect(attributes.userInteraction.doubleTap.isInteractable).to(beTrue())
                }
                
                it("is not interactable if needed") {
                    attributes.userInteraction.doubleTap = .none
                    expect(attributes.userInteraction.doubleTap.isInteractable).to(beFalse())
                }
                
                describe("long press") {
                    beforeEach {
                        var longPressAttributes = CrownAttributes.UserInteraction.RepositionGesture.Attributes.LongPress()
                        longPressAttributes.minimalDuration = 1
                        attributes.userInteraction.repositionGesture = .longPress(attributes: longPressAttributes)
                    }
                    
                    it("returns true value for long press check after assignment") {
                        expect(attributes.userInteraction.repositionGesture.isLongPress).to(beTrue())
                    }
                    
                    it("returns the correct value for long press duration") {
                        expect(attributes.userInteraction.repositionGesture.longPressDuration).to(equal(1))
                    }
                    
                    it("returns false for force touch inquiry") {
                        expect(attributes.userInteraction.repositionGesture.isForceTouch).to(beFalse())
                    }
                }
                
                describe("force touch") {
                    beforeEach {
                        attributes.userInteraction.repositionGesture = .prefersForceTouch(attributes: .init())
                    }
                    
                    it("returns true for force touch inquiry") {
                        expect(attributes.userInteraction.repositionGesture.isForceTouch).to(beTrue())
                    }
                    
                    it("returns false for long press inquiry") {
                        expect(attributes.userInteraction.repositionGesture.isLongPress).to(beFalse())
                    }
                }
            }
        }
    }
}
