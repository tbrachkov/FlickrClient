//
//  PhotoDetailsInteractor.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoDetailsInteractor {
    weak var output: PhotoDetailsInteractorOutput?
}

// MARK: - Business Logic -
extension PhotoDetailsInteractor: PhotoDetailsInteractorInput {
    func savePhoto(_ photo: UIImage) {
        PHPhotoLibrary.shared().savePhoto(image: photo, albumName: "Fickr")
    }
}
