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


