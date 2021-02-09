import Foundation

public extension PorscheConnect {
  
  func vehicles(completion: @escaping (Result<[Vehicle]?, Error>) -> Void) {

//  func vehicles(success: Success? = nil, failure: Failure? = nil) {
    executeWithAuth { [self] in
      let headers = buildHeaders(accessToken: auth!.accessToken, apiKey: auth!.apiKey!, countryCode: environment.countryCode, languageCode: environment.languageCode)
      
      networkClient.get([Vehicle].self, url: networkRoutes.vehiclesURL, headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys) { (vehicles, response, error, responseJson) in
        
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(vehicles))
        }        
      }
    }
  }
}
