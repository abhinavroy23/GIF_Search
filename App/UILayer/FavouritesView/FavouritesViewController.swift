//
//  FavouritesViewController.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 24/01/21.
//

import UIKit
import GIFInterfaces

// MARK:- FavouritesViewController
class FavouritesViewController: UIViewController {
  
  // MARK:- IB Outlets
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK:- Instance Variables
  
  /// Capabilities
  private var gifCachingService: GIFCachingInterface!
  private var gifService: GIFInterface!
  private var favouriteService: GIFFavouritesInterface!
  private var collectionHandler: GIFCollectionViewHandler!
  
  /// ViewModel
  var viewModel: FavouritesViewModel!
  
  // MARK:- Default lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCapabilities()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchFavourites()
  }
  
  /// Configure `capabilities & viewModel` for `FavouritesViewController`.
  /// This  must be called before anything else in FavouritesViewController
  private func configureCapabilities() {
    self.gifCachingService = GIFCachingService()
    self.favouriteService = GIFFavouritesService(cachingService: self.gifCachingService)
    self.gifService = GIFService(cachingService: self.gifCachingService)
    self.viewModel = FavouritesViewModel(favouriteService: self.favouriteService)
    self.collectionHandler = GIFCollectionViewHandler(collectionView: self.collectionView,
                                                      gifService: self.gifService,
                                                      favouriteService: self.favouriteService,
                                                      viewModel: self.viewModel,
                                                      delegate: self)
  }
  
  func fetchFavourites(completionHandler completion: (()->())? = nil) {
    viewModel.fetchFavourites {
      completion?()
      collectionHandler.reloadCollectionView()
    }
  }
}

// MARK:- Conformance to GIFCollectionViewHandlerDelegate
extension FavouritesViewController: GIFCollectionViewHandlerDelegate {
  func showCellError(errorMessage: String) {
    DispatchQueue.main.async {
      UIAlertController.showError(withMessage: errorMessage, onViewController: self)
    }
  }
  
  func fetchNextBatch() {
    // TODO: Update in future
    // To support pagination in Favourites view
  }
}
