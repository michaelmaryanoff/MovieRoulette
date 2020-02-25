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
    var genreCount = 0
    
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
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchRequest()
        
        calculateGenreLabelText()
        setupTextLabels()
    }
    
    // MARK: - IBActions
    @IBAction func spinForMovie(_ sender: Any) {
        
        findRandomMovie()
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

