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
    case unknown
  }
  
  // MARK: - Properties
  weak var coordinator: AppCoordinator?
  private let refreshControl = UIRefreshControl()
  private var networkStatus: NetworkStatus = .unknown
  private var viewModel: FeedViewModel!
  
  // MARK: - @IBOutlet's
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var categoriesSegmentedControl: UISegmentedControl!
  @IBOutlet weak var scrollButton: UIButton!
  
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
    showActivityIndicator()
    if NetworkMonitor.shared.isReachable() {
      self.networkStatus = .connected
      self.fetchData()
    } else {
      self.networkStatus = .noInternet
      self.tableView.separatorStyle = .none
      self.hideActivityIndicator()
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
    scrollButton.layer.cornerRadius = 25
    
    searchBar.placeholder = "feed_search_bar_placeholder".localized
    categoriesSegmentedControl.setTitle("feed_segmented_popular".localized, forSegmentAt: 0)
    categoriesSegmentedControl.setTitle("feed_segmented_top".localized, forSegmentAt: 1)
    categoriesSegmentedControl.setTitle("feed_segmented_now".localized, forSegmentAt: 2)
    categoriesSegmentedControl.setTitle("feed_segmented_upcoming".localized, forSegmentAt: 3)
  }
  
  // MARK: - @IBAction's
  @IBAction func filterButtonTapped(_ sender: Any) {
    scrollToTop()
  }
  
  @IBAction func changeCategory(_ sender: UISegmentedControl) {
    guard let dataSource = viewModel.dataSource(for: sender.selectedSegmentIndex) else { return }
    viewModel.updateDataSource(with: dataSource) { [weak self] in
      guard let self else { return }
      self.scrollToTop()
      self.scrollButton.isHidden = true
      self.tableView.reloadSections(IndexSet(integersIn: 0...(self.tableView.numberOfSections) - 1), with: sender.selectedSegmentIndex == 0 ? .left : .right)
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
      name: "filter"
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
    switch networkStatus {
      case .connected:
        coordinator?.presentFilters(genres: viewModel.movieGenres)
      case .noInternet:
        self.showAlert(with: "error".localized)
      case .unknown:
        self.showAlert(with: "error".localized)
    }
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
      networkStatus = .connected
      fetchData()
    } else {
      networkStatus = .noInternet
      tableView.separatorStyle = .none
    }
    
    tableView.reloadData()
    refreshControl.endRefreshing()
  }
  
  func fetchData() {
    viewModel.fetchMovieGenres()
    
    viewModel.fetchPopularMovies(
      paging: false,
      completion: { [weak self] result in
      guard let self else { return }
      if result {
        self.viewModel.updateDataSource(
          with: .popular,
          completion: { self.tableView.reloadData()
          })
      } else {
        self.showAlert(with: "error".localized)
      }
        self.hideActivityIndicator()
    })
  
    viewModel.fetchTopRatedMovies(
      paging: false,
      completion: { _ in })

    viewModel.fetchUpcomingMovies(
      paging: false,
      completion: { _ in })
    
    viewModel.fetchNowPlayingMovies(
      paging: false,
      completion: { _ in })
  }
  
  func createSpinnerFooter() -> UIView {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
    let spinner = UIActivityIndicatorView()
    spinner.center = footerView.center
    footerView.addSubview(spinner)
    spinner.startAnimating()
    
    return footerView
  }
  
  func scrollToTop() {
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch networkStatus {
      case .connected: return viewModel.currentDataSource.isEmpty ? 300 : 550
      case .noInternet: return 300
      case .unknown: return 0
    }
  }
}

// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let filters = LocalStorageManager.shared.getGenreFilters()
    switch networkStatus {
      case .noInternet: return 1
      case .connected:
        let movies: [Movie] = filters.isEmpty ? viewModel.currentDataSource : viewModel.returnFilteredByGenresDataSource()
        return max(movies.isEmpty ? 1 : movies.count, 1)
      case .unknown: return 0
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
          scrollButton.isHidden = true
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
      case .unknown:
        return UITableViewCell()
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
          coordinator?.navigateToDetails(movieId: movies[indexPath.row].id)
        }
      case .unknown:
        break
    }
  }
}

extension FeedViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let possition = scrollView.contentOffset.y
    if possition > (tableView.contentSize.height - 100 - scrollView.frame.size.height)  {
      guard !viewModel.isPaginating else { return }
      if !viewModel.currentDataSource.isEmpty {
        self.tableView.tableFooterView = self.createSpinnerFooter()
      }
      
      if viewModel.currentDataSource.count > 0 {
        self.scrollButton.isHidden = false
      }
      
      switch viewModel.dataSource {
        case .popular:
          viewModel.fetchPopularMovies(paging: true) { [weak self] result in
            guard let self else { return }
            self.tableView.tableFooterView = nil
            if result {
              self.viewModel.updateDataSource(
                with: .popular,
                completion: { self.tableView.reloadData()
                })
            }
          }
        case .topRated:
          viewModel.fetchTopRatedMovies(paging: true) { [weak self] result in
            guard let self else { return }
            self.tableView.tableFooterView = nil
            if result {
              self.viewModel.updateDataSource(
                with: .topRated,
                completion: { self.tableView.reloadData()
                })
            }
          }
        case .nowPlaying:
          viewModel.fetchNowPlayingMovies(paging: true) { [weak self] result in
            guard let self else { return }
            self.tableView.tableFooterView = nil
            if result {
              self.viewModel.updateDataSource(
                with: .nowPlaying,
                completion: { self.tableView.reloadData()
                })
            }
          }
        case .upcoming:
          viewModel.fetchUpcomingMovies(paging: true) { [weak self] result in
            guard let self else { return }
            self.tableView.tableFooterView = nil
            if result {
              self.viewModel.updateDataSource(
                with: .upcoming,
                completion: { self.tableView.reloadData()
                })
            }
          }
        case .searched:
          break
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

// MARK: - ActivityIndicatorViewDelegate
extension FeedViewController: ActivityIndicatorViewDelegate {
  func showActivityIndicator() {
    let activityIndicatorView = ActivityIndicatorView(frame: view.bounds)
    activityIndicatorView.startAnimating()
    tableView.alpha = 0
    view.addSubview(activityIndicatorView)
  }
  
  func hideActivityIndicator() {
    view.subviews
      .compactMap { $0 as? ActivityIndicatorView }
      .forEach { $0.stopAnimating() {
        UIView.transition(with: self.tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
          self.tableView.reloadData()
          self.tableView.alpha = 1
        })
      } }
  }
}
