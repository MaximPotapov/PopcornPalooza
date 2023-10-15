//
//  MoviewDetailsViewController.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import UIKit
import YouTubePlayerKit

class MoviewDetailsViewController: UIViewController {
  // MARK: - Properties
  enum NetworkStatus {
    case connected
    case noInternet
    case unknown
  }
  
  private var networkStatus: NetworkStatus = .unknown
  private var viewModel: MovieDetailsViewModel!
  
  enum Sections: String, CaseIterable {
    case poster = "PosterTableViewCell"
    case details = "DetailsTableViewCell"
    case ratings = "RatingsTableViewCell"
    case description = "DescriptionTableViewCell"
  }
  
  weak var coordinator: AppCoordinator?
  var movieId: Int
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Life Cycle
  init(movieId: Int, viewModel: MovieDetailsViewModel) {
    self.movieId = movieId
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    
    showActivityIndicator()
    if NetworkMonitor.shared.isReachable() {
      self.networkStatus = .connected
      fetchMoviewDetails()
    } else {
      self.networkStatus = .noInternet
      self.tableView.separatorStyle = .none
      self.hideActivityIndicator()
    }
  }
}

// MARK: - Private Methods
private extension MoviewDetailsViewController {
  func configureNavigationBar() {
    self.title = viewModel.movie.title
  }
  
  func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    Sections.allCases.forEach {
      tableView.register(
        UINib(
          nibName: $0.rawValue,
          bundle: nil),
        forCellReuseIdentifier: $0.rawValue)
    }
    
    tableView.register(
      UINib(
        nibName: "NoInternetTableViewCell",
        bundle: nil),
      forCellReuseIdentifier: "NoInternetTableViewCell")
  }
  
  func fetchMoviewDetails() {
    viewModel.fetchMovieDetails(movieId: self.movieId) { [weak self] result in
      guard let self else { return }
      if result {
        self.tableView.reloadData()
      } else {
        self.showAlert(with: "Oops, error")
      }
      
      self.hideActivityIndicator()
    }
  }
}

// MARK: - UITableViewDelegate
extension MoviewDetailsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = Sections.allCases[indexPath.section]
    if section == .poster {
      return 300
    } else {
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = Sections.allCases[indexPath.section]
    if section == .poster {
      coordinator?.presentPoster(movie: viewModel.movie)
    }
  }
}

// MARK: - UITableViewDataSource
extension MoviewDetailsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    switch networkStatus {
      case .connected: return Sections.allCases.count
      case .noInternet: return 1
      case .unknown: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch networkStatus {
      case .connected:
        let section = Sections.allCases[indexPath.section]
        switch section {
          case .poster:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Sections.poster.rawValue, for: indexPath) as? PosterTableViewCell else {
              return UITableViewCell()
            }
            cell.configure(with: viewModel.movie)
            return cell
          case .details:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Sections.details.rawValue, for: indexPath) as? DetailsTableViewCell else {
              return UITableViewCell()
            }
            cell.configure(with: viewModel.movie)
            return cell
          case .ratings:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Sections.ratings.rawValue, for: indexPath) as? RatingsTableViewCell else {
              return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: viewModel.movie)
            return cell
          case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Sections.description.rawValue, for: indexPath) as? DescriptionTableViewCell else {
              return UITableViewCell()
            }
            cell.configure(with: viewModel.movie)
            return cell
        }
      case .noInternet:
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoInternetTableViewCell", for: indexPath) as? NoInternetTableViewCell ?? NoInternetTableViewCell()
        cell.configure(with: .network)
        return cell
      case .unknown:
        return UITableViewCell()
    }
  }
}

// MARK: - RatingsTableViewCellDelegate
extension MoviewDetailsViewController: RatingsTableViewCellDelegate {
  func openPlayer(with urlString: String?) {
    viewModel.fetchYouTubeVideoKey { [weak self] key in
      guard let self else { return }
      if let videoKey = key {
        let player = YouTubePlayer(stringLiteral: "https://youtube.com/watch?v=" + videoKey)
        let youTubePlayerViewController = YouTubePlayerViewController(
          player: player
        )
        self.present(youTubePlayerViewController, animated: true)
      }
    }
  }
}

// MARK: - ActivityIndicatorViewDelegate
extension MoviewDetailsViewController: ActivityIndicatorViewDelegate {
  func showActivityIndicator() {
    let activityIndicatorView = ActivityIndicatorView(frame: view.bounds)
    activityIndicatorView.startAnimating()
    view.addSubview(activityIndicatorView)
  }
  
  func hideActivityIndicator() {
    view.subviews
      .compactMap { $0 as? ActivityIndicatorView }
      .forEach { $0.stopAnimating() {
        UIView.transition(with: self.tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
      } }
  }
}
