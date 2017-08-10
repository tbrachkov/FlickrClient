//
//  FeedInteractor.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import FlickrKit
import CoreData

class FeedInteractor {
    weak var output: FeedInteractorOutput?
    static let flickrClient = FlickrClient()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FlickrClient")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    @discardableResult fileprivate func storeFetchedData(photos: [FlickrPhoto], forTag: String = "") -> [Photo] {
        let coreDataService = CoreDataStackService(managedObjectContext: persistentContainer.newBackgroundContext())
        return coreDataService.addPhotos(photos, forTag: forTag)
    }
}

// MARK: - Business Logic -
extension FeedInteractor: FeedInteractorInput {
    func performPhotoFetch(_ request: Feed.Request.StartFlickrImagesFetch) {
        switch request {
        case .feed:
            FeedInteractor.flickrClient.getPhotoFeed { (result) in
                switch result {
                case .error( _, let error):
                    let genericError = NSError(domain: "com.flickr.client", code: 909, userInfo: nil)
                    let result = Feed.Response.FinishedFlickrImagesFetch.error(error: error ?? genericError)
                    self.output?.fetchedFlickrPhotos(result)
                case .success( _, let photos):
                    let result = Feed.Response.FinishedFlickrImagesFetch.success(photos: photos)
                    self.output?.fetchedFlickrPhotos(result)
                    self.storeFetchedData(photos: photos)
                }
            }
        case .tag(let searchTag):
            FeedInteractor.flickrClient.getPhotosFor(tag: searchTag) { (result) in
                switch result {
                case .error( _, let error):
                    let genericError = NSError(domain: "com.flickr.client", code: 909, userInfo: nil)
                    let result = Feed.Response.FinishedFlickrImagesFetch.error(error: error ?? genericError)
                    self.output?.fetchedFlickrPhotos(result)
                case .success( _, let photos):
                    let result = Feed.Response.FinishedFlickrImagesFetch.success(photos: photos)
                    self.output?.fetchedFlickrPhotos(result)
                    self.storeFetchedData(photos: photos, forTag: searchTag)
                }
            }
        }
    }
    
    func requestFetchresultsController(_ request: Feed.Request.RequestFetchResultsController) {
        
        switch request {
        case .feed:
            guard let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo") as? NSFetchRequest<NSFetchRequestResult> else {
                fatalError()
            }
            let entity = NSEntityDescription.entity(forEntityName: "Photo", in: self.persistentContainer.viewContext)
            fetchRequest.entity = entity
            let sortDescriptor = NSSortDescriptor(key: "published", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            _fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
            guard let frc = _fetchedResultsController as? NSFetchedResultsController<Photo> else {
                fatalError()
            }
            
            let resultFRC = Feed.Response.ReturnFetchResultsController.success(frc: frc)
            self.output?.returnFetchresultsController(resultFRC)
        case .tag(let searchTag):
            guard let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo") as? NSFetchRequest<NSFetchRequestResult> else {
                fatalError()
            }
            let entity = NSEntityDescription.entity(forEntityName: "Photo", in: self.persistentContainer.viewContext)
            fetchRequest.entity = entity
            let sortDescriptor = NSSortDescriptor(key: "published", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = NSPredicate(format: "tag CONTAINS[cd] %@", searchTag)
            
            let _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            _fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
            guard let frc = _fetchedResultsController as? NSFetchedResultsController<Photo> else {
                fatalError()
            }
            
            let resultFRC = Feed.Response.ReturnFetchResultsController.success(frc: frc)
            self.output?.returnFetchresultsController(resultFRC)
        }
    }
}
