//
//  PhotoDetailsProtocols.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit

// ======== Coordinator ======== //

// PRESENTER -> COORDINATOR
protocol PhotoDetailsCoordinatorInput {

}

// ======== Interactor ======== //

// PRESENTER -> INTERACTOR
protocol PhotoDetailsInteractorInput {
    func savePhoto(_ photo: UIImage)
}

// INTERACTOR -> PRESENTER (indirect)
protocol PhotoDetailsInteractorOutput: class {

}

// ======== Presenter ======== //

// VIEW -> PRESENTER
protocol PhotoDetailsPresenterInput {
    func viewCreated()
    func savePhoto(_ photo: UIImage)
}

// PRESENTER -> VIEW
protocol PhotoDetailsPresenterOutput: class {

}
