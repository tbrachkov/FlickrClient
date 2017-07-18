//
//  FeedProtocols.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit

// ======== Coordinator ======== //

// PRESENTER -> COORDINATOR
protocol FeedCoordinatorInput {

}

// ======== Interactor ======== //

// PRESENTER -> INTERACTOR
protocol FeedInteractorInput {
    func performPhotoFetch(_ request: Feed.Request.StartFlickrImagesFetch)
    func requestFetchresultsController(_ request: Feed.Request.RequestFetchResultsController)
}

// INTERACTOR -> PRESENTER (indirect)
protocol FeedInteractorOutput: class {
    func fetchedFlickrPhotos(_ result: Feed.Response.FinishedFlickrImagesFetch)
    func returnFetchresultsController(_ result: Feed.Response.ReturnFetchResultsController)
}

// ======== Presenter ======== //

// VIEW -> PRESENTER
protocol FeedPresenterInput {
    func viewCreated()
    func reloadPhotos()
}

// PRESENTER -> VIEW
protocol FeedPresenterOutput: class {
    func presentFetchedFlickrPhotos(_ presentData: Feed.DisplayData.FeedPhotoResult)
    func returnFetchresultsController(_ frc: Feed.Response.ReturnFetchResultsController)
}
