//
//  StringExt.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 16.10.2023.
//

import Foundation

extension String {
  func extractYearFromDateString() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: self) {
      let calendar = Calendar.current
      let year = calendar.component(.year, from: date)
      return String(year)
    }
    return nil
  }
  
  var localized: String {
    return AppLocalization.language(key: self)
  }
}
