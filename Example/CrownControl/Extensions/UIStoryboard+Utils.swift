//
//  UIStoryboard+Utils.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/19/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func instantiate<T: UIViewController>(type: T.Type) -> T {
        return instantiateViewController(withIdentifier: T.className) as! T
    }
}
