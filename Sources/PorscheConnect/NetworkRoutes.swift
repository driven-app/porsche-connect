import Foundation

// MARK: - Structs

struct NetworkRoutes {
  let environment: Environment

  // MARK: - Calculated properties

  var loginAuthURL: URL {
    switch environment {
    case .production:
      return URL(
        string: "https://login.porsche.com/auth/api/v1/\(environment.regionCode)/public/login")!
    case .test:
      return URL(
        string:
          "http://localhost:\(kTestServerPort)/auth/api/v1/\(environment.regionCode)/public/login")!
    }
  }

  var apiAuthURL: URL {
    switch environment {
    case .production:
      return URL(string: "https://login.porsche.com/as/authorization.oauth2")!
    case .test:
      return URL(string: "http://localhost:\(kTestServerPort)/as/authorization.oauth2")!
    }
  }

  var apiTokenURL: URL {
    switch environment {
    case .production:
      return URL(string: "https://login.porsche.com/as/token.oauth2")!
    case .test:
      return URL(string: "http://localhost:\(kTestServerPort)/as/token.oauth2")!
    }
  }

  var vehiclesURL: URL {
    switch environment {
    case .production:
      return URL(string: "https://api.porsche.com/core/api/v3/\(environment.regionCode)/vehicles")!
    case .test:
      return URL(
        string: "http://localhost:\(kTestServerPort)/core/api/v3/\(environment.regionCode)/vehicles"
      )!
    }
  }

  // MARK: - Functions

  func vehicleSummaryURL(vehicle: Vehicle) -> URL {
    switch environment {
    case .production:
      return URL(string: "https://api.porsche.com/service-vehicle/vehicle-summary/\(vehicle.vin)")!
    case .test:
      return URL(
        string: "http://localhost:\(kTestServerPort)/service-vehicle/vehicle-summary/\(vehicle.vin)"
      )!
    }
  }

  func vehiclePositionURL(vehicle: Vehicle) -> URL {
    switch environment {
    case .production:
      return URL(
        string: "https://api.porsche.com/service-vehicle/car-finder/\(vehicle.vin)/position")!
    case .test:
      return URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/car-finder/\(vehicle.vin)/position")!
    }
  }

  func vehicleCapabilitiesURL(vehicle: Vehicle) -> URL {
    switch environment {
    case .production:
      return URL(string: "https://api.porsche.com/service-vehicle/vcs/capabilities/\(vehicle.vin)")!
    case .test:
      return URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/vcs/capabilities/\(vehicle.vin)")!
    }
  }

  func vehicleEmobilityURL(vehicle: Vehicle, capabilities: Capabilities) -> URL {
    switch environment {
    case .production:
      return URL(
        string:
          "https://api.porsche.com/e-mobility/\(environment.regionCode)/\(capabilities.carModel)/\(vehicle.vin)?timezone=Europe/Dublin"
      )!
    case .test:
      return URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/\(environment.regionCode)/\(capabilities.carModel)/\(vehicle.vin)?timezone=Europe/Dublin"
      )!
    }
  }

  func vehicleFlashURL(vehicle: Vehicle) -> URL {
    switch environment {
    case .production:
      return URL(
        string: "https://api.porsche.com/service-vehicle/honk-and-flash/\(vehicle.vin)/flash")!
    case .test:
      return URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/honk-and-flash/\(vehicle.vin)/flash")!
    }
  }

  func vehicleHonkAndFlashURL(vehicle: Vehicle) -> URL {
    switch environment {
    case .production:
      return URL(
        string:
          "https://api.porsche.com/service-vehicle/honk-and-flash/\(vehicle.vin)/honk-and-flash")!
    case .test:
      return URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/honk-and-flash/\(vehicle.vin)/honk-and-flash"
      )!
    }
  }

  func vehicleHonkAndFlashRemoteCommandStatusURL(
    vehicle: Vehicle, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    switch environment {
    case .production:
      return URL(
        string:
          "https://api.porsche.com/service-vehicle/honk-and-flash/\(vehicle.vin)/\(remoteCommand.id)/status"
      )!
    case .test:
      return URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/honk-and-flash/\(vehicle.vin)/\(remoteCommand.id)/status"
      )!
    }
  }
}
