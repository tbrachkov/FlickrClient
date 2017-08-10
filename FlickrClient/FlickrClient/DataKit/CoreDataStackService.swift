//
//  CoreDataStackHelper.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 18/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import CoreData
import FlickrKit

class CoreDataStackService: NSObject {
    // MARK: Properties
    let managedObjectContext: NSManagedObjectContext
    
    // MARK: Initializers
    public init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}

// MARK: Public
extension CoreDataStackService {
    func addPhotos(_ photos: [FlickrPhoto]) -> [Photo] {
        var resultPhotos: [Photo] = []
        for picture in photos {
            if let datePublished = picture.published.dateFromISO8601 {
                if !checkPhotoExists(withURL: picture.media) {
                    let photo = Photo(context: managedObjectContext)
                    photo.imageLink = picture.media
                    photo.name = picture.title
                    photo.published = datePublished
                    resultPhotos.append(photo)
                }
            }
        }
        managedObjectContext.perform {
            do {
                try self.managedObjectContext.save()
            } catch let error {
                print(error)
            }
        }
        return resultPhotos
    }
    
    private func checkPhotoExists(withURL url: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        let predicate = NSPredicate(format: "imageLink == %@", url)
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let context = self.managedObjectContext
            let count = try context.count(for: request)
            if count == 0 {
                return false
            } else {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }
}
