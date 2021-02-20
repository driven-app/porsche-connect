import Foundation

public extension PorscheConnect {
  
  func vehicles(completion: @escaping (Result<([Vehicle]?, HTTPURLResponse?), Error>) -> Void) {
    let application: Application = .Portal
    
    executeWithAuth(application: application) { [self] in
      guard let auth = auths[application], let apiKey = auth.apiKey else {
        DispatchQueue.main.async {
          completion(.failure(PorscheConnectError.AuthFailure))
        }
        return
      }
      
      let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)
      
      networkClient.get([Vehicle].self, url: networkRoutes.vehiclesURL, headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys) { result in
        DispatchQueue.main.async {
          completion(result)
        }
      }
    }
  }
}
