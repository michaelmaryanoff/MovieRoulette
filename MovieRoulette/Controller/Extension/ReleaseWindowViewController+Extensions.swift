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
