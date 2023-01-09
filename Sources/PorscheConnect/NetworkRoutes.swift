import Foundation

// MARK: - Structs

struct NetworkRoutes {
  let environment: Environment

  // MARK: - Calculated properties

  var loginAuthURL: URL {
    return URL(
      string:
        "\(host("https://login.porsche.com"))/auth/api/v1/\(environment.regionCode)/public/login")!
  }

  var apiAuthURL: URL {
    return URL(string: "\(host("https://login.porsche.com"))/as/authorization.oauth2")!
  }

  var apiTokenURL: URL {
    return URL(string: "\(host("https://login.porsche.com"))/as/token.oauth2")!
  }

  var vehiclesURL: URL {
    return URL(
      string: "\(host("https://api.porsche.com"))/core/api/v3/\(environment.regionCode)/vehicles")!
  }

  // MARK: - Functions

  func vehicleSummaryURL(vehicle: Vehicle) -> URL {
    return URL(
      string: "\(host("https://api.porsche.com"))/service-vehicle/vehicle-summary/\(vehicle.vin)")!
  }

  func vehiclePositionURL(vehicle: Vehicle) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/car-finder/\(vehicle.vin)/position")!
  }

  func vehicleCapabilitiesURL(vehicle: Vehicle) -> URL {
    return URL(
      string: "\(host("https://api.porsche.com"))/service-vehicle/vcs/capabilities/\(vehicle.vin)")!
  }

  func vehicleStatusURL(vehicle: Vehicle) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/vehicle-data/\(environment.regionCode)/status/\(vehicle.vin)"
    )!
  }

  func vehicleEmobilityURL(vehicle: Vehicle, capabilities: Capabilities? = nil) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(capabilities?.carModel ?? kDefaultCarModel)/\(vehicle.vin)?timezone=Europe/Dublin"
    )!
  }

  func vehicleFlashURL(vehicle: Vehicle) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/honk-and-flash/\(vehicle.vin)/flash")!
  }

  func vehicleHonkAndFlashURL(vehicle: Vehicle) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/honk-and-flash/\(vehicle.vin)/honk-and-flash"
    )!
  }

  func vehicleHonkAndFlashRemoteCommandStatusURL(
    vehicle: Vehicle, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/honk-and-flash/\(vehicle.vin)/\(remoteCommand.identifier!)/status"
    )!
  }

  func vehicleToggleDirectChargingURL(
    vehicle: Vehicle, capabilities: Capabilities? = nil, enable: Bool
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(capabilities?.carModel ?? kDefaultCarModel)/\(vehicle.vin)/toggle-direct-charging/\(enable)"
    )!
  }

  func vehicleToggleDirectChargingRemoteCommandStatusURL(
    vehicle: Vehicle, capabilities: Capabilities? = nil, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(capabilities?.carModel ?? kDefaultCarModel)/\(vehicle.vin)/toggle-direct-charging/status/\(remoteCommand.identifier!)"
    )!
  }

  func vehicleToggleDirectClimatisationURL(
    vehicle: Vehicle, enable: Bool
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(vehicle.vin)/toggle-direct-climatisation/\(enable ? "true" : "false")"
    )!
  }
  
  func vehicleToggleDirectClimatisationRemoteCommandStatusURL(
    vehicle: Vehicle, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(vehicle.vin)/toggle-direct-climatisation/status/\(remoteCommand.identifier!)"
    )!
  }
  
  func vehicleLockUnlockURL(
    vehicle: Vehicle, lock: Bool
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/remote-lock-unlock/\(vehicle.vin)/\(lock ? "quick-lock" : "security-pin/unlock")"
    )!
  }

  func vehicleLockUnlockRemoteCommandStatusURL(
    vehicle: Vehicle, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/remote-lock-unlock/\(vehicle.vin)/\(remoteCommand.identifier!)/status"
    )!
  }

  // MARK: - Private

  private func host(_ defaultHost: String) -> String {
    if environment == Environment.test {
      return "http://localhost:\(kTestServerPort)"
    }
    return defaultHost
  }
}
