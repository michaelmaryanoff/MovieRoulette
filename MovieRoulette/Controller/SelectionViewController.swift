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

class SelectionViewController: UIViewController {
    
    // MARK: - Non-Managed variables
    var moviesArray = [String]()
    var yearsArray = [Int]()
    var genreCodeSet = Set<Int>()
    static var yearFrom: Int = 1960
    static var yearTo: Int = 2019
    var actorId: Int?
    static var genreCount = 0
    
    // MARK: - Managed Core Data variables
    var dataController: DataController!
    static var managedGenreArray = [Genre]()
    static var releaseWindowArray = [YearRange]()
    static var managedActorArray = [Actor]()
    
     var fetchedResultsController: NSFetchedResultsController<Genre>!
    
    // Buttons
    @IBOutlet weak var spinForMovieButton: UIButton!
    @IBOutlet weak var chooseGenreButton: UIButton!
    @IBOutlet weak var chooseReleaseWindowButton: UIButton!
    @IBOutlet weak var chooseActorButton: UIButton!
    
    
    // Labels
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var genresSelectedLabel: UILabel!
    @IBOutlet weak var releaseWindowLabel: UILabel!
    
    // Other UIOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundIndicatorView: UIView!
    
    // MARK: - View load functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialViewSetup()
        print("didload")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("willappear")
        
//        print("SelectionViewController.managedGenreArray in SelectionVC \(#function)" + " " + "\(SelectionViewController.managedGenreArray)")
//        print("SelectionViewController.managedGenreArray.count" + " " + "\(SelectionViewController.managedGenreArray.count)")
        
        setupFetchRequest()
        
        genreCodeSet = createGenreSet(managedArray: SelectionViewController.managedGenreArray)
        
        
        DispatchQueue.main.async {
            switch self.genreCodeSet.count {
            case 1:
                self.genresSelectedLabel.text = "\(self.genreCodeSet.count) genre selected"
            case let count where count > 0:
                self.genresSelectedLabel.text = "\(self.genreCodeSet.count) genres selected"
            default:
                self.genresSelectedLabel.text = "No genres selected"
            }
        }
        
    }
    
    // MARK: - Core Data functions
    fileprivate func setupFetchRequest() {
        
        // MARK: Fetch requests
        let genreFetchrequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        let yearRangeFetchRequest: NSFetchRequest<YearRange> = YearRange.fetchRequest()
        let actorFetchRequest: NSFetchRequest<Actor> = Actor.fetchRequest()
        
        // MARK: Call to fetch requests
        makeGenreFetchRequest(genreFetchrequest)
        makeYearRangeFetchRequest(yearRangeFetchRequest)
        makeActorFetchRequest(actorFetchRequest)
        
        // Deletes all genres that have "0" as a genre code
        deleteAllEmptyGenres()
        
        do {
            try dataController.viewContext.save()
        } catch  {
            print("There was a problem saving in in \(#function)")
        }
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
    
    // MARK: Functions for making a fetch request of different types
    
    func makeFetchRequest<MangedObject: NSManagedObject>(_ fetchRequest: NSFetchRequest<MangedObject>) -> [MangedObject] {
        // TODO: You will need to store the results of this as an array and then do something with it afterwards
        // Maybe make this a guard statement and have this function return [NSManagedObject]
        
        do {
            let result = try dataController.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("could not fetch requested objects")
            return []
        }
        
    }
    
    fileprivate func makeGenreFetchRequest(_ fetchRequest: NSFetchRequest<Genre>) {
        
        let result = makeFetchRequest(fetchRequest)
            
            for item in result {
                deleteEmptyGenre(withGenre: item)
            }
            
            SelectionViewController.managedGenreArray = result
            
        
        
    }
    
    fileprivate func makeYearRangeFetchRequest(_ fetchRequest: NSFetchRequest<YearRange>) {
        
        // Takes the results of the fetch request
        let result = makeFetchRequest(fetchRequest)
            
            SelectionViewController.releaseWindowArray = result
            
            if result.count > 0 {
                if let firstResult = result.first {
                    
                    // This solves a bug where release window
                    // displayed incorrectly on small device screens
                    if (UIScreen.main.bounds.width == 320) {
                        releaseWindowLabel.text = "Window has been chosen"
                    } else {
                        releaseWindowLabel.text = "\(firstResult.yearFrom) to \(firstResult.yearTo)"
                        SelectionViewController.yearTo = Int(firstResult.yearTo)
                        SelectionViewController.yearFrom = Int(firstResult.yearFrom)
                    }
                    
                }
                
            }
        
    }
    
    fileprivate func makeActorFetchRequest(_ fetchRequest: NSFetchRequest<Actor>) {
        
        // Takes the results of the fetch request
        let result = makeFetchRequest(fetchRequest)
            
            SelectionViewController.managedActorArray = result
            
            if result.count > 0 {
                if let firstResult = result.first {
                    actorId = Int(firstResult.actorId)
                        
                    if let actorName = firstResult.actorName {
                        actorsLabel.text = "\(actorName)"
                    }
                }
                
            }
    }
    
    // MARK: - IBActions
    
    @IBAction func spinForMovie(_ sender: Any) {
    
        self.beginAnimating()
        
        self.moviesArray = []
        
        let url = TMDBClient.formulateMovieSearchURL(withTheseGenres: Array(genreCodeSet), yearFrom: SelectionViewController.yearFrom, yearTo: SelectionViewController.yearTo, withActorCode: actorId)
        print("url" + " " + "\(url)")
        
        TMDBClient.searchForMovies(url: url) { (success, stringArray, error) in
            
            self.beginAnimating()
            
            self.moviesArray = []
            
            if CheckConnectivity.isConnectedToInternet == false {
                self.presentAlertControllerDismiss(title: "There is no internet connection!", message: "Please check your connection and try again.")
                self.endAnimating()
                return
            }
            
            if error != nil {
                self.presentAlertControllerDismiss(title: "There was an error.", message: "\(error!.localizedDescription)")
            }
            
            if success {
                self.endAnimating()
                self.moviesArray = []
                self.moviesArray = stringArray
                if self.moviesArray.count > 0 {
                    let randomNumber = Int.random(in: 0..<stringArray.count)
                    let randomMovie = self.moviesArray[randomNumber]
                    DispatchQueue.main.async {
                        self.presentAlertControllerDismiss(title: "The movie you are watching tonight is...", message: "\(randomMovie)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentAlertControllerDismiss(title: "No movies met these criteria.", message: "Please try again.") 
                    }
                }
                
                
            }
        }
    }
    

    @IBAction func confirmActorSelection(_ unwindSegue: UIStoryboardSegue) {
        
        guard let actorSearchViewController = unwindSegue.source as? ActorSearchViewController else {
            return
        }
        
        let passedActorId = actorSearchViewController.selectedActorId
        self.actorId = passedActorId
    }
    

    
    @IBAction func chooseGenres(_ sender: Any) {
        performSegue(withIdentifier: "chooseGenres", sender: self.genreCodeSet)
    }

}

