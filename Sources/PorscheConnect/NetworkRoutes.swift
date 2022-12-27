import Foundation

// MARK: - Structs

struct NetworkRoutes {
  let environment: Environment

  // MARK: - Calculated properties

  var loginAuthURL: URL {
    return URL(
      string: "\(host("https://login.porsche.com"))/auth/api/v1/\(environment.regionCode)/public/login")!
  }

  var apiAuthURL: URL {
    return URL(string: "\(host("https://login.porsche.com"))/as/authorization.oauth2")!
  }

  var apiTokenURL: URL {
    return URL(string: "\(host("https://login.porsche.com"))/as/token.oauth2")!
  }

  var vehiclesURL: URL {
    return URL(string: "\(host("https://api.porsche.com"))/core/api/v3/\(environment.regionCode)/vehicles")!
  }

  // MARK: - Functions

  func vehicleSummaryURL(vehicle: Vehicle) -> URL {
    return URL(string: "\(host("https://api.porsche.com"))/service-vehicle/vehicle-summary/\(vehicle.vin)")!
  }

  func vehiclePositionURL(vehicle: Vehicle) -> URL {
    return URL(
      string: "\(host("https://api.porsche.com"))/service-vehicle/car-finder/\(vehicle.vin)/position")!
  }

  func vehicleCapabilitiesURL(vehicle: Vehicle) -> URL {
    return URL(string: "\(host("https://api.porsche.com"))/service-vehicle/vcs/capabilities/\(vehicle.vin)")!
  }

  func vehicleEmobilityURL(vehicle: Vehicle, capabilities: Capabilities) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(capabilities.carModel)/\(vehicle.vin)?timezone=Europe/Dublin"
    )!
  }

  func vehicleFlashURL(vehicle: Vehicle) -> URL {
    return URL(
      string: "\(host("https://api.porsche.com"))/service-vehicle/honk-and-flash/\(vehicle.vin)/flash")!
  }

  func vehicleHonkAndFlashURL(vehicle: Vehicle) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/honk-and-flash/\(vehicle.vin)/honk-and-flash")!
  }

  func vehicleHonkAndFlashRemoteCommandStatusURL(
    vehicle: Vehicle, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/honk-and-flash/\(vehicle.vin)/\(remoteCommand.id)/status"
    )!
  }

  private func host(_ defaultHost: String) -> String {
    switch environment {
    case .production:
      return defaultHost
    case .test:
      return "http://localhost:\(kTestServerPort)"
    }
  }
}
