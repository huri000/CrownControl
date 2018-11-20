//
//  Object+ClassName.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 4/25/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
