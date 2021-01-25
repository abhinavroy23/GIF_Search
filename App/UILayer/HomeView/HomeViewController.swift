//
//  ViewController.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 21/01/21.
//

import UIKit
import GIFInterfaces
import GIFNetwork
import SDWebImage

// MARK:- HomeViewController
class HomeViewController: UIViewController {
  
  // MARK:- IB Outlets
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var loader: SDAnimatedImageView! {
    didSet {
      self.loader.image = UIImage.threeLoader
    }
  }
  @IBOutlet weak var loaderHeightContraint: NSLayoutConstraint!
  @IBOutlet weak var infinityLoader: SDAnimatedImageView! {
    didSet {
      self.infinityLoader.image = UIImage.threeLoader
    }
  }
  @IBOutlet weak var infinityLoaderHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  
  // MARK:- Instance Variables
  
  /// Capabilities
  private var gifCachingService: GIFCachingInterface!
  private var gifService: GIFInterface!
  private var networkService: NetworkInterface!
  private var gifApiService: GIFAPIInterface!
  private var favoutitesService: GIFFavouritesInterface!
  var collectionHandler: GIFCollectionViewHandler!
  
  /// ViewModel
  var viewModel: HomeViewModel!
  private var isSearchActive: Bool = false {
    didSet {
      viewModel.isSearchActive = self.isSearchActive
      cancelBarButton.isEnabled = self.isSearchActive
    }
  }
  
  // MARK:- Default lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureCapabilities()
    self.setupNavigation()
    self.fetchTrending(initialFetch: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionHandler.reloadCollectionView()
  }
  
  /// Configure `capabilities & viewModel` for `HomeViewController`.
  /// This  must be called before anything else in HomeViewController
  private func configureCapabilities() {
    self.gifCachingService = GIFCachingService()
    self.gifService = GIFService(cachingService: self.gifCachingService)
    self.networkService = GIFNetworkService()
    self.gifApiService = GIFAPIService(networkService: self.networkService)
    self.favoutitesService = GIFFavouritesService(cachingService: self.gifCachingService)
    self.viewModel = HomeViewModel(apiService: self.gifApiService)
    self.collectionHandler = GIFCollectionViewHandler(collectionView: self.collectionView,
                                                      gifService: self.gifService,
                                                      favouriteService: self.favoutitesService,
                                                      viewModel: self.viewModel,
                                                      delegate: self)
  }
}

// MARK:- View Model interaction
extension HomeViewController {
  
  func fetchTrending(initialFetch: Bool, completion: (()->())? = nil) {
    DispatchQueue.main.async {
      initialFetch ? self.showLoadingView(true) : self.showInfinityLoadingView(true)
    }
    viewModel.fetchTrending(initialFetch: initialFetch) { (success, error) in
      completion?()
      DispatchQueue.main.async {
        initialFetch ? self.showLoadingView(false) : self.showInfinityLoadingView(false)
        // Check if success else show error
        if success {
          // Reload/Update collection view
          self.collectionHandler.reloadCollectionView()
        } else if let error = error{
          // Show error coming form API client
          UIAlertController.showError(withMessage: error.localizedDescription, onViewController: self)
        } else {
          // Fallback - show default error
          UIAlertController.showError(withMessage: GIFClientError.unableToFetchData.description, onViewController: self)
        }
      }
    }
  }
  
  func fetchSearchResults(initialFetch: Bool, forQuery query: String, completion: (()->())? = nil) {
    DispatchQueue.main.async {
      initialFetch ? self.showLoadingView(true) : self.showInfinityLoadingView(true)
    }
    viewModel.fetchSearchResults(initialFetch: initialFetch, forQuery: query) { (success, error) in
      completion?()
      DispatchQueue.main.async {
        initialFetch ? self.showLoadingView(false) : self.showInfinityLoadingView(false)
        // check if success else show error
        if success {
          // Reload/Update collection view
          self.collectionHandler.reloadCollectionView()
        } else if let error = error{
          // Show error coming form API client
          UIAlertController.showError(withMessage: error.localizedDescription, onViewController: self)
        } else {
          // Fallback - show default error
          UIAlertController.showError(withMessage: GIFClientError.unableToFetchData.description, onViewController: self)
        }
      }
    }
  }
  
}

// MARK:- UI configuration
extension HomeViewController {
  private var threeLoaderHeightMin: CGFloat { get { 0.0 } }
  private var threeLoaderHeightMax: CGFloat { get { 40.0 } }
  
  private func setupNavigation() {
    self.navigationItem.titleView = searchBar
    cancelBarButton.action = #selector(cancelButton)
    cancelBarButton.target = self
    cancelBarButton.isEnabled = self.isSearchActive
  }
  
  private func showLoadingView(_ show: Bool) {
    self.loaderHeightContraint.constant = show ? threeLoaderHeightMax : threeLoaderHeightMin
  }
  
  private func showInfinityLoadingView(_ show: Bool) {
    self.infinityLoaderHeightConstraint.constant = show ? threeLoaderHeightMax : threeLoaderHeightMin
  }
  
}

// MARK:- Search Bar Delegate
extension HomeViewController: UISearchBarDelegate {

  // Search for a given search text
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text, !searchText.isEmpty {
      self.fetchSearchResults(initialFetch: true, forQuery: searchText)
    }
  }
  
  // Seach field did begin editing
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.isSearchActive = true
    DispatchQueue.main.async { self.collectionHandler.reloadCollectionView() }
  }
  
  // Search bar cancel
  @objc func cancelButton() {
    self.searchBar.text = nil
    self.searchBar.resignFirstResponder()
    self.isSearchActive = false
    self.viewModel.searchDataSource.flush()
    DispatchQueue.main.async {
      self.collectionHandler.reloadCollectionView()
      if self.viewModel.trendingDataSource.gifs.count > 0 {
        self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
      }
    }
  }
}

// MARK:- Conformance to `GIFCollectionViewHandlerDelegate`
extension HomeViewController: GIFCollectionViewHandlerDelegate {
  
  func didTapGIF(withUIModel uiModel: GIFUIResult) {
    let vc = DetailsViewController.instance(gifService: self.gifService, gifUIModel: uiModel)
    DispatchQueue.main.async {
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  func fetchNextBatch() {
    if viewModel.isSearchActive, let searchText = self.searchBar.text {
      self.fetchSearchResults(initialFetch: false, forQuery: searchText)
    } else {
      self.fetchTrending(initialFetch: false)
    }
  }
  
  func showCellError(errorMessage: String) {
    DispatchQueue.main.async {
      UIAlertController.showError(withMessage: errorMessage, onViewController: self)
    }
  }
}
