//
//  FlickrClientTests.swift
//  FlickrClientTests
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import XCTest
@testable import FlickrClient
import CoreData
@testable import FlickrKit

class FlickrClientTests: XCTestCase {
    
    // MARK: Properties
    var coreDataStackService: CoreDataStackService!
    var persistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        persistentContainer = NSPersistentContainer.testContainer()
        coreDataStackService = CoreDataStackService(managedObjectContext: persistentContainer.viewContext)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStackService = nil
        persistentContainer = nil
    }
    
    // Test that the weather is not nil and has attributes set
    func testAddPhoto() {
        let flickrPhoto = FlickrPhoto(title: "DEMO DEMO", media: "http://demo.com", published: "2017-07-18T23:17:32Z")
        let photo = coreDataStackService.addPhotos([flickrPhoto]).first
        
        XCTAssertNotNil(photo, "Photo is not nil")
        XCTAssertTrue(photo?.imageLink == "http://demo.com")
        XCTAssertTrue(photo?.name == "DEMO DEMO")
        XCTAssertTrue(photo?.published == "2017-07-18T23:17:32Z".dateFromISO8601)
    }
    
    // Test that the service saves
    func testContextIsSavedAfterAddingCamper() {
        let derivedContext = persistentContainer.newBackgroundContext()
        coreDataStackService = CoreDataStackService(managedObjectContext: derivedContext)
        
        expectation(forNotification: NSNotification.Name.NSManagedObjectContextDidSave.rawValue, object: derivedContext) { (notification) -> Bool in
            return true
        }
        
        let flickrPhoto = FlickrPhoto(title: "DEMO DEMO", media: "http://demo.com", published: "2017-07-18T23:17:32Z")
        let photo = coreDataStackService.addPhotos([flickrPhoto]).first
        
        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error, "Save did not work")
        }
    }
    
    // Test Performance CoreData

    func testPerformanceCoreData() {
        // This is an example of a performance test case.
        self.measure {
            var photos: [FlickrPhoto] = []
            for _ in 0..<100 {
                let flickrPhoto = FlickrPhoto(title: "DEMO DEMO", media: "http://demo.com", published: "2017-07-18T23:17:32Z")
                photos.append(flickrPhoto)
                self.coreDataStackService.addPhotos(photos)
            }
            // Put the code you want to measure the time of here.
        }
    }
    
}
