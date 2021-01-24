//
//  ViewController.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 21/01/21.
//

import UIKit
import GIFInterfaces
import NetworkInterfaces
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
  
  // MARK:- Instance Variables
  
  /// Capabilities
  private var gifCachingService: GIFCachingInterface!
  private var gifService: GIFInterface!
  private var networkService: NetworkInterface!
  private var gifApiService: GIFAPIInterface!
  private var collectionHandler: GIFCollectionViewHandler!
  
  /// ViewModel
  private var viewModel: HomeViewModel!
  private var isSearchActive: Bool = false {
    didSet {
      viewModel.isSearchActive = self.isSearchActive
    }
  }
  
  // MARK:- Default lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureCapabilities()
    self.setupNavigation()
    self.fetchTrending(initialFetch: true)
  }

  /// Configure `capabilities & viewModel` for `HomeViewController`.
  /// This  must be called before anything else in HomeViewController
  private func configureCapabilities() {
    self.gifCachingService = GIFCachingService()
    self.gifService = GIFService(cachingService: self.gifCachingService)
    self.networkService = GIFNetworkService()
    self.gifApiService = GIFAPIService(networkService: self.networkService)
    self.viewModel = HomeViewModel(apiService: self.gifApiService)
    self.collectionHandler = GIFCollectionViewHandler(collectionView: self.collectionView,
                                                      gifService: self.gifService,
                                                      viewModel: self.viewModel,
                                                      delegate: self)
  }
}

// MARK:- View Model interaction
extension HomeViewController {
  
  func fetchTrending(initialFetch: Bool) {
    DispatchQueue.main.async {
      initialFetch ? self.showLoadingView(true) : self.showInfinityLoadingView(true)
    }
    viewModel.fetchTrending(initialFetch: initialFetch) { (success, error) in
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
  
  func fetchSearchResults(initialFetch: Bool, forQuery query: String) {
    DispatchQueue.main.async {
      initialFetch ? self.showLoadingView(true) : self.showInfinityLoadingView(true)
    }
    viewModel.fetchSearchResults(initialFetch: initialFetch, forQuery: query) { (success, error) in
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
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.searchBar.text = nil
    self.searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // TODO:- hit api for search
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // TODO:- Implement the logic to search after 1 second of pause
  }
  
}

extension HomeViewController: GIFCollectionViewHandlerDelegate {
  func fetchNextBatch() {
    if viewModel.isSearchActive, let searchText = self.searchBar.text {
      self.fetchSearchResults(initialFetch: false, forQuery: searchText)
    } else {
      self.fetchTrending(initialFetch: false)
    }
  }
}
