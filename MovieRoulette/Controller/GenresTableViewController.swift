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
    
    static var selectedIndexPathArray = [Int]()
    
    static var managedGenreSet: Set<Genre> = []
    
    var fetchedResultsController: NSFetchedResultsController<Genre>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let fetchRequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        makeFetchRequest(fetchRequest)
        
    }
    
    fileprivate func makeFetchRequest(_ fetchRequest: NSFetchRequest<Genre>) {
        // Takes the results of the fetch request
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            
            let arraySet = Set(result)
            
            GenresTableViewController.managedGenreSet = arraySet
        }
    }
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    // Adds to the managedGenreSet
    
    // Reusalbe function that changes the context
    func changeManagedGenreSet(forCell cell: UITableViewCell, add: Bool, indexPath: IndexPath) {
        guard let cellText = cell.textLabel?.text else {
            return
        }
        let newGenre =  Genre(context: dataController.viewContext)
        if add == true {
            for (key, value) in GenreConstants.genresDictionary {
                if cellText == key {
                    
                    newGenre.genreName = cellText
                    newGenre.genreCode = Int64(value)
                    GenresTableViewController.managedGenreSet.insert(newGenre)
                    do {
                        try dataController.viewContext.save() 
                        print("newGenreName \(newGenre.genreName!)")
                        print("newGenreId: \(newGenre.genreCode)")
                        print("After save set: \(GenresTableViewController.managedGenreSet)")
                    } catch  {
                        print("will not save in \(#function)")
                    }
                }
                
            }
            //TODO: just pass through to main VC
        } else if add == false {
            for (key, value) in GenreConstants.genresDictionary {
                if cellText == key {
                    for item in GenresTableViewController.managedGenreSet {
                        if item.genreName == cellText {
                        GenresTableViewController.managedGenreSet.remove(item)
                        do {
                            self.dataController.viewContext.delete(item)
                            try self.dataController.viewContext.save()
                            print("After delete set: \(GenresTableViewController.managedGenreSet)")
                        } catch {
                            print("could not delete!")
                        }
                        }
                    }
                    
                    
                    
                }
            }
        
            
            }
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var setToBePassed = GenresTableViewController.managedGenreSet
    }


}
