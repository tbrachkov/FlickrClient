//
//  FeedPresenter.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit

class FeedPresenter {
    let interactor: FeedInteractorInput
    weak var coordinator: FeedCoordinatorInput?
    weak var output: FeedPresenterOutput?

    init(interactor: FeedInteractorInput, coordinator: FeedCoordinatorInput) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
}

// MARK: - User Events -
extension FeedPresenter: FeedPresenterInput {
    func didSelectPhoto(_ photo: UIImage) {
        coordinator?.didSelectPhoto(photo)
    }
    func viewCreated() {
        self.interactor.requestFetchresultsController(Feed.Request.RequestFetchResultsController.initial)
    }
    func reloadPhotos() {
        self.interactor.performPhotoFetch(Feed.Request.StartFlickrImagesFetch.last)
    }
}

// MARK: - Presentation Logic -
extension FeedPresenter: FeedInteractorOutput {
    func returnFetchresultsController(_ result: Feed.Response.ReturnFetchResultsController) {
        self.output?.returnFetchresultsController(result)
        self.interactor.performPhotoFetch(Feed.Request.StartFlickrImagesFetch.last)
    }

    func fetchedFlickrPhotos(_ result: Feed.Response.FinishedFlickrImagesFetch) {
        switch result {
        case .error(let error):
            let presentData = Feed.DisplayData.FeedPhotoResult.error(error: error)
            self.output?.presentFetchedFlickrPhotos(presentData)
        case.success(let photos):
            let presentData = Feed.DisplayData.FeedPhotoResult.success(photos: photos)
            self.output?.presentFetchedFlickrPhotos(presentData)
        }
    }
}
