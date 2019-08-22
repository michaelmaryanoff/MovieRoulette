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
        
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    
    var movieSelectionParameters: MovieSelectionParameters?

    @IBOutlet weak var spinForMovieButton: UIButton!
    @IBOutlet weak var chooseGenreButton: UIButton!
    
    @IBAction func spinForMovie(_ sender: Any) {
        TMDBClient.searchForMovies(withTheseGenres: genreCodeSet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("genreCodeSet in SelectionViewController: \(genreCodeSet)")
        // Do any additional setup after loading the view.
        
//        TMDBClient.getGenres()
        
    }
    
    
    @IBAction func chooseGenres(_ sender: Any) {
        performSegue(withIdentifier: "chooseGenres", sender: self.genreCodeSet)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! GenresTableViewController
        
    }
}

