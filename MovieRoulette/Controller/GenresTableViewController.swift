//
//  GenresTableViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/21/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit

class GenresTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmSelectionButton: UIButton!
    
    static var genresArray = ["Action",
                       "Adventure",
                       "Animation",
                       "Comedy",
                       "Crime",
                       "Documentary",
                       "Drama",
                       "Family",
                       "Fantasy",
                       "History",
                       "Horror",
                       "Music",
                       "Mystery",
                       "Romance",
                       "Science Fiction",
                       "TV Movie",
                       "Thriller",
                       "War",
                       "Western"]
    
    static var genresDictionary: [String:Int] = ["Action": 28,
                                          "Adventure": 12,
                                          "Animation": 16,
                                          "Comedy": 35,
                                          "Crime": 80,
                                          "Documentary": 99,
                                          "Drama": 18,
                                          "Family": 10751,
                                          "Fantasy": 14,
                                          "History": 36,
                                          "Horror": 27,
                                          "Music": 10402,
                                          "Mystery": 9648,
                                          "Romance": 10749,
                                          "Science Fiction": 878,
                                          "TV Movie": 10770,
                                          "Thriller": 53,
                                          "War": 10752,
                                          "Western": 37]
    
    static var selectedIndexPathArray = [Int]()
    
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
            print("nothing selected1")
            return
        }
        
        let currentIndexPath = [indexPath.row]
        
        print("current cell is: \(currentCell)")
        
        if currentCell.accessoryType == .checkmark {
            currentCell.accessoryType = .none
            GenresTableViewController.removeFromGenreCodeSet(forCell: currentCell)
            
        } else {
            currentCell.accessoryType = .checkmark
            GenresTableViewController.addToGenreCodeSet(forCell: currentCell)
            
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var setToBePassed = GenresTableViewController.genreCodeSet
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "confirmGenreSelection" {
//            let destinationVC = segue.destination as! SelectionViewController
//            
//            destinationVC.genreCodeSet = GenresTableViewController.genreCodeSet
//            
//        }
//    }


}
