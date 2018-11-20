//
//  ContactThumbView.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/14/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit
import QuickLayout

class ContactThumbView: UIView {
    
    private static let possibleBackgroundColors: [UIColor] = [.contact1, .contact2, .contact3, .contact4]
    
    private let initialsLabel = UILabel()
    private let imageView = UIImageView()
    
    var initials: String! {
        didSet {
            initialsLabel.text = initials
            if let initials = initials {
                let colorIndex = abs(initials.hashValue % ContactThumbView.possibleBackgroundColors.count)
                backgroundColor = ContactThumbView.possibleBackgroundColors[colorIndex]
            }
        }
    }
    
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
        initialsLabel.font = UIFont.systemFont(ofSize: 18)
        initialsLabel.textColor = .white
        addSubview(initialsLabel)
        initialsLabel.centerInSuperview()
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width * 0.5
    }
}
