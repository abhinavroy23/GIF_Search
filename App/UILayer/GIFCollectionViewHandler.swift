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
}

class GIFCollectionViewHandler: NSObject {
  var collectionView: UICollectionView
  var gifService: GIFInterface
  var viewModel: GIFCollectionVMProtocol
  weak var delegate: GIFCollectionViewHandlerDelegate?
  
  init(collectionView: UICollectionView, gifService: GIFInterface, viewModel: GIFCollectionVMProtocol, delegate: GIFCollectionViewHandlerDelegate) {
    self.collectionView = collectionView
    self.gifService = gifService
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
    let gif = viewModel.getDataSource().gifs[indexPath.row]
    gifService.setGif(onImageView: cell.gifImageView, withUrl: gif.url, placeholderImage: UIImage.singleLoader)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let requiredWidth = UIScreen.main.bounds.size.width/2 - 15
    return CGSize.init(width: requiredWidth, height: requiredWidth)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let totalCount = viewModel.getDataSource().gifs.count
    if indexPath.row == totalCount - 1 {
      delegate?.fetchNextBatch()
    }
  }
}
