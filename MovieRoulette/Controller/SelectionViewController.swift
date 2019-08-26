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

class SelectionViewController: UIViewController {
    
    var genreCodeSet = Set<Int>()
    
    var moviesArray = [String]()
    
    var yearsArray = [Int]()
    
    var yearFrom: Int = 1960
    
    var yearTo: Int = 2019
    
    var movieSelectionParameters: MovieSelectionParameters?

    @IBOutlet weak var spinForMovieButton: UIButton!
    @IBOutlet weak var chooseGenreButton: UIButton!
    @IBOutlet var chooseReleaseWindowButton: UIView!
    
    
    @IBAction func spinForMovie(_ sender: Any) {
        TMDBClient.searchForMovies(withTheseGenres: genreCodeSet, from: yearFrom, to: yearTo) { (success, stringArray, error) in
            if success {
                self.moviesArray = stringArray
                if stringArray.count > 0 {
                    let randomNumber = Int.random(in: 0...stringArray.count)
                    print("The movie you are watching tonight is \(self.moviesArray[randomNumber])")
                } else {
                    print("there are no movies to choose from!")
                }
                
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func confirmGenreSelection(_ unwindSegue: UIStoryboardSegue) {
        print("unwind called")
        guard let genresTableViewController = unwindSegue.source as? GenresTableViewController else {
            print("could not find source!")
            return
        }
        let passedGenereCodeSet = GenresTableViewController.genreCodeSet
        print("passedGenreCodeSet: \(passedGenereCodeSet)")
        self.genreCodeSet = passedGenereCodeSet
        print("genreCodeSet after passing: \(self.genreCodeSet)")
        
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
    
    
    
    @IBAction func chooseGenres(_ sender: Any) {
        performSegue(withIdentifier: "chooseGenres", sender: self.genreCodeSet)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Adapted from Stack Overflow post
        if segue.identifier == "chooseGenres" {
            let controller = segue.destination as! GenresTableViewController
        } else if segue.identifier == "chooseReleaseWindow" {
            let controller = segue.destination as! ReleaseWindowViewController
        }
    }
    
    
    func constructUrl(withTheseGenres genreCodes: Set<Int>?) {
        
    }
}

