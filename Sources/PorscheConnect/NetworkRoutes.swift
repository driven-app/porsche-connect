import Foundation

// MARK: - Structs

struct NetworkRoutes {
  let environment: Environment

  // MARK: - Calculated properties

  var loginAuth0URL: URL {
    return URL(
      string:
        "\(host("https://identity.porsche.com"))/authorize?response_type=code&client_id=\(OAuthApplication.api.clientId)&code_challenge_method=S256&redirect_uri=https://my.porsche.com&uri_locales=de-DE&audience=https://api.porsche.com&scope=openid")!
  }
  
  var resumeAuth0URL: URL { // this is only used in test environment
    return URL(
      string:
        "\(host("https://identity.porsche.com"))/testing-second-authorize?response_type=code&client_id=\(OAuthApplication.api.clientId)&code_challenge_method=S256&redirect_uri=https://my.porsche.com&uri_locales=de-DE&audience=https://api.porsche.com&scope=openid")!
  }
  
  var accessTokenAuth0URL: URL {
    return URL(
      string:
        "\(host("https://identity.porsche.com"))/oauth/token")!
  }
  
  var usernamePasswordLoginAuth0URL: URL {
    return URL(
      string:
        "\(host("https://identity.porsche.com"))/usernamepassword/login")!
  }
  
  var callbackAuth0URL: URL {
    return URL(
      string:
        "\(host("https://identity.porsche.com"))/login/callback")!
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

  func vehiclePicturesURL(vin: String) -> URL {
    return URL(
      string: "\(host("https://api.porsche.com"))/vehicles/v2/\(environment.countryCode)/\(vin)/pictures")!
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

  func vehicleStoredURL(vin: String) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/\(environment.regionCode)/vehicle-data/\(vin)/stored"
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

  func vehicleLockUnlockLastActionsURL(vin: String) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/service-vehicle/remote-lock-unlock/\(vin)/last-actions"
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
  
  func vehicleMaintenanceURL(vin: String) -> URL {
    return URL(
      string:
        "\(host("https://api.porsche.com"))/predictive-maintenance/information/\(vin)"
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
