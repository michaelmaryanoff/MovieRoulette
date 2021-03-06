//
//  ReleaseWindowViewController+Extensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit

extension ReleaseWindowViewController:  UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: - Picker View functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(yearRange[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let yearRangeInt = Int(yearRange[row])
        
        var firstSectionValue: Int = ReleaseWindowViewController.yearFrom
        var secondSectionValue: Int =  ReleaseWindowViewController.yearTo
        
        if component == 0 {
            firstSectionValue = yearRangeInt
        } else if component == 1 {
            secondSectionValue = yearRangeInt
        }
        
        // Ensures that "yearFrom" is always less than "yearTo"
        ReleaseWindowViewController.yearFrom = min(firstSectionValue, secondSectionValue)
        ReleaseWindowViewController.yearTo = max(firstSectionValue, secondSectionValue)
        
        // Delegate function that passes yearFrom and yearTo to the SelectionViewController
        releaseWindowDelegate.releaseYearPicked(yearFrom: ReleaseWindowViewController.yearFrom, yearTo: ReleaseWindowViewController.yearTo)
        
        // Saves yearFrom and yearTo to UserDefaults
        saveReleaseWindow()
    }
    
}

protocol ReleaseWindowDelegate {
    func releaseYearPicked(yearFrom: Int, yearTo: Int)
}


