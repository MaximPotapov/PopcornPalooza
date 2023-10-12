//
//  FeedViewController.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import UIKit

class FeedViewController: UIViewController {
  enum Status {
    case connected
    case noInternet
  }
  
  // MARK: - Properties
  weak var coordinator: AppCoordinator?
  private let refreshControl = UIRefreshControl()
  private let movies: [String] = ["1", "2", "3"]
  private var status: Status = .noInternet
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var filterButton: UIButton!
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    AFNetworkManager.shared.getGuestSession(completion: { result in })
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    tableView.register(UINib(nibName: "NoInternetTableViewCell", bundle: nil), forCellReuseIdentifier: "NoInternetTableViewCell")
    
    tableView.addSubview(refreshControl)
    
    // Set the action for the refresh control
    refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    filterButton.layer.cornerRadius = 20
    if NetworkMonitor.shared.isReachable() {
      self.status = .connected
    } else {
      self.status = .noInternet
    }
    
    updateFilertButtonUI()
  }
  
  @IBAction func filterButtonTapped(_ sender: Any) {
    
  }
}

private extension FeedViewController {
  func configureNavigationBar() {
    self.title = "Porcorn Palooza 🍿"
    
    navigationItem.rightBarButtonItem = FilterButton(
      target: self,
      action: #selector(leftButtonItemAction),
      size: CGSize(width: 24, height: 24),
      name: "filter"
    )
  }
  
  @objc func rightButtonItemAction() {
    
  }
  
  @objc func leftButtonItemAction() {

  }
  
  @objc func refreshData() {
    // Check if the user has enabled internet connectivity
    if NetworkMonitor.shared.isReachable() {
      print("Ok")
      // The user has internet connectivity, proceed with data refresh.
      // Place the code here to refresh your data.
      // - Fetch new data from your data source.
      // - Reload your table view.
      // - End the refreshing animation.
      
      // For example, you can reload your table view's data and then end the refreshing:

    } else {
      // The user does not have internet connectivity.
      // You can show an alert or a message to inform the user.
      tableView.separatorStyle = .none
    }
    
    tableView.reloadData()
    refreshControl.endRefreshing() // Stop the refreshing animation.
    updateFilertButtonUI()
  }
  
  func updateFilertButtonUI() {
    switch status {
      case .noInternet: filterButton.setImage(UIImage(named: "sad"), for: .normal)
      case .connected: filterButton.setImage(UIImage(named: "filter"), for: .normal)
    }
  }
}

extension FeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return NetworkMonitor.shared.isReachable() ?  UITableView.automaticDimension : 200
  }
}

extension FeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch status {
      case .noInternet: return 1
      case .connected: return movies.count
    }
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch status {
      case .noInternet:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoInternetTableViewCell", for: indexPath) as? NoInternetTableViewCell else {
          return UITableViewCell()
        }
        return cell
      case .connected:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
          return UITableViewCell()
        }
        return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch status {
      case .noInternet:
        break
      case .connected:
        coordinator?.navigateToDetails(title: movies[indexPath.row])
    }
  }
}
