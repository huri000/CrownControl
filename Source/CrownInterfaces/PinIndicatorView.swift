//
//  PinIndicatorView.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/10/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import QuickLayout

class PinIndicatorView: UIView {

    // MARK: - Properties
    
    private let backgroundView: BackgroundView

    // MARK: - Setup
    
    init(anchorPoint: CGPoint, edgeSize: CGFloat, background: CrownAttributes.Style) {
        backgroundView = BackgroundView(background: background)
        super.init(frame: CGRect(x: 0, y: 0, width: edgeSize, height: edgeSize))
        center = anchorPoint
        
        addSubview(backgroundView)
        backgroundView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func flash(with type: CrownAttributes.Feedback.Descripter.Flash) {
        backgroundView.flash(with: type)
    }
}
