//
//  PhotoData.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/17/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

struct PhotoData {
    let fileName: String
    let description: String
    
    var image: UIImage {
        return UIImage(named: fileName)!
    }
}
