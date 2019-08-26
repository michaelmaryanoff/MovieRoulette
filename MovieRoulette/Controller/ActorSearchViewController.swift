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
    
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TMDBClient.searchForActorID(query: "Tom")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath)
        
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
        
    }
}
