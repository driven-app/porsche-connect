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

  func vehicleSummaryURL(vin: String) -> URL {
    return URL(
      string: "\(host("https://api.porsche.com"))/service-vehicle/vehicle-summary/\(vin)")!
  }

  func vehiclePositionURL(vin: String) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/car-finder/\(vin)/position")!
  }

  func vehicleCapabilitiesURL(vin: String) -> URL {
    return URL(
      string: "\(host("https://api.porsche.com"))/service-vehicle/vcs/capabilities/\(vin)")!
  }

  func vehicleStatusURL(vin: String) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/vehicle-data/\(environment.regionCode)/status/\(vin)"
    )!
  }

  func vehicleEmobilityURL(vin: String, capabilities: Capabilities? = nil) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(capabilities?.carModel ?? kDefaultCarModel)/\(vin)?timezone=Europe/Dublin"
    )!
  }

  func vehicleFlashURL(vin: String) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/honk-and-flash/\(vin)/flash")!
  }

  func vehicleHonkAndFlashURL(vin: String) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/honk-and-flash/\(vin)/honk-and-flash"
    )!
  }

  func vehicleHonkAndFlashRemoteCommandStatusURL(
    vin: String, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/honk-and-flash/\(vin)/\(remoteCommand.identifier!)/status"
    )!
  }

  func vehicleToggleDirectChargingURL(
    vin: String, capabilities: Capabilities? = nil, enable: Bool
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(capabilities?.carModel ?? kDefaultCarModel)/\(vin)/toggle-direct-charging/\(enable)"
    )!
  }

  func vehicleToggleDirectChargingRemoteCommandStatusURL(
    vin: String, capabilities: Capabilities? = nil, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(capabilities?.carModel ?? kDefaultCarModel)/\(vin)/toggle-direct-charging/status/\(remoteCommand.identifier!)"
    )!
  }

  func vehicleToggleDirectClimatisationURL(vin: String, enable: Bool) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(vin)/toggle-direct-climatisation/\(enable ? "true" : "false")"
    )!
  }

  func vehicleToggleDirectClimatisationRemoteCommandStatusURL(
    vin: String, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/e-mobility/\(environment.regionCode)/\(vin)/toggle-direct-climatisation/status/\(remoteCommand.identifier!)"
    )!
  }

  func vehicleLockUnlockURL(vin: String, lock: Bool) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/remote-lock-unlock/\(vin)/\(lock ? "quick-lock" : "security-pin/unlock")"
    )!
  }

  func vehicleLockUnlockRemoteCommandStatusURL(
    vin: String, remoteCommand: RemoteCommandAccepted
  ) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/remote-lock-unlock/\(vin)/\(remoteCommand.identifier!)/status"
    )!
  }
  
  func vehicleShortTermTripsURL(vin: String) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/\(environment.regionCode)/trips/\(vin)/SHORT_TERM"
    )!
  }
  
  func vehicleLongTermTripsURL(vin: String) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/\(environment.regionCode)/trips/\(vin)/LONG_TERM"
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
