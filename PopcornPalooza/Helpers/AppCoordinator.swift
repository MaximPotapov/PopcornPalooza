//
//  AppCoordinator.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import Foundation
import UIKit

class AppCoordinator {
  private var window: UIWindow
  private var navigationController: UINavigationController
  
  init(window: UIWindow) {
    self.window = window
    let viewModel = FeedViewModel()
    let viewController = FeedViewController(viewModel: viewModel)
    self.navigationController = UINavigationController(rootViewController: viewController)
    viewController.coordinator = self
  }
  
  func start() {
    window.rootViewController = navigationController // MARK: - Life Cycle
    window.makeKeyAndVisible()
  }
  
  func navigateToDetails(title: String) {
    let viewController = MoviewDetailsViewController(title: title)
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
}
