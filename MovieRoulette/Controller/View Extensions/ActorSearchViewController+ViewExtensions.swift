//
//  ActorSearchViewController+ViewExtensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit

extension ActorSearchViewController {
    
    //MARK: - View functions
    func changeActivityIndicatorState(isAnimating: Bool) {
        switch isAnimating {
        case true:
            self.activityView.center = self.view.center
            self.activityView.hidesWhenStopped = true
            activityView.startAnimating()
        case false:
            activityView.stopAnimating()
            
        }
        
    }
    
}
