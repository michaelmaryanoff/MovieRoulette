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
    
    var genresArray = ["Action",
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
    
    var genresDictionary: [String:Int] = ["Action": 28,
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
    
    var genreCodeSet = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return genresArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
        
        cell.textLabel?.text = genresArray[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCell = tableView.cellForRow(at: indexPath) else {
            print("nothing selected1")
            return
        }
        
        if currentCell.accessoryType == .checkmark {
            currentCell.accessoryType = .none
            print("cell deselected")
            
        } else {
            print("cell selected")
            GenresTableViewController.editGenreCodeArray(forCell: currentCell)
            currentCell.accessoryType = .checkmark
            
        }

    }
    
    class func editGenreCodeArray(forCell cell: UITableViewCell) {
        
        guard let cellText = cell.textLabel?.text else {
            print("nil returned in \(#function)")
            return
        }
        print(cellText)
    }

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }


}
