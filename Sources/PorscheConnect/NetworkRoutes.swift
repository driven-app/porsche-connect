import Foundation

// MARK: - Structs

struct NetworkRoutes {
  let environment: Environment
  
  // MARK: - Calculated properties
  
  var loginAuthURL: URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://login.porsche.com/auth/api/v1/\(environment.regionCode)/public/login")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/auth/api/v1/\(environment.regionCode)/public/login")!
    }
  }
  
  var apiAuthURL: URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://login.porsche.com/as/authorization.oauth2")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/as/authorization.oauth2")!
    }
  }
  
  var apiTokenURL: URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://login.porsche.com/as/token.oauth2")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/as/token.oauth2")!
    }
  }
  
  var vehiclesURL: URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://api.porsche.com/core/api/v3/\(environment.regionCode)/vehicles")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/core/api/v3/\(environment.regionCode)/vehicles")!
    }
  }
  
  // MARK: - Functions
  
  func vehicleSummaryURL(vehicle: Vehicle) -> URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://api.porsche.com/service-vehicle/vehicle-summary/\(vehicle.vin)")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/vehicle-summary/\(vehicle.vin)")!
    }
  }
  
  func vehiclePositionURL(vehicle: Vehicle) -> URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://api.porsche.com/service-vehicle/car-finder/\(vehicle.vin)/position")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/car-finder/\(vehicle.vin)/position")!
    }
  }
  
  func vehicleCapabilitiesURL(vehicle: Vehicle) -> URL {
    switch environment { 
    case .Ireland, .Germany:
      return URL(string: "https://api.porsche.com/service-vehicle/vcs/capabilities/\(vehicle.vin)")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/vcs/capabilities/\(vehicle.vin)")!
    }
  }
  
  func vehicleEmobilityURL(vehicle: Vehicle, capabilities: Capabilities ) -> URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://api.porsche.com/service-vehicle/\(environment.regionCode)/e-mobility/\(capabilities.carModel)/\(vehicle.vin)?timezone=Europe/Dublin")!
    case .Test:
      return URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/\(environment.regionCode)/e-mobility/\(capabilities.carModel)/\(vehicle.vin)?timezone=Europe/Dublin")!
    }
  }
}
