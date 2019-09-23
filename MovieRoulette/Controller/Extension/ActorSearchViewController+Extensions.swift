//
//  ActorSearchViewController+Extensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/23/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ActorSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath) as! CustomActorCell
        
        setupCellCharacteristics(forCell: cell)
        
        let movieTitle = actors[indexPath.row]
        
        cell.textLabel?.text = movieTitle
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selectedActorInt = actorsIdArray[selectedIndex]
        self.selectedActorId = selectedActorInt
        
        for actor in managedActorsArray {
            dataController.viewContext.delete(actor)
            managedActorsArray.removeAll()
            do {
                try dataController.viewContext.save()
            } catch {
                print("could not save actor deletion")
            }
        }
        
        let actorFetchRequest: NSFetchRequest<Actor> = Actor.fetchRequest()
        deleteAllInViewContext(actorFetchRequest)
        
        let newActor = Actor(context: dataController.viewContext)
        newActor.actorName = actors[indexPath.row]
        newActor.actorId = Int64(selectedActorInt)
        
        managedActorsArray.append(newActor)
        do {
            try dataController.viewContext.save()
        } catch {
            print("Could not save actor")
        }
        performSegue(withIdentifier: "confirmActorSelection", sender: selectedActorInt)
        
        
    }
    
    // Sets up the view for the cell
    func setupCellCharacteristics(forCell cell: UITableViewCell) {
        let fontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Arial Rounded MT Bold"])
        cell.textLabel?.font = UIFont(descriptor: fontDescriptor, size: 16)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = Colors.pinkOrange
        cell.textLabel?.shadowColor = .black
        cell.textLabel?.shadowOffset = CGSize(width: 0.9, height: 0.9)
    }
    
}


