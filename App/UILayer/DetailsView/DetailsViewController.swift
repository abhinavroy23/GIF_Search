//
//  DetailsViewController.swift
//  GIF Search
//
//  Created by Roy, Abhinav on 25/01/21.
//

import UIKit
import GIFInterfaces
import SDWebImage

class DetailsViewController: UIViewController {
  
  /// Instantiate view controller with parameters
  /// - Parameter gifService: GIFService to display & Handle GIFs
  /// - Parameter gifUIModel: GIFUIModel that contains GIF Data
  /// - Returns: DetailsViewController instance
  class func instance(gifService: GIFInterface, gifUIModel: GIFUIResult) -> DetailsViewController {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    guard let vc = storyboard.instantiateViewController(identifier: String(describing: DetailsViewController.self)) as? DetailsViewController else { fatalError("view Controller cannot be nil!") }
    vc.gifService = gifService
    vc.gifUIModel = gifUIModel
    return vc
  }
  
  // MARK:- IB Outlets
  @IBOutlet weak var imageView: SDAnimatedImageView!
  @IBOutlet weak var clipboardLabel: UILabel!

  // MARK:- Instance variables
  /// Capabilitirs
  private var gifService: GIFInterface!
  private var gifUIModel: GIFUIResult!
  
  // MARK:- Default Life cycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    self.gifService.setGif(onImageView: self.imageView,
                           withUrl: gifUIModel.url,
                           placeholderImage: UIImage.singleLoader,
                           completion: {})
  }
}

// MARK:- IB Actions
extension DetailsViewController {
  
  /// Copy button action
  @IBAction func copyButton(_ sender: Any) {
    UIPasteboard.general.string = gifUIModel.url.absoluteString
    self.clipboardLabel.alpha = 1.0
    UIView.animate(withDuration: 1.5) {
      self.clipboardLabel.alpha = 0.0
    }
  }
  
  /// Whatsapp action
  @IBAction func whatsappButton(_ sender: Any) {
    if let url = URL(string: "whatsapp://send?text=\(gifUIModel.url.absoluteString)"), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      UIAlertController.showError(withMessage: "Please install whatsapp on your Device.", onViewController: self)
    }
  }
  
  /// Share Button action
  @IBAction func shareButton(_ sender: Any) {
    let textToShare = [gifUIModel.url.absoluteString]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = sender as? UIButton
    self.present(activityViewController, animated: true, completion: nil)
  }
  
  /// Back action
  @IBAction func backAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}
