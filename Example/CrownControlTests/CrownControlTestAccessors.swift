//
//  CrownControlTestAccessors.swift
//  CrownControlTests
//
//  Created by Daniel Huri on 12/1/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

protocol CrownControlDefaultSetup {
    func setupRootViewController() -> UIViewController
}

extension CrownControlDefaultSetup {
    func setupRootViewController() -> UIViewController {
        let rootViewController = UIViewController()
        UIApplication.shared.keyWindow!.rootViewController = rootViewController
        rootViewController.view.layoutIfNeeded()
        return rootViewController
    }
}
