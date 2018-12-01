//
//  CrownIndicatorView.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/9/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import QuickLayout

/** A crown indicator view controller */
class CrownIndicatorView: CrownSurfaceView {

    // MARK: - Properties
    
    override var indicatorView: UIView {
        return pinIndicatorView
    }
    
    private lazy var pinIndicatorView: PinIndicatorView = {
        let pinIndicatorView = PinIndicatorView(anchorPoint: controller.crownAnchorPoint, edgeSize: attributes.sizes.foregroundDiameter, background: attributes.foregroundStyle)
        return pinIndicatorView
    }()
        
    // MARK: - Lifecycle
    
    override init(with attributes: CrownAttributes, controller: CrownSurfaceController, delegate: CrownControlDelegate? = nil) {
        super.init(with: attributes, controller: controller, delegate: delegate)
        addSubview(pinIndicatorView)
        DispatchQueue.main.async {
            self.peformForegroundTranslation()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Feedback Generation

    override func generate(edgeFeedback: CrownAttributes.Feedback.Descripter) {
        super.generate(edgeFeedback: edgeFeedback)
        pinIndicatorView.flash(with: edgeFeedback.foregroundFlash)
    }
    
    // MARK: - Calculation Accessors
    
    override func peformForegroundTranslation() {
        pinIndicatorView.center = controller.calculateForegroundCenter(by: attributes.sizes.innerCircleEdgeSize * 0.5, angle: foregroundAngle)
    }
}
