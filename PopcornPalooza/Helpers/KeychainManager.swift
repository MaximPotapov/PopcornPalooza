//
//  KeychainManager.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import Foundation
import Security

final class KeychainManager {
  static let shared = KeychainManager()
  
  private init() {}
  
  // MARK: - Public Methods
  func storeAccessToken(token: String) -> Bool {
    return storePassword(password: token, account: "access_token")
  }
  
  func retrieveAccessToken() -> String? {
    return retrievePassword(account: "access_token")
  }
  
  func storeGuestSession(id: String) -> Bool {
    return storePassword(password: id, account: "session_id")
  }
  
  func retrieveSessionId() -> String? {
    return retrievePassword(account: "session_id")
  }
  
  // MARK: - Private Methods
  private func storePassword(password: String, account: String) -> Bool {
    if let data = password.data(using: .utf8) {
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account,
        kSecValueData as String: data
      ]
      
      SecItemDelete(query as CFDictionary)
      
      let status = SecItemAdd(query as CFDictionary, nil)
      return status == errSecSuccess
    }
    
    return false
  }
  
  private func retrievePassword(account: String) -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnData as String: true
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    if status == errSecSuccess, let passwordData = result as? Data {
      let password = String(data: passwordData, encoding: .utf8)
      return password
    }
    
    return nil
  }
}
