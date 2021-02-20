import Foundation

public extension PorscheConnect {
  
  func vehicles(completion: @escaping (Result<([Vehicle]?, HTTPURLResponse?), Error>) -> Void) {
    executeWithAuth(application: .Portal) { [self] in
      guard let auth = auths[.Portal], let apiKey = auth.apiKey else {
        completion(.failure(PorscheConnectError.AuthFailure))
        return
      }
      
      let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)
      
      networkClient.get([Vehicle].self, url: networkRoutes.vehiclesURL, headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys) { result in
        completion(result)
      }
    }
  }
  

}
