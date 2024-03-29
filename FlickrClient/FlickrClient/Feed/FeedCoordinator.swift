//
//  FeedCoordinator.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FeedCoordinator: Coordinator {
    let navigationController: UINavigationController
    var children: [Coordinator] = []
    weak var delegate: FeedCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let interactor = FeedInteractor()
        let presenter = FeedPresenter(interactor: interactor, coordinator: self)
        let vc = FeedViewController(presenter: presenter)

        interactor.output = presenter
        presenter.output = vc
        navigationController.setViewControllers([vc], animated: false)
    }
}

extension FeedCoordinator: FeedCoordinatorInput {
    func didSelectPhoto(_ photo: UIImage) {
        delegate?.didSelectPhoto(photo)
    }
}
