//
//  ContactHeaderView.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/16/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

class ContactHeaderView: UITableViewHeaderFooterView {

    // MARK: - Properties
    
    var initial: Character? {
        set {
            guard let initial = newValue else {
                return
            }
            textLabel?.text = String(initial)
        }
        get {
            return textLabel?.text?.first
        }
    }
    
    // MARK: - Setup
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
