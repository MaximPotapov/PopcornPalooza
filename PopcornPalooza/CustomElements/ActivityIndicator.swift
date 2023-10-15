//
//  ActivityIndicator.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import UIKit

protocol ActivityIndicatorViewDelegate: AnyObject {
  func showActivityIndicator()
  func hideActivityIndicator()
}

class ActivityIndicatorView: UIView {
  private var activityIndicator: UIActivityIndicatorView?
  
  private lazy var blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .prominent)
    let view = UIVisualEffectView(effect: blurEffect)
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.layer.cornerRadius = 16
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    blurView.layer.cornerRadius = 16
    blurView.alpha = 0
    addSubview(blurView)
    
    activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator?.center = center
    activityIndicator?.startAnimating()
    
    addSubview(activityIndicator!)
  }
  

  func startAnimating() {
    isHidden = false
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.activityIndicator?.alpha = 1 // Fade in the activity indicator
    }
  }
  
  func stopAnimating(completion: @escaping () -> Void) {
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.activityIndicator?.alpha = 0 // Fade out the activity indicator
    }) { [weak self] _ in
      self?.isHidden = true // Hide the view after the animation
      self?.activityIndicator?.stopAnimating()
      completion()
    }
  }
}
