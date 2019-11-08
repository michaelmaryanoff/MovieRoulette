//
//  DataController.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/27/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import CoreData


// This class is used to set up a Data Controller that can be passed between classes
class DataController {
    
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
