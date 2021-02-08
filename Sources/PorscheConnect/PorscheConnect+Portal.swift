import Foundation

public extension PorscheConnect {
  
  func vehicles(success: Success? = nil, failure: Failure? = nil) {
    //TODO: Auth if required
    
    let headers = buildHeaders(accessToken: auth!.accessToken, apiKey: auth!.apiKey!, countryCode: environment.countryCode, languageCode: environment.languageCode)
    
    networkClient.get(Vehicle.self, url: networkRoutes.vehiclesURL, headers: headers) { (vehicles, response, error, responseJson) in
      print()
    }
    
  }
  
  private func buildHeaders(accessToken: String, apiKey: String, countryCode: String, languageCode: String) -> Dictionary<String, String> {
    return ["Authorization": "Bearer \(accessToken)",
            "apikey": apiKey,
            "x-vrs-url-country": countryCode,
            "x-vrs-url-language": "\(languageCode)_\(countryCode.uppercased())"]
  }
  
}
