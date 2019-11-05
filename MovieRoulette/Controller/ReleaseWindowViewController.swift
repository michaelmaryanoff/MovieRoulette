//
//  ReleaseWindowViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit
import CoreData

class ReleaseWindowViewController: UIViewController {
    
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
        
        setupPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let yearRangeFetchRequest: NSFetchRequest<YearRange> = YearRange.fetchRequest()
        makeYearRangeFetchRequest(yearRangeFetchRequest)
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
    
    func setupPickerView() {
        releaseYearPickerView.selectRow(2019-ReleaseWindowViewController.yearFrom, inComponent: 0, animated: true)
        releaseYearPickerView.selectRow(2019-ReleaseWindowViewController.yearTo, inComponent: 1, animated: true)
        
    }
    
    fileprivate func makeYearRangeFetchRequest(_ fetchRequest: NSFetchRequest<YearRange>) {
        
        // Takes the results of the fetch request
        let result = makeFetchRequest(fetchRequest)
        
        SelectionViewController.releaseWindowArray = result
        
        if result.count > 0 {
            if let firstResult = result.first {
                
                print("Result in resultVC is" + " " + "\(result)")
                
//                print("First result in ReleaseWindowVC" + " " + "\(firstResult.yearFrom)")
//                print("Second result in ReleaseWindowVC" + " " + "\(firstResult.yearTo)")
//
//                SelectionViewController.yearTo = Int(firstResult.yearTo)
//                SelectionViewController.yearFrom = Int(firstResult.yearFrom)
//                ReleaseWindowViewController.yearFrom = Int(firstResult.yearFrom)
//                ReleaseWindowViewController.yearTo = Int(firstResult.yearTo)
                
            }
            
        } else {
            print("We could not find any results in ReleaseVC!")
        }
        
    }
    
    func makeFetchRequest<MangedObject: NSManagedObject>(_ fetchRequest: NSFetchRequest<MangedObject>) -> [MangedObject] {
        // TODO: You will need to store the results of this as an array and then do something with it afterwards
        // Maybe make this a guard statement and have this function return [NSManagedObject]
        
        do {
            let result = try ReleaseWindowViewController.dataController.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("could not fetch requested objects")
            return []
        }
        
    }
    
    func saveReleaseWindow() {
        defaults.set(ReleaseWindowViewController.yearFrom, forKey: StringConstants.yearFrom)
        defaults.set(ReleaseWindowViewController.yearTo, forKey: StringConstants.yearTo)
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
