//
//  GenresFilterViewController.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import UIKit

class GenresFilterViewController: UIViewController {
  
  var viewModel: GenresFilterViewModel!
  weak var coordinator: AppCoordinator?
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Life Cycle
  init(viewModel: GenresFilterViewModel, genres: [Genre]) {
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
  }
  
  @IBAction func clearFiltersTapped(_ sender: UIButton) {
    viewModel.clearFilters()
  }
  
  @IBAction func saveTapped(_ sender: UIButton) {
    self.dismiss(animated: true)
  }
}

extension GenresFilterViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.updateSelection(with: viewModel.genres[indexPath.row])
  }
}

extension GenresFilterViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.genres.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as? GenresTableViewCell else {
      return UITableViewCell()
    }
    
    cell.configure(with: viewModel.genres[indexPath.row].name)
    return cell
  }
}
