//
//  AppLocalization.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 17.10.2023.
//

import Foundation

class AppLocalization {
  static func language(key: String, _ arguments: CVarArg...) -> String {
    if arguments.count > 0 {
      let localizedStr = AppLocalization.language(key: key)
      if let arrayList = arguments.first as? [CVarArg] {
        return String(format: localizedStr, arguments: arrayList)
      }
      return localizedStr
    } else {
      return NSLocalizedString(key, comment: "")
    }
  }
}
