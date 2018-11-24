//
//  ContactTableViewCell.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/10/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet private weak var thumbView: ContactThumbView!
    @IBOutlet private weak var nameLabel: UILabel!

    // Injected
    weak var contactManager: ContactManager!
    
    var contact: Contact! {
        didSet {
            nameLabel.text = contact.name
            thumbView.initials = contact.initials
            thumbView.image = nil
            
            let identifier = contact.identifier
            DispatchQueue.global(qos: .userInitiated).async {
                let image = self.contactManager.thumb(by: identifier)
                DispatchQueue.main.async {
                    guard identifier == self.contact.identifier else {
                        return
                    }
                    self.thumbView.image = image
                }
            }
        }
    }
    
    // MARK: - Lifecycle
        
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        thumbView.image = nil
        thumbView.initials = nil
    }
}
