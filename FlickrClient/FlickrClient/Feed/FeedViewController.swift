//
//  FeedViewController.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    let presenter: FeedPresenterInput

    convenience init(presenter: FeedPresenterInput) {
        self.init(presenter: presenter, nibName: nil, bundle: nil)
    }

    init(presenter: FeedPresenterInput, nibName: String?, bundle: Bundle?) {
        self.presenter = presenter
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewCreated()
    }

    // MARK: - Callbacks -

}

// MARK: - Display Logic -

// PRESENTER -> VIEW
extension FeedViewController: FeedPresenterOutput {

}
