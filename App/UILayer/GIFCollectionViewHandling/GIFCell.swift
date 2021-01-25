//
//  GIFCell.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 24/01/21.
//

import UIKit
import GIFInterfaces
import SDWebImage

// MARK:- GIFCellDelegate
protocol GIFCellDelegate: class {
  func didSelectFavourite(forIndexPath indexPath: IndexPath, andImage image: UIImage, cell: GIFCell)
  func showCellError(errorString: String)
}

// MARK:- GIF Prototype Cell
class GIFCell: UICollectionViewCell {
  
  // MARK:- IB Outlets
  @IBOutlet weak var gifImageView: SDAnimatedImageView!
  @IBOutlet weak var favouriteButton: UIButton!

  // MARK:- IB Actions
  @IBAction func favouriteAction(_ sender: Any) {
    if let indexPath = self.indexPath, let image = self.gifImageView.image, image != UIImage.singleLoader {
      delegate?.didSelectFavourite(forIndexPath: indexPath, andImage: image, cell: self)
    } else {
      delegate?.showCellError(errorString: "Pelase wait while image is being loaded!")
    }
  }
  
  // MARK:- Instance variables
  private var indexPath: IndexPath?
  private weak var delegate: GIFCellDelegate?
  
  // MARK:- Default life cycle methods
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configureView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.configureViewForReuse()
  }
  
  func configureCell(withUrl url: URL,
                     gifService: GIFInterface,
                     delegate: GIFCellDelegate?,
                     indexPath: IndexPath) {
    self.delegate = delegate
    self.indexPath = indexPath
    gifService.setGif(onImageView: self.gifImageView, withUrl: url, placeholderImage: UIImage.singleLoader, completion: {
      self.favouriteButton.isEnabled = true
    })
  }
  
  func toggleFavourite(show: Bool) {
    self.favouriteButton.isSelected = show
  }
}

// MARK: private utility methods
extension GIFCell {
  
  private func configureView() {
    /// Set border radius for cell
    self.layer.cornerRadius = 7.0
    self.layer.masksToBounds = true
    self.gifImageView.image = UIImage.singleLoader
    self.favouriteButton.isEnabled = false
  }
  
  private func configureViewForReuse() {
    self.favouriteButton.isSelected = false
    self.gifImageView.image = UIImage.singleLoader
    self.favouriteButton.isEnabled = false
  }
}
