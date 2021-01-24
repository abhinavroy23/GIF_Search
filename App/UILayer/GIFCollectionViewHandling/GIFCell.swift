//
//  GIFCell.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 24/01/21.
//

import UIKit
import SDWebImage

class GIFCell: UICollectionViewCell {
  
  @IBOutlet weak var gifImageView: SDAnimatedImageView!
  @IBOutlet weak var favouriteButton: UIButton!
  @IBOutlet weak var favouriteAction: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configureView()
    self.gifImageView.image = UIImage.singleLoader
  }
  
  func configureView() {
    /// Set border radius for cell
    self.layer.cornerRadius = 7.0
    self.layer.masksToBounds = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.favouriteButton.isSelected = false
    self.gifImageView.image = UIImage.singleLoader
  }
}
