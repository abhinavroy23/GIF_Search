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
  private var collectionHandler: GIFCollectionViewHandler!
  
  /// ViewModel
  private var viewModel: FavouritesViewModel!
  
  // MARK:- Default lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCapabilities()
  }
  
  /// Configure `capabilities & viewModel` for `FavouritesViewController`.
  /// This  must be called before anything else in FavouritesViewController
  private func configureCapabilities() {
    self.gifCachingService = GIFCachingService()
    self.gifService = GIFService(cachingService: self.gifCachingService)
    self.viewModel = FavouritesViewModel()
    self.collectionHandler = GIFCollectionViewHandler(collectionView: self.collectionView,
                                                      gifService: self.gifService,
                                                      viewModel: self.viewModel,
                                                      delegate: self)
  }
}

extension FavouritesViewController: GIFCollectionViewHandlerDelegate {
  func fetchNextBatch() {
    
  }
}
