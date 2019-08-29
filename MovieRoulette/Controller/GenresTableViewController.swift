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
    
    static var managedGenreSet = Set<Genre>()
    
    var fetchedResultsController: NSFetchedResultsController<Genre>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the delegate for the table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.delegate = self
        
        // Creating a fetch request
        let fetchRequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        
        GenresTableViewController.managedGenreSet = []
        // Fetch requesting but only if set is empty
        if GenresTableViewController.managedGenreSet.isEmpty{
            makeFetchRequest(fetchRequest)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    fileprivate func makeFetchRequest(_ fetchRequest: NSFetchRequest<Genre>) {
        
        // Takes the results of the fetch request
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            
            for item in result {
                print("the result in makeFetchRequest for GenresTableViewController is \(item.genreCode)")
                print("the result in makeFetchRequest for GenresTableViewController is \(item.genreName ?? "could not find name")")
            }
            
            let arraySet = Set(result)
            
            GenresTableViewController.managedGenreSet = arraySet
            
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
        
        for item in GenresTableViewController.managedGenreSet {
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
                if cellText == key {
                    newGenre.genreName = cellText
                    newGenre.genreCode = Int64(value)
                    GenresTableViewController.managedGenreSet.insert(newGenre)
                    do {
                        try dataController.viewContext.save()
                        print("GenresTableViewController.managedGenreSet after save \(GenresTableViewController.managedGenreSet)")
                        print("newGenreName \(newGenre.genreName!)")
                        print("newGenreId: \(newGenre.genreCode)")
                    } catch  {
                        print("will not save in \(#function)")
                    }
                }
                
            }
        } else if add == false {
            print("add false")
            for (key, value) in GenreConstants.genresDictionary {
                if cellText == key {
                    print("cellText is \(cellText)")
                    for item in GenresTableViewController.managedGenreSet {
                        if item.genreName == cellText {
                            print("item for deletion is \(item)")
//                            GenresTableViewController.managedGenreSet.remove(item)
                            GenresTableViewController.managedGenreSet = GenresTableViewController.managedGenreSet.filter { $0.genreName != item.genreName }
                        do {
                            self.dataController.viewContext.delete(item)
                            try self.dataController.viewContext.save()
                            print("After delete set: \(GenresTableViewController.managedGenreSet)")
                            print("count after delete set: \(GenresTableViewController.managedGenreSet.count)")
                        } catch {
                            print("could not delete!")
                        }
                    }
                }
                    
            }
        }
        
            
            }
        }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        SelectionViewController.managedGenreSet = GenresTableViewController.managedGenreSet
//    }

}

extension GenresTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("\(#function) has been called")
        let newSelectionVC = viewController as? SelectionViewController
        let newGenresVC = viewController as? GenresTableViewController
        if viewController == newSelectionVC {
            SelectionViewController.managedGenreSet = GenresTableViewController.managedGenreSet
            print("SelectionViewController.managedGenreSet in navigation function: \(SelectionViewController.managedGenreSet)")
        } else {
            print("this ain't it chief")
        }
    }

}
