//
//  FeedModels.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import FlickrKit
import CoreData

enum Feed {
    enum Request { }
    enum Response { }
    enum DisplayData { }
}

extension Feed.Request {
    enum StartFlickrImagesFetch {
        case last
    }
    enum RequestFetchResultsController {
        case initial
    }
}

extension Feed.Response {
    enum FinishedFlickrImagesFetch {
        case success(photos: [FlickrPhoto])
        case error(error: Error)
    }
    enum ReturnFetchResultsController {
        case success(frc: NSFetchedResultsController<Photo>)
    }
}

extension Feed.DisplayData {
    enum FeedPhotoResult {
        case success(photos: [FlickrPhoto])
        case error(error: Error)
    }
}
