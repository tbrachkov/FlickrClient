//
//  PhotoDetailsPresenter.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailsPresenter {
    let interactor: PhotoDetailsInteractorInput
    weak var coordinator: PhotoDetailsCoordinatorInput?
    weak var output: PhotoDetailsPresenterOutput?

    init(interactor: PhotoDetailsInteractorInput, coordinator: PhotoDetailsCoordinatorInput) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
}

// MARK: - User Events -
extension PhotoDetailsPresenter: PhotoDetailsPresenterInput {
    func savePhoto(_ photo: UIImage) {
        self.interactor.savePhoto(photo)
    }
    func viewCreated() {
    }
}

// MARK: - Presentation Logic -
extension PhotoDetailsPresenter: PhotoDetailsInteractorOutput {}
