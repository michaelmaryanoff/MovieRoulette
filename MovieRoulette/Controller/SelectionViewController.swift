//
//  ViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/20/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//


// This is the main ViewController

import UIKit
import Alamofire
import CoreData
import Foundation

class SelectionViewController: UIViewController {
    
    var dataController: DataController!
    
    var genreCodeSet = Set<Int>()
    
    static var managedGenreArray = [Genre]()
    
    static var managedGenreArrayCount = 0
    
    var moviesArray = [String]()
    
    var yearsArray = [Int]()
    
    var yearFrom: Int = 1960
    
    var yearTo: Int = 2019
    
    var actorId = Int()
    
    var fetchedResultsController: NSFetchedResultsController<Genre>!

    @IBOutlet weak var spinForMovieButton: UIButton!
    @IBOutlet weak var chooseGenreButton: UIButton!
    @IBOutlet var chooseReleaseWindowButton: UIView!
    @IBOutlet weak var genresSelectedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            if SelectionViewController.managedGenreArray.count == 1 {
                self.genresSelectedLabel.text = "\(SelectionViewController.managedGenreArray.count) genre selected"
            } else if SelectionViewController.managedGenreArray.count > 0 {
                self.genresSelectedLabel.text = "\(SelectionViewController.managedGenreArray.count) genres selected"
            } else {
                self.genresSelectedLabel.text = "No genres selected"
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("SelectionViewController.managedGenreArry in controller itself: \(SelectionViewController.managedGenreArray)")
        
        let fetchrequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        
        if SelectionViewController.managedGenreArray.isEmpty {
            makeFetchRequest(fetchrequest)
        }
    
//        print("managedGenreSet in SelectionVC: \(SelectionViewController.managedGenreArray)")
        for item in SelectionViewController.managedGenreArray {
            deleteAllEmptyGenres()
        }
        
        
        
        do {
            try dataController.viewContext.save()
            print("saved in viewWillAppear")
        } catch  {
            print("will not save in \(#function)")
        }
        
        print("viewWillAppear")
        print("mangedGenreSet.count: \(SelectionViewController.managedGenreArray.count)")
        
    }
    
    fileprivate func deleteAllEmptyGenres() {
        for genre in SelectionViewController.managedGenreArray {
            if genre.genreCode == Int64(0) {
                dataController.viewContext.delete(genre)
                do {
                    try self.dataController.viewContext.save()
                } catch {
                    print("could not delete these photos")
                }
            }
            
        }
    }
    
    func deleteEmptyGenre(withGenre genre: Genre) -> Void {
        if genre.genreCode == 0 {
            dataController.viewContext.delete(genre)
        }
    }
    
    fileprivate func makeFetchRequest(_ fetchRequest: NSFetchRequest<Genre>) {
        
        // Takes the results of the fetch request
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            
//            print("The result in SelectinoViewController is: \(result)")
            print("The result count of SelectionViewControllerCount is\(result.count)")
            
            for item in result {
                deleteEmptyGenre(withGenre: item)
            }
            
            SelectionViewController.managedGenreArray = result
            
        }
    }
    
    @IBAction func confirmGenreSelection(_ unwindSegue: UIStoryboardSegue) {
        print("unwind called")
        guard let genresTableViewController = unwindSegue.source as? GenresTableViewController else {
            print("could not find source!")
            return
        }
        let passedGenereCodeSet = GenresTableViewController.managedGenreArray
        print("passedGenreCodeSet: \(passedGenereCodeSet)")
        for item in passedGenereCodeSet {
            var genreId = item.genreCode
            self.genreCodeSet.insert(Int(genreId))
        }
        print("genreCodeSet after passing: \(self.genreCodeSet)")
        if genreCodeSet.count > 0 {
            genresSelectedLabel.text = "\(genreCodeSet.count) genres selected"
        } else if genreCodeSet.count == 1 {
            genresSelectedLabel.text = "\(genreCodeSet.count) genre selected"
        }
        
    }
    
    @IBAction func spinForMovie(_ sender: Any) {
        TMDBClient.searchForMovies(withTheseGenres: genreCodeSet, from: yearFrom, to: yearTo, withActorCode: actorId) { (success, stringArray, error) in
            if success {
                self.moviesArray = stringArray
                if stringArray.count > 0 {
                    let randomNumber = Int.random(in: 0...stringArray.count)
                    print("The movie you are watching tonight is \(self.moviesArray[randomNumber])")
                    let randomMovie = self.moviesArray[randomNumber]
                    print(self.moviesArray)
                    DispatchQueue.main.async {
                        self.presentAlertControllerDismiss(title: "The movie you are watching tonight is...", message: "\(randomMovie)")
                    }
                } else {
                    print("there are no movies to choose from!")
                }
                
                
            }
        }
    }
    
    @IBAction func confirmReleaseWindow(_ undwindSegue: UIStoryboardSegue) {
        print("unwind 2 called")
        guard let releaseWindowViewController = undwindSegue.source as? ReleaseWindowViewController else {
            print("could not find ReleaseWindowViewController!")
            return
        }
        let passedYearFrom = ReleaseWindowViewController.yearFrom
        let passedYearTo = ReleaseWindowViewController.yearTo
        self.yearFrom = passedYearFrom
        self.yearTo = passedYearTo
        
        print("self.yearTo): \(self.yearTo)")
        print("self.yearTo): \(self.yearFrom)")
    }
    
    @IBAction func confirmActorSelection(_ unwindSegue: UIStoryboardSegue) {
        print("unwind 3 called")
        
        guard let actorSearchViewController = unwindSegue.source as? ActorSearchViewController else {
            print("could not find actorSearchViewController")
            return
        }
        let passedActorId = actorSearchViewController.selectedActorId
        self.actorId = passedActorId
        print("new actor id in SelectionViewController \(self.actorId)")
    }
    
    public func presentAlertControllerDismiss(title: String, message: String) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    
    
    @IBAction func chooseGenres(_ sender: Any) {
        performSegue(withIdentifier: "chooseGenres", sender: self.genreCodeSet)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Adapted from Stack Overflow post
        if segue.identifier == "chooseGenres" {
            let destinationVC = segue.destination as! GenresTableViewController
            destinationVC.dataController = dataController
            GenresTableViewController.managedGenreArray = SelectionViewController.managedGenreArray
        } else if segue.identifier == "chooseReleaseWindow" {
            let controller = segue.destination as! ReleaseWindowViewController
        }
    }
    
    func constructUrl(withTheseGenres genreCodes: Set<Int>?) {
        
    }
}

