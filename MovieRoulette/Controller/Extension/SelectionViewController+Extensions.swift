//
//  SelectionViewController+Extensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 11/8/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import CoreData

extension SelectionViewController {
    
    // MARK: - Core Data functions
    func setupFetchRequest() {
        
        // MARK: Fetch requests
        let genreFetchrequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        let actorFetchRequest: NSFetchRequest<Actor> = Actor.fetchRequest()
        
        // MARK: Call to fetch requests
        makeGenreFetchRequest(genreFetchrequest)
        makeActorFetchRequest(actorFetchRequest)
        
        // Deletes all genres that have "0" as a genre code
        deleteAllEmptyGenres()
        
        do {
            try dataController.viewContext.save()
        } catch  {
            print("There was a problem saving in in \(#function)")
        }
    }
    
    func deleteAllEmptyGenres() {
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
    
    func makeGenreFetchRequest(_ fetchRequest: NSFetchRequest<Genre>) {
        
        let result = makeFetchRequest(fetchRequest)
        
        for item in result {
            deleteEmptyGenre(withGenre: item)
        }
        
        SelectionViewController.managedGenreArray = result
    }
    
    func makeActorFetchRequest(_ fetchRequest: NSFetchRequest<Actor>) {
        
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
    
    //MARK: - Networking Code
    func findRandomMovie() {
        
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
}
