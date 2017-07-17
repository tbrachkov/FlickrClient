//
//  PhotoDetailsCoordinator.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailsCoordinator: Coordinator {
    let navigationController: UINavigationController
    var children: [Coordinator] = []
//    weak var delegate: PhotoDetailsCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let interactor = PhotoDetailsInteractor()
        let presenter = PhotoDetailsPresenter(interactor: interactor, coordinator: self)
        let vc = PhotoDetailsViewController(presenter: presenter)

        interactor.output = presenter
        presenter.output = vc

        // FIXME: Display as you need
        // navigationController.setViewControllers([vc], animated: false)
    }
}

// PRESENTER -> COORDINATOR
extension PhotoDetailsCoordinator: PhotoDetailsCoordinatorInput {

}
