//
//  GenresTableViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/21/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit

class GenresTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataController: DataController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmSelectionButton: UIButton!
    

    
    static var selectedIndexPathArray = [Int]()
    
    static var managedGenreSet: Set<Genre> = []
    
   static var genreCodeSet = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        GenresTableViewController.genreCodeSet = []
    }
    
//    @IBAction func confirmSelection(_ sender: Any) {
//        self.performSegue(withIdentifier: "confirmGenreSelection", sender: GenresTableViewController.genreCodeSet)
//        
//    }
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GenresTableViewController.genresArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
        
        cell.textLabel?.text = GenresTableViewController.genresArray[indexPath.row]

        // Configure the cell...

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

    class func addToGenreCodeSet(forCell cell: UITableViewCell) {
        
        guard let cellText = cell.textLabel?.text else {
            print("nil returned in \(#function)")
            return
        }
        
        for (key, value) in genresDictionary {
            if cellText == key {
                genreCodeSet.insert(value)
                print("new genreCodeSet: \(genreCodeSet)")
            }
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
            for (key, value) in GenresTableViewController.genresDictionary {
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
            for (key, value) in GenresTableViewController.genresDictionary {
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
        
        
    
    func addToManagedGenreSet(forCell cell: UITableViewCell) {
    
        guard let cellText = cell.textLabel?.text else {
            return
        }
        
        
        for (key, value) in GenresTableViewController.genresDictionary {
            if cellText == key {
                GenresTableViewController.genreCodeSet.insert(value)
                let newGenre = Genre(context: dataController.viewContext)
                newGenre.genreName = cellText
                newGenre.genreCode = Int64(value)
                do {
                    try dataController.viewContext.save()
                    print("newGenreName \(newGenre.genreName!)")
                    print("newGenreId: \(newGenre.genreCode)")
                } catch  {
                    print("will not save in \(#function)")
                }
                
            }
        }
        
    }
    
    class func removeFromGenreCodeSet(forCell cell: UITableViewCell) {
        
        guard let cellText = cell.textLabel?.text else {
            print("nil returned in \(#function)")
            return
        }
        
        for (key, value) in genresDictionary {
            if cellText == key {
                genreCodeSet.remove(value)
                print("new genreCodeSet after removal: \(genreCodeSet)")
            }
        }
        
    }
    func removieFromMangedGenreSet(forCell cell: UITableViewCell) {
        
        guard let cellText = cell.textLabel?.text else {
            return
        }
        
        for (key, value) in GenresTableViewController.genresDictionary {
            if cellText == key {
                GenresTableViewController.genreCodeSet.remove(value)
                print("new genreCodeSet after removal: \(GenresTableViewController.genreCodeSet)")
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var setToBePassed = GenresTableViewController.genreCodeSet
    }


}
