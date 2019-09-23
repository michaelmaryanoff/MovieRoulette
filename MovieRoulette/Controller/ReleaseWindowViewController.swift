//
//  ReleaseWindowViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ReleaseWindowViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: - Variables
    
    // Non-managed variables
    var yearRange: [Int] = Array(1900...2019).reversed()
    var firstSectionValue: Int = 2019
    var secondSectionValue: Int = 2019
    static var yearFrom: Int = 2019
    static var yearTo: Int = 2019
    
    // Managed variables
    static var releaseWindow = YearRange(context: ReleaseWindowViewController.dataController.viewContext)
    static var releaseWindowArray = [YearRange]()
    static var dataController: DataController!
    
    // IBOUtlets
    @IBOutlet weak var releaseYearPickerView: UIPickerView!
    @IBOutlet weak var releaseWindowLabel: UILabel!
    
    //MARK: - view loading functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Defines delegates
        releaseYearPickerView.delegate = self
        self.navigationController?.delegate = self
        
        // Sets up label
        setupReleaseWindowLabel(label: releaseWindowLabel)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Ensures that the viewContext saves when navigating away from view
        do {
            try ReleaseWindowViewController.dataController.viewContext.save()
        } catch {
            print("Could not save context")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //MARK: - Picker View functions
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return String(yearRange[row])
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let yearRangeInt = Int(yearRange[row])
        
        if component == 0 {
            firstSectionValue = yearRangeInt
        } else if component == 1 {
            secondSectionValue = yearRangeInt
        }
        
        // Ensures that "yearFrom" is always less than "yearTo"
        ReleaseWindowViewController.releaseWindow.yearFrom = Int64(min(firstSectionValue, secondSectionValue))
        ReleaseWindowViewController.releaseWindow.yearTo = Int64(max(firstSectionValue, secondSectionValue))
        SelectionViewController.yearFrom = Int(ReleaseWindowViewController.releaseWindow.yearFrom)
        SelectionViewController.yearTo = Int(ReleaseWindowViewController.releaseWindow.yearTo)
    }
    
    
    
}

extension ReleaseWindowViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("\(#function) has been called in releasewindow vc")
        let newSelectionVC = viewController as? SelectionViewController
        if viewController == newSelectionVC {
            SelectionViewController.releaseWindowArray = ReleaseWindowViewController.releaseWindowArray
            SelectionViewController.releaseWindowArray = ReleaseWindowViewController.releaseWindowArray
            SelectionViewController.yearFrom = Int(ReleaseWindowViewController.releaseWindow.yearFrom)
            SelectionViewController.yearTo = Int(ReleaseWindowViewController.releaseWindow.yearTo)
        } else {
            print("We are not using this segue")
        }
    }
    
}
