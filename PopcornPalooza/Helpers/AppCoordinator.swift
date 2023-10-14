//
//  AppCoordinator.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import Foundation
import UIKit

final class AppCoordinator {
  // MARK: - Properties
  private var window: UIWindow
  private var navigationController: UINavigationController
  
  // MARK: - Life Cycle
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
  
  // MARK: Public Methods
  func navigateToDetails(title: String) {
    let viewController = MoviewDetailsViewController(title: title)
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func presentFilters(genres: [Genre]) {
    let viewModel = GenresFilterViewModel()
    let viewController = GenresFilterViewController(viewModel: viewModel, genres: genres)
    viewController.coordinator = self
    navigationController.modalPresentationStyle = .pageSheet
    if let sheet = viewController.sheetPresentationController {
      sheet.detents = [.large()]
      sheet.prefersScrollingExpandsWhenScrolledToEdge = false
      sheet.prefersGrabberVisible = true
    }
    
    navigationController.present(viewController, animated: true)
  }
}
