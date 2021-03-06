//
//  UIAlertController+App.swift
//  Pods
//
//  Created by Roy, Abhinav on 24/01/21.
//

import Foundation

public extension UIAlertController{
  
  class func showError(withMessage message:String, onViewController vc:UIViewController){
    let alertController = self.init(title: "Error", message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
    alertController.addAction(alertAction)
    vc.present(alertController, animated: true, completion: nil)
  }
  
  class func showMessage(withTitle title: String, andMessage message:String, onViewController vc:UIViewController, okTappedCallback : @escaping ()-> ()){
    let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction.init(title: "Ok", style: .default) { (alertAction) in
      okTappedCallback()
    }
    alertController.addAction(alertAction)
    vc.present(alertController, animated: true, completion: nil)
  }
  
  class func showMessageWithOptions(withTitle title: String, andMessage message:String, onViewController vc:UIViewController, noTappedCallback : @escaping ()-> (), yesTappedCallback : @escaping ()-> ()){
    let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    let alertActionNo = UIAlertAction.init(title: "No", style: .default) { (alertAction) in
      noTappedCallback()
    }
    let alertActionYes = UIAlertAction.init(title: "Yes", style: .default) { (alertAction) in
      yesTappedCallback()
    }
    alertController.addAction(alertActionNo)
    alertController.addAction(alertActionYes)
    vc.present(alertController, animated: true, completion: nil)
  }
  
}
