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
    
    var yearRange: [Int] = Array(1900...2019).reversed()
    
    var firstSectionValue: Int = 2019
    
    var secondSectionValue: Int = 2019
    
    static var yearFrom: Int = 2019
    
    static var yearTo: Int = 2019
    
    static var releaseWindow = YearRange(context: ReleaseWindowViewController.dataController.viewContext)
    
    static var releaseWindowArray = [YearRange]()
    
    static var dataController: DataController!

    @IBOutlet weak var releaseYearPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        releaseYearPickerView.delegate = self
        
        if let releaseWindowFrom = ReleaseWindowViewController.releaseWindowArray.first {
            let yearFrom = Int(releaseWindowFrom.yearFrom)
            print("Year from is \(yearFrom)")
            self.releaseYearPickerView.selectRow(yearFrom, inComponent: 0, animated: false)
            self.releaseYearPickerView.reloadAllComponents()
        }
        
        if let releaseWindowTo = ReleaseWindowViewController.releaseWindowArray.first {
            let yearTo = Int(releaseWindowTo.yearTo)
            self.releaseYearPickerView.selectRow(yearTo, inComponent: 1, animated: false)
            self.releaseYearPickerView.reloadAllComponents()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            if let releaseWindowFrom = ReleaseWindowViewController.releaseWindowArray.first {
                let yearFrom = Int(releaseWindowFrom.yearFrom)
                print("Year from is \(yearFrom)")
                self.releaseYearPickerView.selectRow(2000, inComponent: 0, animated: false)
                self.releaseYearPickerView.reloadAllComponents()
            }
            
            if let releaseWindowTo = ReleaseWindowViewController.releaseWindowArray.first {
                let yearTo = Int(releaseWindowTo.yearTo)
                self.releaseYearPickerView.selectRow(yearTo, inComponent: 1, animated: false)
                self.releaseYearPickerView.reloadAllComponents()
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            if let releaseWindowFrom = ReleaseWindowViewController.releaseWindowArray.first {
                let yearFrom = Int(releaseWindowFrom.yearFrom)
                print("Year from is \(yearFrom)")
                self.releaseYearPickerView.selectRow(2000, inComponent: 0, animated: false)
                self.releaseYearPickerView.reloadAllComponents()
            }
            
            if let releaseWindowTo = ReleaseWindowViewController.releaseWindowArray.first {
                let yearTo = Int(releaseWindowTo.yearTo)
                self.releaseYearPickerView.selectRow(yearTo, inComponent: 1, animated: false)
                self.releaseYearPickerView.reloadAllComponents()
            }
        }
        
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Release window array: \(ReleaseWindowViewController.releaseWindowArray)")
        
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
        
        print("Picker view is \(pickerView.selectedRow(inComponent: 0))")
        
        let yearRangeInt = Int(yearRange[row])
        
        if component == 0 {
            firstSectionValue = yearRangeInt
        } else if component == 1 {
            secondSectionValue = yearRangeInt
        }
        
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
            SelectionViewController.releaseWindowArray = ReleaseWindowViewController.releaseWindowArray
            SelectionViewController.releaseWindowArray = ReleaseWindowViewController.releaseWindowArray
        } else {
            print("this ain't it chief")
        }
    }
    
}
