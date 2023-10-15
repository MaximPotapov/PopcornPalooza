//
//  Session.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import Foundation

struct Session: Codable {
  let success: Bool
  let guest_session_id: String
  let expires_at: String
}
