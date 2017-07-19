//
//  PhotoDetailsViewController.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let presenter: PhotoDetailsPresenterInput
    let photo: UIImage

    convenience init(presenter: PhotoDetailsPresenterInput, photo: UIImage) {
        self.init(presenter: presenter, photo: photo, nibName: nil, bundle: nil)
    }

    init(presenter: PhotoDetailsPresenterInput, photo: UIImage, nibName: String?, bundle: Bundle?) {
        self.presenter = presenter
        self.photo = photo
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        imageView.contentMode = .scaleAspectFit
        imageView.image = photo
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))

        presenter.viewCreated()
    }

    func saveTapped() {
        self.presenter.savePhoto(photo)
    }
    
    // MARK: - Callbacks -

}

// MARK: - Display Logic -

// PRESENTER -> VIEW
extension PhotoDetailsViewController: PhotoDetailsPresenterOutput {

}
