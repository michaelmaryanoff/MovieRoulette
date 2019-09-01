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
import QuartzCore

class SelectionViewController: UIViewController {
    
    // MARK: - Non-Managed variables
    var moviesArray = [String]()
    
    var yearsArray = [Int]()
    
    var genreCodeSet = Set<Int>()
    
    static var yearFrom: Int = 1960
    
    static var yearTo: Int = 2019
    
    var actorId: Int?
    
    // MARK: - Managed Core Data variables
    
    var dataController: DataController!
    
    static var managedGenreArray = [Genre]()
    
    static var releaseWindowArray = [YearRange]()
    
    static var managedActorArray = [Actor]()
    
     var fetchedResultsController: NSFetchedResultsController<Genre>!
   
    // MARK: - Outlets

    // Buttons
    @IBOutlet weak var spinForMovieButton: UIButton!
    @IBOutlet weak var chooseGenreButton: UIButton!
    @IBOutlet weak var chooseReleaseWindowButton: UIButton!
    @IBOutlet weak var chooseActorButton: UIButton!
    
    
    // Labels
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var genresSelectedLabel: UILabel!
    @IBOutlet weak var releaseWindowLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var backgroundIndicatorView: UIView!
    // MARK: - View load functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoadCalled")
        setUpLabels(withCornerRadius: 7, withBackgroundColor: Colors.darkPurple)
        setUpButtons(withCornerRadius: 7, withBackgroundColor: Colors.pinkOrange, titleColor: .black)
        setupActivityIndicator(uiView: backgroundIndicatorView, activityIndicator: activityIndicator)
        
    }
    
    func setupActivityIndicator(uiView: UIView, activityIndicator: UIActivityIndicatorView) {
        uiView.backgroundColor = Colors.richBlue
        uiView.alpha = 0.7
        uiView.clipsToBounds = true
        uiView.layer.cornerRadius = 8
        uiView.isHidden = true
        
        activityIndicator.style = .whiteLarge
        activityIndicator.isHidden = true
    }
    
    func setUpLabels(withCornerRadius cornerRadius: CGFloat, withBackgroundColor backgroundColor: UIColor) {
        genresSelectedLabel.layer.cornerRadius = cornerRadius
        genresSelectedLabel.backgroundColor = backgroundColor
        genresSelectedLabel.clipsToBounds = true
        
        releaseWindowLabel.layer.cornerRadius = cornerRadius
        releaseWindowLabel.backgroundColor = backgroundColor
        releaseWindowLabel.clipsToBounds = true
        
        actorsLabel.layer.cornerRadius = cornerRadius
        actorsLabel.backgroundColor = backgroundColor
        actorsLabel.clipsToBounds = true
        
    }
    
    func setUpButtons(withCornerRadius cornerRadius: CGFloat, withBackgroundColor backgroundColor: UIColor, titleColor: UIColor) {
        chooseGenreButton.layer.cornerRadius = cornerRadius
        chooseGenreButton.backgroundColor = backgroundColor
        chooseGenreButton.setTitleColor(titleColor, for: .normal)
        
        chooseReleaseWindowButton.layer.cornerRadius = cornerRadius
        chooseReleaseWindowButton.backgroundColor = backgroundColor
        chooseReleaseWindowButton.setTitleColor(titleColor, for: .normal)
        
        chooseActorButton.layer.cornerRadius = cornerRadius
        chooseActorButton.backgroundColor = backgroundColor
        chooseActorButton.setTitleColor(titleColor, for: .normal)
        
        spinForMovieButton.layer.cornerRadius = cornerRadius
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppearCalled")

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: Fetch requests
        let genreFetchrequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        let yearRangeFetchRequest: NSFetchRequest<YearRange> = YearRange.fetchRequest()
        let actorFetchRequest: NSFetchRequest<Actor> = Actor.fetchRequest()
        
        // MARK: Call to fetch requests
        makeGenreFetchRequest(genreFetchrequest)
        makeYearRangeFetchRequest(yearRangeFetchRequest)
        makeActorFetchRequest(actorFetchRequest)
        
        // Deletes all genres that are empty
        for item in SelectionViewController.managedGenreArray {
            deleteAllEmptyGenres()
        }
        
        do {
            try dataController.viewContext.save()
        } catch  {
            print("will not save in \(#function)")
        }
        
    }
    
    // MARK: - Core Data functions
    
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
    fileprivate func makeGenreFetchRequest(_ fetchRequest: NSFetchRequest<Genre>) {
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            
            for item in result {
                deleteEmptyGenre(withGenre: item)
            }
            
            SelectionViewController.managedGenreArray = result
            print("result count is: \(result.count)")
            
            DispatchQueue.main.async {
                if result.count == 1 {
                    self.genresSelectedLabel.text = "\(result.count) genre selected"
                } else if result.count > 0 {
                    self.genresSelectedLabel.text = "\(result.count) genres selected"
                } else {
                    self.genresSelectedLabel.text = "No genres selected"
                }
            }
            
        }
    }
    
    fileprivate func makeYearRangeFetchRequest(_ fetchRequest: NSFetchRequest<YearRange>) {
        
        // Takes the results of the fetch request
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            
            SelectionViewController.releaseWindowArray = result
            
            if result.count > 0 {
                if let firstResult = result.first {
                    releaseWindowLabel.text = "Between \(firstResult.yearFrom) and \(firstResult.yearTo)"
                    SelectionViewController.yearTo = Int(firstResult.yearTo)
                    SelectionViewController.yearFrom = Int(firstResult.yearFrom)
                }
                
            }
            
        }
    }
    
    fileprivate func makeActorFetchRequest(_ fetchRequest: NSFetchRequest<Actor>) {
        
        // Takes the results of the fetch request
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            
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
    }
    
    // MARK: - IBActions
    
    @IBAction func spinForMovie(_ sender: Any) {
        
        TMDBClient.searchForMovies(withTheseGenres: Array(genreCodeSet), from: SelectionViewController.yearFrom, to: SelectionViewController.yearTo, withActorCode: actorId) { (success, stringArray, error) in
            
            if CheckConnectivity.isConnectedToInternet == false {
                self.presentAlertControllerDismiss(title: "There is no internet connection!", message: "Please check your connection and try again.")
                return
            }
            
            self.beginAnimating()
            
            if error != nil {
                self.presentAlertControllerDismiss(title: "There was an error.", message: "\(error!.localizedDescription)")
            }
            
            if success {
                self.endAnimating()
                self.moviesArray = stringArray
                if stringArray.count > 0 {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        // Adapted from Stack Overflow post
        if segue.identifier == "chooseGenres" {
            let destinationVC = segue.destination as! GenresTableViewController
            destinationVC.dataController = dataController
            GenresTableViewController.managedGenreArray = SelectionViewController.managedGenreArray
        } else if segue.identifier == "chooseReleaseWindow" {
            let destinationVC = segue.destination as! ReleaseWindowViewController
            ReleaseWindowViewController.dataController = dataController
            ReleaseWindowViewController.releaseWindowArray = SelectionViewController.releaseWindowArray
            
        } else if segue.identifier == "chooseActor" {
            let destinationVC = segue.destination as! ActorSearchViewController
            destinationVC.dataController = dataController
        }
    }
    
    public func presentAlertControllerDismiss(title: String, message: String) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
}

// MARK: - Viewfunctions
extension SelectionViewController {
    
    func beginAnimating () {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        backgroundIndicatorView.isHidden = false
    }
    
    func endAnimating() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        backgroundIndicatorView.isHidden = true
    }
}

