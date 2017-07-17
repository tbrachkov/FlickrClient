//
//  FeedPresenter.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation

class FeedPresenter {
    let interactor: FeedInteractorInput
    let coordinator: FeedCoordinatorInput
    weak var output: FeedPresenterOutput?

    init(interactor: FeedInteractorInput, coordinator: FeedCoordinatorInput) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
}

// MARK: - User Events -

extension FeedPresenter: FeedPresenterInput {
    func viewCreated() {

    }
}

// MARK: - Presentation Logic -

// INTERACTOR -> PRESENTER (indirect)
extension FeedPresenter: FeedInteractorOutput {

}
