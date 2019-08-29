//
//  ReleaseWindowViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit
import CoreData

class ReleaseWindowViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var yearRange: [Int] = Array(1900...2019).reversed()
    
    var firstSectionValue: Int = 2019
    
    var secondSectionValue: Int = 2019
    
    static var yearFrom: Int = 2019
    
    static var yearTo: Int = 2019
    
    static var releaseWindow = YearRange(context: ReleaseWindowViewController.dataController.viewContext)
    
    static var dataController: DataController!

    @IBOutlet weak var releaseYearPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        releaseYearPickerView.delegate = self
        releaseYearPickerView.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        do {
            try ReleaseWindowViewController.dataController.viewContext.save()
        } catch {
            print("could not save this")
        }
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
        
        
        
//        ReleaseWindowViewController.releaseWindow.yearFrom = Int64(min(firstSectionValue, secondSectionValue))
//        ReleaseWindowViewController.releaseWindow.yearFrom = Int64(max(firstSectionValue, secondSectionValue))
        
        ReleaseWindowViewController.releaseWindow.yearFrom = Int64(min(firstSectionValue, secondSectionValue))
        ReleaseWindowViewController.releaseWindow.yearTo = Int64(max(firstSectionValue, secondSectionValue))
        
        
        print("yearFrom: \(ReleaseWindowViewController.yearFrom)")
        print("yearTo: \(ReleaseWindowViewController.yearTo)")
    }
    
}

extension ReleaseWindowViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("\(#function) has been called in releasewindow vc")
        let newSelectionVC = viewController as? SelectionViewController
        if viewController == newSelectionVC {
            SelectionViewController.yearRange.yearFrom = ReleaseWindowViewController.releaseWindow.yearFrom
            SelectionViewController.yearRange.yearFrom = ReleaseWindowViewController.releaseWindow.yearTo
        } else {
            print("this ain't it chief")
        }
//        do {
//            try dataController.viewContext.save()
//        } catch {
//            print("could not save")
//        }
    }
    
}
