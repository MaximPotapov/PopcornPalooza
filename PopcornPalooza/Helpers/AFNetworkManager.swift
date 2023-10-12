//
//  AFNetworkManager.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import Foundation
import Alamofire

class AFNetworkManager {
  static let shared = AFNetworkManager()
  
  private let baseUrl = ""
  private let decoder = JSONDecoder()
  private var acessToken = ""
}

extension AFNetworkManager {
  func getGuestSession(completion: @escaping (Result<Session, Error>) -> Void) {
    guard let authToken = KeychainManager.shared.retrieveAccessToken() else {
//      completion(.failure())
      return
    }
    
    let url = "https://api.themoviedb.org/3/authentication/guest_session/new"
    
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization("Bearer \(authToken)")
    ]
    
    AF.request(url, method: .get, headers: headers)
      .validate()
      .responseDecodable(of: Session.self) { response in
        switch response.result {
          case .success(let data):
            log.debug(data.guest_session_id)
            KeychainManager.shared.storeGuestSession(id: data.guest_session_id)
            completion(.success(data))
          case .failure(let error):
            log.error(error.localizedDescription)
            completion(.failure(error))
        }
      }
  }
}
