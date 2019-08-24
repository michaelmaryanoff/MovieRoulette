//
//  ReleaseWindowViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit

class ReleaseWindowViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var yearRange: [Int] = Array(1900...2019).reversed()
    
    var firstSectionValue: Int = 2019
    
    var secondSectionValue: Int = 2019
    
    var yearFrom: Int = 2019
    
    var yearTo: Int = 2019

    @IBOutlet weak var releaseYearPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        releaseYearPickerView.delegate = self
        releaseYearPickerView.delegate = self
        
    }
    
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
        
        self.yearFrom = min(firstSectionValue, secondSectionValue)
        self.yearTo = max(firstSectionValue, secondSectionValue)
        
        print("yearFrom: \(yearFrom)")
        print("yearTo: \(yearTo)")
    }
    
}
