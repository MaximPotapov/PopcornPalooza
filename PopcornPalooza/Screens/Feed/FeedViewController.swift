//
//  FeedViewController.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import UIKit

class FeedViewController: UIViewController {
  enum NetworkStatus {
    case connected
    case noInternet
  }
  
  // MARK: - Properties
  weak var coordinator: AppCoordinator?
  private let refreshControl = UIRefreshControl()
  private var networkStatus: NetworkStatus = .noInternet
  var viewModel: FeedViewModel!
  
  // MARK: - @IBOutlet's
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var filterButton: UIButton!
  @IBOutlet weak var categoriesSegmentedControl: UISegmentedControl!
  
  // MARK: - Life Cycle
  init(viewModel: FeedViewModel) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    
    if NetworkMonitor.shared.isReachable() {
      self.networkStatus = .connected
      self.fetchData()
    } else {
      self.networkStatus = .noInternet
    }
    
    configureNavigationBar()
    configureTableView()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateGenreFiltersEvent),
      name: .updateGenreFiltersEvent,
      object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    filterButton.layer.cornerRadius = 20
    updateFilertButtonUI()
  }
  
  // MARK: - @IBAction's
  @IBAction func filterButtonTapped(_ sender: Any) {
    
  }
  
  @IBAction func changeCategory(_ sender: UISegmentedControl) {
    guard let dataSource = viewModel.dataSource(for: sender.selectedSegmentIndex) else { return }
    viewModel.updateDataSource(with: dataSource) { [weak self] in
      self?.tableView.reloadData()
    }
  }
}

// MARK: - Private Methods
private extension FeedViewController {
  func configureNavigationBar() {
    self.title = "Porcorn Palooza 🍿"
    updateFilterButton()
  }
  
  func updateFilterButton() {
    let filters = LocalStorageManager.shared.getGenreFilters()
    navigationItem.rightBarButtonItem = FilterButton(
      target: self,
      action: #selector(rightButtonItemAction),
      size: CGSize(width: 24, height: 24),
      name: filters.isEmpty ? "filter" : "filterOn"
    )
  }
  
  func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(
      UINib(
      nibName: "MovieTableViewCell",
      bundle: nil),
      forCellReuseIdentifier: "MovieTableViewCell")
    tableView.register(
      UINib(
        nibName: "NoInternetTableViewCell",
        bundle: nil),
      forCellReuseIdentifier: "NoInternetTableViewCell")
    
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    searchBar.delegate = self
  }
  
  @objc func rightButtonItemAction() {
    coordinator?.presentFilters(genres: viewModel.movieGenres)
  }
  
  @objc private func updateGenreFiltersEvent() {
    let filters = LocalStorageManager.shared.getGenreFilters()
    
    if !filters.isEmpty {
      viewModel.searchFilteredMovies = viewModel.currentDataSource.filter { movie in
        let commonIds = Set(movie.genreIds).intersection(filters)
        return !commonIds.isEmpty
      }
      
      viewModel.updateDataSource(
        with: .searched,
        completion: { self.tableView.reloadData() })
    } else {
      viewModel.revertToOriginalDataSource(completion: { self.tableView.reloadData() })
    }
    
    updateFilterButton()
  }
  
  @objc func refreshData() {
    // Check if the user has enabled internet connectivity
    if NetworkMonitor.shared.isReachable() {
      print("Ok")
    } else {
      tableView.separatorStyle = .none
    }
    
    tableView.reloadData()
    refreshControl.endRefreshing()
    updateFilertButtonUI()
  }
  
  func updateFilertButtonUI() {
    switch networkStatus {
      case .noInternet: filterButton.setImage(UIImage(named: "sad"), for: .normal)
      case .connected: filterButton.setImage(UIImage(named: "filter"), for: .normal)
    }
  }
  
  func fetchData() {
    viewModel.fetchPopularMovies(
      page: viewModel.currentPage,
      pageSize: 20,
      completion: { [weak self] result in
      guard let self else { return }
      if result {
        self.viewModel.updateDataSource(
          with: .popular,
          completion: { self.tableView.reloadData()
          })
      } else {
        self.showAlert(with: "Oops")
      }
    })
    
    viewModel.fetchMovieGenres()
    viewModel.fetchTopRatedMovies(
      page: viewModel.currentPage,
      pageSize: 20,
      completion: { _ in })
    viewModel.fetchUpcomingMovies(
      page: viewModel.currentPage,
      pageSize: 20,
      completion: { _ in })
    viewModel.fetchNowPlayingMovies(
      page: viewModel.currentPage,
      pageSize: 20,
      completion: { _ in })
  }
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return NetworkMonitor.shared.isReachable() ?  UITableView.automaticDimension : 200
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.currentDataSource.count - 1, viewModel.currentPage < viewModel.totalPages {
      switch viewModel.dataSource {
        case .popular:
          viewModel.fetchPopularMovies(
            page: viewModel.currentPage,
            pageSize: 20) {_ in }
        case .topRated:
          viewModel.fetchTopRatedMovies(
            page: viewModel.currentPage,
            pageSize: 20) {_ in }
        case .nowPlaying:
          viewModel.fetchNowPlayingMovies(
            page: viewModel.currentPage,
            pageSize: 20) {_ in }
        case .upcoming:
          viewModel.fetchUpcomingMovies(
            page: viewModel.currentPage,
            pageSize: 20) {_ in }
        case .searched:
          break
      }
      
      self.tableView.reloadData()
    }
  }
}

// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let filters = LocalStorageManager.shared.getGenreFilters()
    switch networkStatus {
      case .noInternet:
        return 1
      case .connected:
        let movies: [Movie] = filters.isEmpty ? viewModel.currentDataSource : viewModel.returnFilteredByGenresDataSource()
        return max(movies.isEmpty ? 1 : movies.count, 1)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let filters = LocalStorageManager.shared.getGenreFilters()
    switch networkStatus {
      case .noInternet:
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoInternetTableViewCell", for: indexPath) as? NoInternetTableViewCell ?? NoInternetTableViewCell()
        cell.configure(with: .network)
        return cell
        
      case .connected:
        var movies: [Movie]
        
        if filters.isEmpty {
          movies = viewModel.currentDataSource
        } else {
          movies = viewModel.returnFilteredByGenresDataSource()
        }
        
        if movies.isEmpty {
          let cell = tableView.dequeueReusableCell(withIdentifier: "NoInternetTableViewCell", for: indexPath) as? NoInternetTableViewCell ?? NoInternetTableViewCell()
          cell.configure(with: .data)
          return cell
        } else {
          let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell ?? MovieTableViewCell()
          let genreNames = viewModel.movieGenres.filter { genre in
            movies[indexPath.row].genreIds.contains(genre.id)
          }.map { $0.name }
          
          cell.configure(with: movies[indexPath.row], genres: genreNames)
          return cell
        }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let filters = LocalStorageManager.shared.getGenreFilters()
    switch networkStatus {
      case .noInternet:
        break
      case .connected:
        let movies: [Movie]
        if filters.isEmpty {
          movies = viewModel.currentDataSource
        } else {
          movies = viewModel.returnFilteredByGenresDataSource()
        }
        
        if !movies.isEmpty {
          coordinator?.navigateToDetails(title: movies[indexPath.row].title)
        }
    }
  }
}

// MARK: - UISearchBarDelegate
extension FeedViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    viewModel.saveOriginalDataSource()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      viewModel.revertToOriginalDataSource(completion: { self.tableView.reloadData() })
    } else {
      viewModel.searchFilteredMovies = viewModel.currentDataSource.filter { movie in
        return movie.title.localizedCaseInsensitiveContains(searchText)
      }
      
      viewModel.updateDataSource(
        with: .searched,
        completion: { self.tableView.reloadData() })
    }
  }
}
