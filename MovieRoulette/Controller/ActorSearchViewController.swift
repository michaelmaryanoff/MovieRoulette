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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        
//        TMDBClient.searchForActorID(query: "tom") { (success, actorStringArray, idIntArray, error) in
//            if success {
//                self.actors = actorStringArray
//                self.actorsIdArray = idIntArray
//                print("actors array is \(self.actors)")
//                print("actors id array is \(self.actorsIdArray)")
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            }
//        }
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ActorSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
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
