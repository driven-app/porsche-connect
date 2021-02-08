import Foundation

public extension PorscheConnect {
  
  func vehicles(success: Success? = nil, failure: Failure? = nil) {
    executeWithAuth { [self] in
      let headers = buildHeaders(accessToken: auth!.accessToken, apiKey: auth!.apiKey!, countryCode: environment.countryCode, languageCode: environment.languageCode)
      
      networkClient.get([Vehicle].self, url: networkRoutes.vehiclesURL, headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys) { (vehicles, response, error, responseJson) in
        
        self.handleResponse(body: vehicles, response: response, error: error, json: responseJson, success: success, failure: failure)
      }
    }
  }
}
