//
//  FeedViewController.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright (c) 2017 Todor Brachkov. All rights reserved.
//

import UIKit
import CoreData

class FeedViewController: UIViewController {

// MARK: - Properties -
    @IBOutlet weak var collectionView: UICollectionView!
    var refresher: UIRefreshControl!

    var insertedIndexPaths: [IndexPath] = []
    var deletedIndexPaths: [IndexPath] = []
    var updatedIndexPaths: [IndexPath] = []
    var fetchedResultsController: NSFetchedResultsController<Photo>?
    var searchBarActive: Bool = false
    var photosCount = 0
    var blockOperations: [BlockOperation] = []

    let presenter: FeedPresenterInput
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Tags"
        searchBar.delegate = self
        searchBar.tintColor = .black
        searchBar.barStyle = .default
        searchBar.sizeToFit()
        return searchBar
    }()
    
    fileprivate var searchTagPrivate: String {
        get {
            return self.searchTag
        }
        set {
            self.searchTag = newValue
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.updateSearch), object: nil)
            self.perform(#selector(self.updateSearch), with: nil, afterDelay: 1.0)
        }
    }
    var searchTag = ""

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
        
        self.title = "Feed"
        self.collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let refresher = UIRefreshControl()
        self.refresher = refresher
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
        
        presenter.viewCreated()
    }
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func loadData() {
        if searchBarActive {
            stopRefresher()
            return
        }
        self.presenter.reloadPhotos()
        //Call this to stop refresher
        stopRefresher()
    }
    
    func stopRefresher() {
        self.refresher.endRefreshing()
    }
    
    func performFetch(fetchedResultsController: NSFetchedResultsController<Photo>) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Could not fetch photos")
        }
    }
}

// MARK: - Search Logic -

extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.searchBarActive = true
            self.searchTagPrivate = searchText
        } else {
            cancelSearching()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self .cancelSearching()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.searchBar.setShowsCancelButton(true, animated: true)
    }

    func cancelSearching() {
        self.searchBarActive = false
        self.fetchedResultsController?.delegate = nil
        self.presenter.requestFetchresultsController(.feed)
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
    }
    
    func updateSearch() {
        self.presenter.searchFor(tag: searchTag)
        self.fetchedResultsController?.delegate = nil
        self.presenter.requestFetchresultsController(.tag(searchTag: self.searchTag))
    }
}

// MARK: - Display Logic -

// PRESENTER -> VIEW
extension FeedViewController: FeedPresenterOutput {
    func presentFetchedFlickrPhotos(_ presentData: Feed.DisplayData.FeedPhotoResult) {
        print(presentData)
    }
    
    func returnFetchresultsController(_ frc: Feed.Response.ReturnFetchResultsController) {
        switch frc {
        case .success(let frc):
            self.fetchedResultsController = frc
            self.fetchedResultsController?.delegate = self
            self.performFetch(fetchedResultsController: frc)
            self.photosCount = self.fetchedResultsController?.sections![0].numberOfObjects ?? 0
            collectionView?.reloadData()
        }
    }
}
// MARK: - Display CollectionView -

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = fetchedResultsController?.object(at: indexPath)
        cell.configureCell(photo?.imageLink ?? "http://crestaproject.com/demo/nucleare-pro/wp-content/themes/nucleare-pro/images/no-image-box.png", name: photo?.name ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        if let photo = cell.storedImage {
            self.presenter.didSelectPhoto(photo)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/3, height: collectionView.bounds.size.width/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath)
            header.addSubview(searchBar)
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
            searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
            searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
            searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
            return header
    }
}

// MARK: - Display FRC -

extension FeedViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == NSFetchedResultsChangeType.insert {
            print("Insert Object: \(String(describing: newIndexPath))")
            
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertItems(at: [newIndexPath!])
                        self?.photosCount+=1
                    }
                })
            )
        } else if type == NSFetchedResultsChangeType.update {
            print("Update Object: \(String(describing: indexPath))")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadItems(at: [indexPath!])
                    }
                })
            )
        } else if type == NSFetchedResultsChangeType.move {
            print("Move Object: \(String(describing: indexPath))")
            
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.moveItem(at: indexPath!, to: newIndexPath!)
                    }
                })
            )
        } else if type == NSFetchedResultsChangeType.delete {
            print("Delete Object: \(String(describing: indexPath))")
            
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteItems(at: [indexPath!])
                        self?.photosCount-=1
                    }
                })
            )
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        if type == NSFetchedResultsChangeType.insert {
            print("Insert Section: \(sectionIndex)")
            
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        } else if type == NSFetchedResultsChangeType.update {
            print("Update Section: \(sectionIndex)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        } else if type == NSFetchedResultsChangeType.delete {
            print("Delete Section: \(sectionIndex)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView!.performBatchUpdates({ () -> Void in
            for operation: BlockOperation in self.blockOperations {
                operation.start()
            }
        }, completion: { (_) -> Void in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }}
