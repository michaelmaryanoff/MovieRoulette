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

class GenresTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataController: DataController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmSelectionButton: UIButton!
    
    static var managedGenreArray = [Genre]()
    
    static var managedGenreArrayCount = 0
    
    static var codeArray = [Int]()
    
    static var genresArray = [String]()
    
    var fetchedResultsController: NSFetchedResultsController<Genre>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the delegate for the table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.delegate = self
        
        print("Managed genre array is in viewDidLoad \(GenresTableViewController.managedGenreArray)")
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    

    // MARK: - Table view data source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GenreConstants.genresArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
        
        cell.textLabel?.text = GenreConstants.genresArray[indexPath.row]
        
        for item in GenresTableViewController.managedGenreArray {
            
            if let itemString = item.genreName {
                if cell.textLabel?.text == itemString {
                    cell.accessoryType = .checkmark
                }

            }

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let currentCell = tableView.cellForRow(at: indexPath) else {
            print("cannot with current cell")
            return
        }
        
        if currentCell.accessoryType == .checkmark {
            currentCell.accessoryType = .none
            changeManagedGenreSet(forCell: currentCell, add: false, indexPath: indexPath)
        } else {
            currentCell.accessoryType = .checkmark
            changeManagedGenreSet(forCell: currentCell, add: true, indexPath: indexPath)
        }

    }
    
    // Reusable function that changes the context
    func changeManagedGenreSet(forCell cell: UITableViewCell, add: Bool, indexPath: IndexPath) {
        
        guard let cellText = cell.textLabel?.text else {
            return
        }
        
        
        let newGenre =  Genre(context: dataController.viewContext)
        
        if add == true {
            print("add true")
            for (key, value) in GenreConstants.genresDictionary {
                if cellText == key && !GenresTableViewController.doesArrayContain(genreName: cellText) {
                    newGenre.genreName = cellText
                    newGenre.genreCode = Int64(value)
                    GenresTableViewController.managedGenreArray.append(newGenre)
                    print("new genre array is \(GenresTableViewController.managedGenreArray)")
                    GenresTableViewController.managedGenreArrayCount = GenresTableViewController.managedGenreArray.count
                    print("Count of GenresTableViewController.managedGenreArrayCount = GenresTableViewController.managedGenreArray.count is \(GenresTableViewController.managedGenreArray.count)")
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
                                print("Count of GenresTableViewController.managedGenreArrayCount = GenresTableViewController.managedGenreArray.count is \(GenresTableViewController.managedGenreArray.count)")
                            }
                    }
                }
                    
            }
        }
        
            
            }
        }
    
    class func doesArrayContain(genreName: String) -> Bool {
        var boolForReturn = Bool()
        
        for item in GenresTableViewController.managedGenreArray {
            if item.genreName == genreName {
                boolForReturn = true
            } else {
                boolForReturn = false
            }
        }
        print("Bool for return is \(boolForReturn)")
        return boolForReturn
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        SelectionViewController.managedGenreSet = GenresTableViewController.managedGenreSet
//    }

}

extension GenresTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("\(#function) has been called")
        let newSelectionVC = viewController as? SelectionViewController
        if viewController == newSelectionVC {
            SelectionViewController.managedGenreArray = GenresTableViewController.managedGenreArray
            print("SelectionViewController.managedGenreSet in navigation function: \(SelectionViewController.managedGenreArray)")
        } else {
            print("this ain't it chief")
        }
        do {
            try dataController.viewContext.save()
        } catch {
            print("could not save")
        }
    }

}
