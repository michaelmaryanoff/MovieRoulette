//
//  CustomActorCell.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/1/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation
import UIKit

class CustomActorCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func beginAnimating () {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func endAnimating() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
