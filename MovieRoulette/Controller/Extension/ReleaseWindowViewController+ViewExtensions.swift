//
//  ReleaseWindowViewController+ViewExtensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation
import UIKit

extension ReleaseWindowViewController {
    
   func setupReleaseWindowLabel(label: UILabel) {
        label.layer.cornerRadius = 7
        label.backgroundColor = Colors.darkPurple
        label.clipsToBounds = true
    }
    
}
