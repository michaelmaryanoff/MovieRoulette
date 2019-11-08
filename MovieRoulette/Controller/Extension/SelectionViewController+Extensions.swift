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
}
