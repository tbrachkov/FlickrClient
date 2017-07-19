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
    let photo: UIImage
    var children: [Coordinator] = []

    init(navigationController: UINavigationController, photo: UIImage) {
        self.navigationController = navigationController
        self.photo = photo
    }

    func start() {
        let interactor = PhotoDetailsInteractor()
        let presenter = PhotoDetailsPresenter(interactor: interactor, coordinator: self)
        let vc = PhotoDetailsViewController(presenter: presenter, photo: photo)

        interactor.output = presenter
        presenter.output = vc

        navigationController.pushViewController(vc, animated: true)
    }
}

// PRESENTER -> COORDINATOR
extension PhotoDetailsCoordinator: PhotoDetailsCoordinatorInput {

}
