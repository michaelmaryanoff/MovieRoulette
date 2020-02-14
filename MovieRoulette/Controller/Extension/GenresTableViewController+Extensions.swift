//
//  GenresTableViewController+Extensions.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/19/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

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
        
        // Ensures that cell selected fades out.
        tableView.deselectRow(at: indexPath, animated: true)
        
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

// Note: this extension has been changed to an extension on the Selection View controller
extension SelectionViewController: UINavigationControllerDelegate {
    // This function uses the navigation controller to pass information between view controllers
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let newSelectionVC = viewController as? SelectionViewController
        if viewController == newSelectionVC {
            print("we are using the selection vc in \(#function)")
            newSelectionVC?.genreCount = GenresTableViewController.managedGenreArray.count
            print("GenresTableViewController.managedGenreArray.count" + " -=-> " + "\(GenresTableViewController.managedGenreArray.count)")
        } else {
            print("selectionVC -> genresVC")
        }
        do {
            try dataController.viewContext.save()
        } catch {
            
        }
    }
    
}
