import Foundation

public extension PorscheConnect {
  
  func summary(vehicle: Vehicle, completion: @escaping (Result<(Summary?, HTTPURLResponse?), Error>) -> Void) {
    let application: Application = .CarControl

    executeWithAuth(application: application) { [self] in
      guard let auth = auths[application], let apiKey = auth.apiKey else {
        completion(.failure(PorscheConnectError.AuthFailure))
        return
      }
      
      let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)

      networkClient.get(Summary.self, url: networkRoutes.vehicleSummaryURL(vehicle: vehicle), headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys) { result in
        completion(result)
      }
    }
  }
  
  func position(vehicle: Vehicle, completion: @escaping (Result<(Position?, HTTPURLResponse?), Error>) -> Void) {
    let application: Application = .CarControl

    executeWithAuth(application: application) { [self] in
      guard let auth = auths[application], let apiKey = auth.apiKey else {
        completion(.failure(PorscheConnectError.AuthFailure))
        return
      }
      
      let headers = buildHeaders(accessToken: auth.accessToken, apiKey: apiKey, countryCode: environment.countryCode, languageCode: environment.languageCode)
      
      networkClient.get(Position.self, url: networkRoutes.vehiclePositionURL(vehicle: vehicle), headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys) { result in
        completion(result)
      }
    }
  }
}
