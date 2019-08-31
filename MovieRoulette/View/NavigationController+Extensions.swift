//
//  NavigationController+Extensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/31/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation
import UIKit

class NavigationControllerExtension : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}
extension NavigationControllerExtension : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let backButtonItem = UIBarButtonItem(
            title: "   ",
            style: UIBarButtonItem.Style.plain,
            target: nil,
            action: nil)
        backButtonItem.tintColor = UIColor.gray
        viewController.navigationItem.backBarButtonItem = backButtonItem
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
    
}
