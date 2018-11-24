//
//  CrownIndicatorViewController.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/9/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import QuickLayout

/** A crown indicator view controller */
public class CrownIndicatorViewController: CrownViewController {

    // MARK: - Properties
    
    override var indicatorView: UIView {
        return pinIndicatorView
    }
    
    private lazy var pinIndicatorView: PinIndicatorView = {
        let pinIndicatorView = PinIndicatorView(anchorPoint: crownAnchorPoint, edgeSize: attributes.sizes.foregroundDiameter, background: attributes.foregroundStyle)
        return pinIndicatorView
    }()
        
    // MARK: - Lifecycle
    
    public override func loadView() {
        super.loadView()
        view.addSubview(pinIndicatorView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.translate()
        }
    }
    
    // MARK: - Feedback Generation

    override func generate(edgeFeedback: CrownAttributes.Feedback.Descripter) {
        super.generate(edgeFeedback: edgeFeedback)
        pinIndicatorView.flash(with: edgeFeedback.foregroundFlash)
    }
    
    // MARK: - Calculation Accessors
    
    override func translate() {
        pinIndicatorView.center = calculateCenter(by: attributes.sizes.innerCircleEdgeSize * 0.5, angle: currentAngleInRadians)
    }
}
