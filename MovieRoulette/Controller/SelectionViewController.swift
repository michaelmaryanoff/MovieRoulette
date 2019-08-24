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
    
    @IBAction func confirmSelection(_ unwindSegue: UIStoryboardSegue) {
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
    
    
    
    var movieSelectionParameters: MovieSelectionParameters?

    @IBOutlet weak var spinForMovieButton: UIButton!
    @IBOutlet weak var chooseGenreButton: UIButton!
    @IBOutlet var chooseReleaseWindowButton: UIView!
    
    
    @IBAction func spinForMovie(_ sender: Any) {
        TMDBClient.searchForMovies(withTheseGenres: genreCodeSet) { (success, stringArray, error) in
            if success {
                print("moviesArray in network call: \(stringArray)")
                self.moviesArray = stringArray
                print("global moviesArray: \(self.moviesArray)")
                var randomNumber = Int.random(in: 0...stringArray.count)
                print("The movie you are watching tonight is \(self.moviesArray[randomNumber])")
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! GenresTableViewController
//
//    }
    
    func constructUrl(withTheseGenres genreCodes: Set<Int>?) {
        
    }
}

