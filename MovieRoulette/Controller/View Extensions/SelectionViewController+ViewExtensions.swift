//
//  SelectionViewController+ViewExtensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/17/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit

extension SelectionViewController {
    
    //MARK: - Label text setup functions
    
    func setupTextLabels() {
        setupGenreLabelText()
        setupReleaseWindowLabelText()
    }
    
    func setupGenreLabelText() {
        
        DispatchQueue.main.async {
            switch self.genreCodeSet.count {
            case 1:
                self.genresSelectedLabel.text = "\(self.genreCodeSet.count) genre selected"
            case let count where count > 0:
                self.genresSelectedLabel.text = "\(self.genreCodeSet.count) genres selected"
            default:
                self.genresSelectedLabel.text = "No genres selected"
            }
        }
    }

    func setupReleaseWindowLabelText() {
        releaseWindowLabel.text = "\(SelectionViewController.yearFrom) to \(SelectionViewController.yearTo)"
    }
    
    //MARK: - View setup functions
    func initialViewSetup() {
        setUpLabels(withCornerRadius: 7, withBackgroundColor: Colors.darkPurple)
        setUpButtons(withCornerRadius: 7, withBackgroundColor: Colors.pinkOrange, titleColor: .black)
        setupActivityIndicator(uiView: backgroundIndicatorView, activityIndicator: activityIndicator)
        
        self.view.bringSubviewToFront(backgroundIndicatorView)
        setupReleaseWindowLabelText()
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
    
    // MARK: - Animation functions
    func beginAnimating () {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        backgroundIndicatorView.isHidden = false
    }
    
    func endAnimating() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        backgroundIndicatorView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "chooseGenres" {
            let destinationVC = segue.destination as! GenresTableViewController
            destinationVC.dataController = dataController
            GenresTableViewController.managedGenreArray = SelectionViewController.managedGenreArray
        } else if segue.identifier == "chooseReleaseWindow" {
            let destinationVC = segue.destination as! ReleaseWindowViewController
            destinationVC.releaseWindowDelegate = self
        } else if segue.identifier == "chooseActor" {
            let destinationVC = segue.destination as! ActorSearchViewController
            destinationVC.dataController = dataController
        }
    }
    
    // MARK: - Helper funcitons
    
    func createGenreSet(managedArray: [Genre]) -> Set<Int> {
        
        var genreSet = Set<Int>()
        
        for item in managedArray {
            if item.genreCode != 0 {
                let extractedCode = Int(item.genreCode)
                genreSet.insert(extractedCode)
            }
            
        }
        return genreSet
    }
    
}
