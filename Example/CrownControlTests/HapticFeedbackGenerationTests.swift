//
//  HapticFeedbackGenerationTests.swift
//  CrownControlTests
//
//  Created by Daniel Huri on 12/1/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import Quick
import Nimble
@testable import CrownControl

class HapticFeedbackGenerationTests: QuickSpec {
    
    override func spec() {
        describe("simulation of haptic feedback test logic") {
            
            it("doesn't generate feedback if none is specified") {
                let isGenerated = HapticFeedbackGenerator.generate(impact: .none)
                expect(isGenerated).to(equal(false))
            }
            
            it("generates feedback if specified") {
                guard #available(iOS 10.0, *)  else {
                    return
                }
                let isGenerated = HapticFeedbackGenerator.generate(impact: .heavy)
                expect(isGenerated).to(equal(true))
            }
            
            it("doesn't generate feedback below min os version") {
                guard Double(UIDevice.current.systemVersion)! < 10.0 else {
                    return
                }
                
                let isGenerated = HapticFeedbackGenerator.generate(impact: .medium)
                expect(isGenerated).to(equal(false))
            }
        }
    }
}
