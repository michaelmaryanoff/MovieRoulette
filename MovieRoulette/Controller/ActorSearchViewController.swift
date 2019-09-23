//
//  ActorSearchViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/26/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit
import CoreData


class ActorSearchViewController: UIViewController  {
    
    //MARK: - Variables
    
    // Non-managed variables
    var actors = [String]()
    var actorsIdArray = [Int]()
    var selectedIndex = 0
    var selectedActorId = 0
    var activityView = UIActivityIndicatorView(style: .whiteLarge)
    
    // Managed variables
    var managedActorsArray = [Actor]()
    var dataController: DataController!
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actorSearchBar: UISearchBar!
    
    //MARK: - Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.actorSearchBar.delegate = self
        
        // Sets up table view
        tableView.backgroundColor = Colors.pinkOrange
        self.view.addSubview(self.activityView)
        
    }
    

    
    @IBAction func unwindToSelectionViewController (segue: UIStoryboardSegue) {
        performSegue(withIdentifier: "confirmActorSelection", sender: selectedActorId)
    }
    
    func deleteAllInViewContext(_ fetchRequest: NSFetchRequest<Actor>) {
        
        // Takes the results of the fetch request
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            for object in result {
                dataController.viewContext.delete(object)
            }
            
            
        }
    }
}


//MARK: - Search bar deleage functions
extension ActorSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if CheckConnectivity.isConnectedToInternet == false {
            DispatchQueue.main.async {
                self.presentAlertControllerDismiss(title: "There is no internet connection!", message: "Please check your connection and try again.")
                self.changeActivityIndicatorState(isAnimating: false)
            }
            
        }

        self.changeActivityIndicatorState(isAnimating: true)

        TMDBClient.searchForActorID(query: searchText) { (success, actorStringArray, idIntArray, error) in
        
            
            if !actorStringArray.isEmpty {
                self.changeActivityIndicatorState(isAnimating: false)
            }
            
            if CheckConnectivity.isConnectedToInternet == false {
                DispatchQueue.main.async {
                    self.presentAlertControllerDismiss(title: "There is no internet connection!", message: "Please check your connection and try again.")
                    self.changeActivityIndicatorState(isAnimating: false)
                }
                
            }
            
            if actorStringArray.isEmpty && !searchText.isEmpty {
                DispatchQueue.main.async {
                    self.presentAlertControllerDismiss(title: "Could not find any actors.", message: "Please try again.")
                }
                
                
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
