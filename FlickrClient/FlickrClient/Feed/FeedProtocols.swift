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

}

// INTERACTOR -> PRESENTER (indirect)
protocol FeedInteractorOutput: class {

}

// ======== Presenter ======== //

// VIEW -> PRESENTER
protocol FeedPresenterInput {
    func viewCreated()
}

// PRESENTER -> VIEW
protocol FeedPresenterOutput: class {

}
