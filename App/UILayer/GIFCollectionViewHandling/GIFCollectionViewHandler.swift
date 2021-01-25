//
//  GIFCollectionViewHandler.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 24/01/21.
//

import UIKit
import GIFInterfaces

protocol GIFCollectionViewHandlerDelegate: class {
  func fetchNextBatch()
  func showCellError(errorMessage: String)
}

class GIFCollectionViewHandler: NSObject {
  var collectionView: UICollectionView
  var gifService: GIFInterface
  var favouriteService: GIFFavouritesInterface
  var viewModel: GIFCollectionVMProtocol
  weak var delegate: GIFCollectionViewHandlerDelegate?
  
  init(collectionView: UICollectionView, gifService: GIFInterface, favouriteService: GIFFavouritesInterface, viewModel: GIFCollectionVMProtocol, delegate: GIFCollectionViewHandlerDelegate) {
    self.collectionView = collectionView
    self.gifService = gifService
    self.favouriteService = favouriteService
    self.viewModel = viewModel
    self.delegate = delegate
    super.init()
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
  
  func reloadCollectionView() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
}

// MARK:- Collection View Delegate
extension GIFCollectionViewHandler: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.getDataSource().gifs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GIFCell.self), for: indexPath) as? GIFCell else { return UICollectionViewCell() }
    let gifUrl = viewModel.getDataSource().gifs[indexPath.row].url
    cell.configureCell(withUrl: gifUrl,
                       gifService: self.gifService,
                       delegate: self,
                       indexPath: indexPath)
    cell.toggleFavourite(show: favouriteService.existsInFavourites(url: gifUrl))
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // Size of the item - For iPad display 3 columns, for iPhone display 2 columns
    if UIDevice.current.userInterfaceIdiom == .pad {
      let requiredWidth = UIScreen.main.bounds.size.width/3 - 13.6
      return CGSize.init(width: requiredWidth, height: requiredWidth)
    } else {
      let requiredWidth = UIScreen.main.bounds.size.width/2 - 15
      return CGSize.init(width: requiredWidth, height: requiredWidth)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    /// Inset between item
    return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    /// Hit api for next batch when user reaches is about to reach the last cell
    let totalCount = viewModel.getDataSource().gifs.count
    if indexPath.row == totalCount - 1 {
      delegate?.fetchNextBatch()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
}

// MARK:- Conformance to GIFCellDelegate
extension GIFCollectionViewHandler: GIFCellDelegate {
  
  func didSelectFavourite(forIndexPath indexPath: IndexPath, andImage image: UIImage, cell: GIFCell) {
    let gifUrl = viewModel.getDataSource().gifs[indexPath.row].url
    if favouriteService.existsInFavourites(url: gifUrl) {
      /// Image already exists in favourite - remote from favourite
      favouriteService.removeFromFavourite(url: gifUrl)
      DispatchQueue.main.async {
        cell.toggleFavourite(show: false)
      }
    } else {
      /// Add image to favourites
      favouriteService.addToFavourite(image: image, url: gifUrl)
      DispatchQueue.main.async {
        cell.toggleFavourite(show: true)
      }
    }
  }
  
  func showCellError(errorString: String) {
    delegate?.showCellError(errorMessage: errorString)
  }
}
