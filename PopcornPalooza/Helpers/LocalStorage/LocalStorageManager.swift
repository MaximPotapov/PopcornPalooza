//
//  LocalStorageManager.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 14.10.2023.
//

import Foundation

final class LocalStorageManager {
  static let shared = LocalStorageManager()
  
  func saveGenreFilters(values: [Int]) {
    UserDefaults.standard.set(values, forKey: LocalStorageKeys.genreFilters)
  }
  
  func getGenreFilters() -> [Int] {
    if let values = UserDefaults.standard.array(forKey: LocalStorageKeys.genreFilters) as? [Int] {
      return values
    }
    
    return []
  }
}

