//
//  UIViewcontrollerExt.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import UIKit

extension UIViewController {
  func showAlert(with message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    // Add any additional actions if needed
    
    present(alertController, animated: true, completion: nil)
  }
  
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
