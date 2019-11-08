//
//  ViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/20/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//


// This is the main ViewController

import Alamofire
import CoreData

class SelectionViewController: UIViewController {
    
    // MARK: - Non-Managed variables
    
    // Structured data
    var moviesArray = [String]()
    var genreCodeSet = Set<Int>()
    
    // Single variables
    static var yearFrom = 2019
    static var yearTo = 2019
    var actorId: Int?
    static var genreCount = 0
    
    // MARK: - Core Data variables
    var dataController: DataController!
    static var managedGenreArray = [Genre]()
    static var managedActorArray = [Actor]()
    
    // MARK: - Outles
    
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
        setupReleaseWindowLabelText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        setupReleaseWindowLabelText()
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

extension SelectionViewController: ReleaseWindowDelegate {
    func releaseYearPicked(yearFrom: Int, yearTo: Int) {
        SelectionViewController.yearFrom = yearFrom
        SelectionViewController.yearTo = yearTo
    }
    
}

