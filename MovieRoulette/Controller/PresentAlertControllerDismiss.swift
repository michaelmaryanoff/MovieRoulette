//
//  PresentAlertControllerDismiss.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit

extension UIViewController {

public func presentAlertControllerDismiss(title: String, message: String) -> Void {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    self.present(alertController, animated: true)
    }
}

