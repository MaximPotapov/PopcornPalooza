//
//  GenresFilterViewModel.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import Foundation

class GenresFilterViewModel {
  // MARK: - Properties
  var genres: [Genre] = []
  var selectedGenres: [Genre] = []
  
  // MARK: - Public Metohds
  func updateSelection(with genre: Genre) {
    if let index = selectedGenres.firstIndex(where: { $0.id == genre.id }) {
      selectedGenres.remove(at: index)
    } else {
      selectedGenres.append(genre)
    }
    
    let genreIDs = selectedGenres.map { $0.id }
    LocalStorageManager.shared.saveGenreFilters(values: genreIDs)
    NotificationCenter.default.post(name: .updateGenreFiltersEvent, object: nil)
  }
  
  func clearFilters() {
    self.selectedGenres.removeAll()
    LocalStorageManager.shared.saveGenreFilters(values: [])
    NotificationCenter.default.post(name: .updateGenreFiltersEvent, object: nil)
  }
}
