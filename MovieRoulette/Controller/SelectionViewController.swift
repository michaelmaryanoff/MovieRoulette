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
    
    var genresArray = [Int]()

    @IBOutlet weak var chooseGenreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TMDBClient.getGenres()
        
    }
    
    
    @IBAction func chooseGenres(_ sender: Any) {
        
    }
    

}

