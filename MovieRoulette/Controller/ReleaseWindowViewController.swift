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
    static var yearFrom: Int = 2019
    static var yearTo: Int = 2019
    
    // Other variables
    let defaults = UserDefaults.standard
    var releaseWindowDelegate: ReleaseWindowDelegate!
    
    // IBOUtlets
    @IBOutlet weak var releaseYearPickerView: UIPickerView!
    @IBOutlet weak var releaseWindowLabel: UILabel!
    
    //MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Defines delegates
        releaseYearPickerView.delegate = self
        
        // Sets up view
        setupReleaseWindowLabel(label: releaseWindowLabel)
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
    
    
}

protocol ReleaseWindowDelegate {
    func releaseYearPicked(yearFrom: Int, yearTo: Int)
}
