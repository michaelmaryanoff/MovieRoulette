//
//  ReleaseWindowViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit

class ReleaseWindowViewController: UIViewController {
    
    //MARK: - Variables
    
    // Global variables
    var yearRange: [Int] = Array(1900...2019).reversed()
    var firstSectionValue: Int = 2019
    var secondSectionValue: Int = 2019
    static var yearFrom: Int = 2019
    static var yearTo: Int = 2019
    
    // User defaults variable
    let defaults = UserDefaults.standard
    
    // IBOUtlets
    @IBOutlet weak var releaseYearPickerView: UIPickerView!
    @IBOutlet weak var releaseWindowLabel: UILabel!
    
    //MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Defines delegates
        releaseYearPickerView.delegate = self
        self.navigationController?.delegate = self
        
        // Sets up label
        setupReleaseWindowLabel(label: releaseWindowLabel)
        
        print("(defaults.value(forKey: StringConstants.yearFrom)" + " " + "\(defaults.value(forKey: StringConstants.yearFrom))")
        print("(defaults.value(forKey: StringConstants.yearFrom)" + " " + "\(defaults.value(forKey: StringConstants.yearTo))")
        
        if let yearFromValue = defaults.value(forKey: StringConstants.yearFrom) {
            print("yearfromvalueis" + " " + "\(yearFromValue)")
            ReleaseWindowViewController.yearFrom = yearFromValue as? Int ?? 2019
        } else {
            UserDefaults.standard.set(2019, forKey: StringConstants.yearFrom)
        }
        
        if let yearToValue = defaults.value(forKey: StringConstants.yearTo) {
            print("yearToValueis" + " " + "\(yearToValue)")
            ReleaseWindowViewController.yearTo = yearToValue as? Int ?? 2019
        } else {
            UserDefaults.standard.set(2019, forKey: StringConstants.yearTo)
        }
        
        setupPickerView()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupPickerView() {
        releaseYearPickerView.selectRow(2019-ReleaseWindowViewController.yearFrom, inComponent: 0, animated: true)
        releaseYearPickerView.selectRow(2019-ReleaseWindowViewController.yearTo, inComponent: 1, animated: true)
    }
    
    func saveReleaseWindow() {
        defaults.set(ReleaseWindowViewController.yearFrom, forKey: StringConstants.yearFrom)
        defaults.set(ReleaseWindowViewController.yearTo, forKey: StringConstants.yearTo)
    }
    
    func checkForReleaseWindown() {
        let yearFrom = defaults.integer(forKey: StringConstants.yearFrom)
        let yearTo = defaults.integer(forKey: StringConstants.yearTo)
        
        defaults.value(forKey: StringConstants.yearTo)
    }
    
}

extension ReleaseWindowViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let newSelectionVC = viewController as? SelectionViewController
        if viewController == newSelectionVC {
            
        } else {
            print("We are not using this segue")
        }
    }
    
}
