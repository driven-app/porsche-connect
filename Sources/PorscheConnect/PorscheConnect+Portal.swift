import Foundation

public extension PorscheConnect {
  
  func vehicles(success: Success? = nil, failure: Failure? = nil) {
    //TODO: Auth if required
    
    networkClient.get(Vehicle.self, url: networkRoutes.vehiclesURL, headers: [:]) { (vehicles, response, error, responseJson) in
      print()
    }
    
  }
  
}
