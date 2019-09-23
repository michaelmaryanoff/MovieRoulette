//
//  GenresTableViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/21/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class GenresTableViewController: UIViewController {
    
    // MARK: - Variables
    
    // Managed variables
    static var managedGenreArrayCount = 0
    var fetchedResultsController: NSFetchedResultsController<Genre>!
    var dataController: DataController!
    static var managedGenreArray = [Genre]()
    
    // Non-managed variables
    static var codeArray = [Int]()
    static var genresArray = [String]()
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the delegate for the table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.delegate = self
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Ensures that the marked genres are passed through to the SelectionViewController
        SelectionViewController.managedGenreArray = GenresTableViewController.managedGenreArray
    }
    
    
    // Reusable function that changes the view context
    func changeManagedGenreSet(forCell cell: UITableViewCell, add: Bool, indexPath: IndexPath) {
        
        guard let cellText = cell.textLabel?.text else {
            return
        }
        
        
        let newGenre = Genre(context: dataController.viewContext)
        
        if add == true {
            print("add true")
            for (key, value) in GenreConstants.genresDictionary {
                if cellText == key && !GenresTableViewController.doesArrayContain(genreName: cellText) {
                    newGenre.genreName = cellText
                    newGenre.genreCode = Int64(value)
                    GenresTableViewController.managedGenreArray.append(newGenre)
                    GenresTableViewController.managedGenreArrayCount = GenresTableViewController.managedGenreArray.count
                    do {
                        try dataController.viewContext.save()
                    } catch {
                        print("could not save in \(#function)")
                    }
                }
                
            }
        } else if add == false {
            print("add false")
            for (key, value) in GenreConstants.genresDictionary {
                if cellText == key {
                    for item in GenresTableViewController.managedGenreArray {
                        if item.genreName == cellText {
                            let genreIndex = GenresTableViewController.managedGenreArray.firstIndex(of: item)
                            if let genreIndex = genreIndex {
                                GenresTableViewController.managedGenreArray.remove(at: genreIndex)
                                self.dataController.viewContext.delete(item)
                                GenresTableViewController.managedGenreArrayCount = GenresTableViewController.managedGenreArray.count
                                do {
                                    try dataController.viewContext.save()
                                } catch {
                                    print("could not save in \(#function)")
                                }
                                
                            }
                    }
                }
                    
            }
        }
        
            
            }
        }
    
    // Function that indicates whether or not a genre is present in an array
    class func doesArrayContain(genreName: String) -> Bool {
        var boolForReturn = Bool()
        
        for item in GenresTableViewController.managedGenreArray {
            if item.genreName == genreName {
                boolForReturn = true
            } else {
                boolForReturn = false
            }
        }
        return boolForReturn
    }

}

//MARK: - Extensions
// Extension that handles the segue
extension GenresTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let newSelectionVC = viewController as? SelectionViewController
        if viewController == newSelectionVC {
        } else {
            print("We are using a different segue.")
        }
        do {
            try dataController.viewContext.save()
        } catch {
            print("could not save")
        }
    }

}
