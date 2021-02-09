import Foundation

public extension PorscheConnect {
  
  func vehicles(completion: @escaping (Result<([Vehicle]?, HTTPURLResponse?), Error>) -> Void) {
    executeWithAuth { [self] in
      let headers = buildHeaders(accessToken: auth!.accessToken, apiKey: auth!.apiKey!, countryCode: environment.countryCode, languageCode: environment.languageCode)
      
      networkClient.get([Vehicle].self, url: networkRoutes.vehiclesURL, headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys) { result in
        completion(result)
      }
    }
  }
}
