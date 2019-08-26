//
//  ActorSearchViewController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/26/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import UIKit


class ActorSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var actors = [String]()
    var actorsIdArray = [Int]()
    
    var selectedIndex = 0
    var selectedActorId = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath)
        
        let movieTitle = actors[indexPath.row]
        
        cell.textLabel?.text = movieTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selectedActorInt = actorsIdArray[selectedIndex]
        self.selectedActorId = selectedActorInt
        print(selectedActorInt)
        print(self.selectedActorId)
        unwindToSelectionViewController(segue: newSeuge)
        
    }
    @IBAction func unwindToSelectionViewController (segue: UIStoryboardSegue) {
        performSegue(withIdentifier: "unwindToSelectionVC", sender: selectedActorId)
    }

}



extension ActorSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        TMDBClient.searchForActorID(query: searchText) { (success, actorStringArray, idIntArray, error) in
            print("actorStringArray in \(#function) actorStringArray")
            self.actors = actorStringArray
            self.actorsIdArray = idIntArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
