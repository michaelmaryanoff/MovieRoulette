//
//  GenresTableViewController+Extensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/19/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation
import UIKit

extension GenresTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GenreConstants.genresArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
        
        setupTableViewCell(cell: cell)
        
        cell.textLabel?.text = GenreConstants.genresArray[indexPath.row]
        
        for item in GenresTableViewController.managedGenreArray {
            
            if let itemString = item.genreName {
                if cell.textLabel?.text == itemString {
                    cell.accessoryType = .checkmark
                }
                
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCell = tableView.cellForRow(at: indexPath) else {
            print("cannot with current cell")
            return
        }
        
        if currentCell.accessoryType == .checkmark {
            currentCell.accessoryType = .none
            changeManagedGenreSet(forCell: currentCell, add: false, indexPath: indexPath)
        } else {
            currentCell.accessoryType = .checkmark
            changeManagedGenreSet(forCell: currentCell, add: true, indexPath: indexPath)
        }
        
    }
    
    func setupTableViewCell(cell: UITableViewCell) {
        let fontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Arial Rounded MT Bold"])
        
        cell.textLabel?.font = UIFont(descriptor: fontDescriptor, size: 16)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = Colors.pinkOrange
        cell.textLabel?.shadowColor = .black
        cell.textLabel?.shadowOffset = CGSize(width: 0.9, height: 0.9)
    }
    
}

// MARK: - Segue extension
extension GenresTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let newSelectionVC = viewController as? SelectionViewController
        if viewController == newSelectionVC {
        } else {
            print("We are using a different segue.")
        }
        do {
            try dataController.viewContext.save()
        } catch {
            print("could not save")
        }
    }
    
}
