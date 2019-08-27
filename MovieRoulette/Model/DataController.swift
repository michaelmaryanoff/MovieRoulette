//
//  DataController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/27/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    // Sets up persistent container
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void )? = nil) {
        persistentContainer.loadPersistentStores {
            storDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
