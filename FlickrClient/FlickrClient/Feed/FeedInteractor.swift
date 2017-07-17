//
//  FeedInteractor.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation

class FeedInteractor {
    weak var output: FeedInteractorOutput?
}

// MARK: - Business Logic -

// PRESENTER -> INTERACTOR
extension FeedInteractor: FeedInteractorInput {
}
