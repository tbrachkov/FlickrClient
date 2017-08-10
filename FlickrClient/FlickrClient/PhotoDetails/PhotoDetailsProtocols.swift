//
//  PhotoDetailsProtocols.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit

//Coordinator
protocol PhotoDetailsCoordinatorInput: class {}

//Interactor
protocol PhotoDetailsInteractorInput {
    func savePhoto(_ photo: UIImage)
}
protocol PhotoDetailsInteractorOutput: class {}

//Presenter
protocol PhotoDetailsPresenterInput {
    func viewCreated()
    func savePhoto(_ photo: UIImage)
}
protocol PhotoDetailsPresenterOutput: class {}
