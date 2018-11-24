//
//  Contact.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/16/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import Foundation

struct Contact {
    
    // MARK: - Properties
    
    let identifier: String
    let name: String
    
    var firstLetter: Character {
        return name.first!
    }
    
    var initials: String {
        let names = name.split(separator: " ").compactMap { $0.first }
        var initials = ""
        if names.isEmpty {
            return initials
        } else {
            initials += "\(names.first!)"
            if names.count > 1 {
                initials += "\(names.last!)"
            }
        }
        return initials.uppercased()
    }
    
    // MARK: - Setup
    
    init?(identifier: String, givenName: String, familyName: String) {
        guard !givenName.isEmpty || !familyName.isEmpty else {
            return nil
        }
        self.identifier = identifier
        var name = givenName
        if name.isEmpty {
            name = familyName
        } else {
            name += " \(familyName)"
        }
        self.name = name
    }
}

// MARK: - Comparable

extension Contact: Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
}
