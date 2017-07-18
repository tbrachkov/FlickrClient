//
//  TestPersistentContainer.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 19/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    class func testContainer() -> NSPersistentContainer {
        
        let momdName = "FlickrClient" //pass this as a parameter
        
        guard let modelURL = Bundle.main.url(forResource: momdName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let _ = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let container = NSPersistentContainer(name: "FlickrClient")
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { (description, error) in
            print(description)
            if let error = error {
                fatalError("\(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }
}
