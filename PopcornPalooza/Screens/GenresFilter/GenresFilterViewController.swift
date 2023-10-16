//
//  GenresFilterViewController.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import UIKit

class GenresFilterViewController: UIViewController {
  // MARK: - Properties
  var viewModel: GenresFilterViewModel!
  weak var coordinator: AppCoordinator?
  
  // MARK: - @IBOutlet's
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var clearButton: UIButton!
  
  // MARK: - Life Cycle
  init(
    viewModel: GenresFilterViewModel,
    genres: [Genre]) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    self.viewModel.genres = genres
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "GenresTableViewCell", bundle: nil), forCellReuseIdentifier: "GenresTableViewCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadData()
    
    if viewModel.genres.isEmpty {
      self.showAlert(with: "error".localized)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    saveButton.layer.cornerRadius = 8
    clearButton.layer.cornerRadius = 8
    
    clearButton.setTitle("filter_clear_btn".localized, for: .normal)
    saveButton.setTitle("filter_save_btn".localized, for: .normal)
  }
  
  // MARK: - @IBAction's
  @IBAction func clearFiltersTapped(_ sender: UIButton) {
    viewModel.clearFilters()
    tableView.reloadData()
  }
  
  @IBAction func saveTapped(_ sender: UIButton) {
    self.dismiss(animated: true)
  }
}

// MARK: - UITableViewDelegate
extension GenresFilterViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.updateSelection(with: viewModel.genres[indexPath.row])
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = HeaderView()
      return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 30
  }
}

// MARK: - UITableViewDataSource
extension GenresFilterViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.genres.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as? GenresTableViewCell else {
      return UITableViewCell()
    }
    
    let selectedIds = LocalStorageManager.shared.getGenreFilters()
    let genre = viewModel.genres[indexPath.row]
    let isSelected = selectedIds.contains(genre.id)
    
    cell.configure(with: genre.name, selected: isSelected)
    return cell
  }
}
