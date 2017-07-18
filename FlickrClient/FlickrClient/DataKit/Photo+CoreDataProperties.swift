//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Todor Brachkov on 18/07/2017.
//
//

import Foundation
import CoreData
extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageLink: String?
    @NSManaged public var published: Date?
    
}
