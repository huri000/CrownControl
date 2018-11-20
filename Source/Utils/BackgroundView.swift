//
//  BackgroundView.swift
//  CrownControl
//
//  Created by Daniel Huri on 11/11/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    // MARK: - Properties
    
    private let styleView = StyleView()
    private let shadowView = ShadowView()
    private let flashView = UIView()
    
    // MARK: - Setup
    
    init(background: CrownAttributes.Style) {
        super.init(frame: UIScreen.main.bounds)
        addSubview(shadowView)
        shadowView.fillSuperview()
        shadowView.shadow = background.shadow
        
        addSubview(styleView)
        styleView.fillSuperview()
        styleView.background = background.content
        styleView.border = background.border
        
        addSubview(flashView)
        flashView.fillSuperview()
        flashView.isUserInteractionEnabled = false
        flashView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flashView.layer.cornerRadius = min(bounds.width, bounds.height) * 0.5
    }
    
    func flash(with type: CrownAttributes.Feedback.Descripter.Flash) {
        switch type {
        case .active(color: let color, fadeDuration: let duration):
            flashView.backgroundColor = color
            UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                self.flashView.backgroundColor = .clear
            }, completion: nil)
        case .none:
            break
        }
    }
}
