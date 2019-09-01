//
//  ActorSearchViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/26/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit
import CoreData


class ActorSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var actors = [String]()
    var actorsIdArray = [Int]()
    var managedActorsArray = [Actor]()
    
    var dataController: DataController!
    
    var selectedIndex = 0
    var selectedActorId = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        tableView.backgroundColor = Colors.pinkOrange
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath)
        
        
        setupCellCharacteristics(forCell: cell)
        
        let movieTitle = actors[indexPath.row]
        
        cell.textLabel?.text = movieTitle
        
        return cell
    }
    
    func setupCellCharacteristics(forCell cell: UITableViewCell) {
        let fontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Arial Rounded MT Bold"])
        cell.textLabel?.font = UIFont(descriptor: fontDescriptor, size: 16)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = Colors.pinkOrange
        cell.textLabel?.shadowColor = .black
        cell.textLabel?.shadowOffset = CGSize(width: 0.9, height: 0.9)
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
    @IBAction func unwindToSelectionViewController (segue: UIStoryboardSegue) {
        performSegue(withIdentifier: "confirmActorSelection", sender: selectedActorId)
    }
    
    fileprivate func deleteAllInViewContext(_ fetchRequest: NSFetchRequest<Actor>) {
        
        // Takes the results of the fetch request
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            for object in result {
                dataController.viewContext.delete(object)
            }
            
            
        }
    }
}

extension ActorSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        TMDBClient.searchForActorID(query: searchText) { (success, actorStringArray, idIntArray, error) in
            
            
            if CheckConnectivity.isConnectedToInternet == false {
                self.presentAlertControllerDismiss(title: "There is no internet connection!", message: "Please check your connection and try again.")
                return
            }
            
            self.actors = actorStringArray
            self.actorsIdArray = idIntArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    public func presentAlertControllerDismiss(title: String, message: String) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}
