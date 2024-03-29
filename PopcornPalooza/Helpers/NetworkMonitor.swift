//
//  NetworkMonitor.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import Foundation
import Reachability

final class NetworkMonitor {
  // MARK: - Properties
  static let shared = NetworkMonitor()
  
  private let reachability = try? Reachability()
  
  // MARK: - Public Methods
  func startMonitoring() {
    do {
      try reachability?.startNotifier()
    } catch {
      print("Unable to start reachability notifier")
    }
  }
  
  func stopMonitoring() {
    reachability?.stopNotifier()
  }
  
  func isReachable() -> Bool {
    return reachability?.connection != .unavailable
  }
}
