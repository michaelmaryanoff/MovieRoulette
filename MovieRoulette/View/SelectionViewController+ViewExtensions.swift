//
//  SelectionViewController+ViewExtensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/17/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation
import UIKit

extension SelectionViewController {
    
    func initialViewSetup() {
        setUpLabels(withCornerRadius: 7, withBackgroundColor: Colors.darkPurple)
        setUpButtons(withCornerRadius: 7, withBackgroundColor: Colors.pinkOrange, titleColor: .black)
        setupActivityIndicator(uiView: backgroundIndicatorView, activityIndicator: activityIndicator)
        
        self.view.bringSubviewToFront(backgroundIndicatorView)
    }
    
    func setupActivityIndicator(uiView: UIView, activityIndicator: UIActivityIndicatorView) {
        uiView.backgroundColor = Colors.richBlue
        uiView.alpha = 0.7
        uiView.clipsToBounds = true
        uiView.layer.cornerRadius = 8
        uiView.isHidden = true
        
        activityIndicator.style = .whiteLarge
        activityIndicator.isHidden = true
    }
    
    func setUpLabels(withCornerRadius cornerRadius: CGFloat, withBackgroundColor backgroundColor: UIColor) {
        genresSelectedLabel.layer.cornerRadius = cornerRadius
        genresSelectedLabel.backgroundColor = backgroundColor
        genresSelectedLabel.clipsToBounds = true
        
        releaseWindowLabel.layer.cornerRadius = cornerRadius
        releaseWindowLabel.backgroundColor = backgroundColor
        releaseWindowLabel.clipsToBounds = true
        
        actorsLabel.layer.cornerRadius = cornerRadius
        actorsLabel.backgroundColor = backgroundColor
        actorsLabel.clipsToBounds = true
        
    }
    
    func setUpButtons(withCornerRadius cornerRadius: CGFloat, withBackgroundColor backgroundColor: UIColor, titleColor: UIColor) {
        chooseGenreButton.layer.cornerRadius = cornerRadius
        chooseGenreButton.backgroundColor = backgroundColor
        chooseGenreButton.setTitleColor(titleColor, for: .normal)
        
        chooseReleaseWindowButton.layer.cornerRadius = cornerRadius
        chooseReleaseWindowButton.backgroundColor = backgroundColor
        chooseReleaseWindowButton.setTitleColor(titleColor, for: .normal)
        
        chooseActorButton.layer.cornerRadius = cornerRadius
        chooseActorButton.backgroundColor = backgroundColor
        chooseActorButton.setTitleColor(titleColor, for: .normal)
        
        spinForMovieButton.layer.cornerRadius = cornerRadius
        
        
    }
    
    
}
