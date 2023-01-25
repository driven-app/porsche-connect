import XCTest

@testable import PorscheConnect

final class NetworkRoutesTests: XCTestCase {

  var capabilities: Capabilities?

  override func setUp() {
    super.setUp()
    capabilities = buildCapabilites()
  }

  func testApplicationRedirectURLPortal() {
    let application = OAuthApplication.api
    XCTAssertEqual(URL(string: "https://my.porsche.com/core/de/de_DE")!, application.redirectURL)
  }

  func testApplicationClientIdCarControl() {
    let application = OAuthApplication.carControl
    XCTAssertEqual("Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs", application.clientId)
  }

  func testApplicationRedirectURLCarControl() {
    let application = OAuthApplication.carControl
    XCTAssertEqual(
      URL(string: "https://my.porsche.com/myservices/auth/auth.html")!, application.redirectURL)
  }

  func testNetworkRoutesGermany() {
    let networkRoute = NetworkRoutes(environment: .germany)
    XCTAssertEqual(
      URL(string: "https://login.porsche.com/auth/api/v1/de/de_DE/public/login")!,
      networkRoute.loginAuthURL)
    XCTAssertEqual(
      URL(string: "https://login.porsche.com/as/authorization.oauth2")!, networkRoute.apiAuthURL)
    XCTAssertEqual(
      URL(string: "https://login.porsche.com/as/token.oauth2")!, networkRoute.apiTokenURL)

    let vin = "12345X"
    XCTAssertEqual(
      URL(string: "https://api.porsche.com/service-vehicle/vehicle-summary/12345X"),
      networkRoute.vehicleSummaryURL(vin: vin))
    XCTAssertEqual(
      URL(string: "https://api.porsche.com/service-vehicle/car-finder/12345X/position"),
      networkRoute.vehiclePositionURL(vin: vin))
    XCTAssertEqual(
      URL(string: "https://api.porsche.com/service-vehicle/vcs/capabilities/12345X"),
      networkRoute.vehicleCapabilitiesURL(vin: vin))
    XCTAssertEqual(
      URL(string: "https://api.porsche.com/e-mobility/de/de_DE/J1/12345X?timezone=Europe/Dublin"),
      networkRoute.vehicleEmobilityURL(vin: vin, capabilities: capabilities!))
    XCTAssertEqual(
      URL(string: "https://api.porsche.com/service-vehicle/honk-and-flash/12345X/flash"),
      networkRoute.vehicleFlashURL(vin: vin))
    XCTAssertEqual(
      URL(string: "https://api.porsche.com/service-vehicle/honk-and-flash/12345X/honk-and-flash"),
      networkRoute.vehicleHonkAndFlashURL(vin: vin))
    XCTAssertEqual(
      URL(string: "https://api.porsche.com/service-vehicle/honk-and-flash/12345X/123456/status"),
      networkRoute.vehicleHonkAndFlashRemoteCommandStatusURL(
        vin: vin, remoteCommand: RemoteCommandAccepted(id: "123456", lastUpdated: Date())))
    XCTAssertEqual(
      URL(
        string: "https://api.porsche.com/e-mobility/de/de_DE/J1/12345X/toggle-direct-charging/true"),
      networkRoute.vehicleToggleDirectChargingURL(
        vin: vin, capabilities: capabilities!, enable: true))
    XCTAssertEqual(
      URL(
        string: "https://api.porsche.com/e-mobility/de/de_DE/J1/12345X/toggle-direct-charging/false"
      ),
      networkRoute.vehicleToggleDirectChargingURL(
        vin: vin, capabilities: capabilities!, enable: false))
    XCTAssertEqual(
      URL(
        string:
          "https://api.porsche.com/e-mobility/de/de_DE/J1/12345X/toggle-direct-charging/status/123456"
      ),
      networkRoute.vehicleToggleDirectChargingRemoteCommandStatusURL(
        vin: vin,
        capabilities: capabilities!,
        remoteCommand: RemoteCommandAccepted(requestId: "123456")))
    XCTAssertEqual(
      URL(
        string:
          "https://api.porsche.com/e-mobility/de/de_DE/12345X/toggle-direct-climatisation/true"),
      networkRoute.vehicleToggleDirectClimatisationURL(vin: vin, enable: true))
    XCTAssertEqual(
      URL(
        string:
          "https://api.porsche.com/e-mobility/de/de_DE/12345X/toggle-direct-climatisation/false"),
      networkRoute.vehicleToggleDirectClimatisationURL(vin: vin, enable: false))
    XCTAssertEqual(
      URL(
        string:
          "https://api.porsche.com/e-mobility/de/de_DE/12345X/toggle-direct-climatisation/status/123456"
      ),
      networkRoute.vehicleToggleDirectClimatisationRemoteCommandStatusURL(
        vin: vin,
        remoteCommand: RemoteCommandAccepted(requestId: "123456")))
    XCTAssertEqual(
      URL(string: "https://api.porsche.com/service-vehicle/remote-lock-unlock/12345X/quick-lock"),
      networkRoute.vehicleLockUnlockURL(vin: vin, lock: true))
    XCTAssertEqual(
      URL(
        string:
          "https://api.porsche.com/service-vehicle/remote-lock-unlock/12345X/security-pin/unlock"),
      networkRoute.vehicleLockUnlockURL(vin: vin, lock: false))
    XCTAssertEqual(
      URL(
        string: "https://api.porsche.com/service-vehicle/remote-lock-unlock/12345X/123456/status"),
      networkRoute.vehicleLockUnlockRemoteCommandStatusURL(
        vin: vin, remoteCommand: RemoteCommandAccepted(requestId: "123456")))
    XCTAssertEqual(
      URL(
        string: "https://api.porsche.com/service-vehicle/de/de_DE/trips/12345X/SHORT_TERM"),
      networkRoute.vehicleShortTermTripsURL(
        vin: vin))
    XCTAssertEqual(
      URL(
        string: "https://api.porsche.com/service-vehicle/de/de_DE/trips/12345X/LONG_TERM"),
      networkRoute.vehicleLongTermTripsURL(
        vin: vin))
    XCTAssertEqual(
      URL(
        string: "https://api.porsche.com/predictive-maintenance/information/12345X"),
      networkRoute.vehicleMaintenanceURL(
        vin: vin))
  }

  func testNetworkRoutesTest() {
    let networkRoute = NetworkRoutes(environment: .test)
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/auth/api/v1/ie/en_IE/public/login")!,
      networkRoute.loginAuthURL)
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/as/authorization.oauth2")!,
      networkRoute.apiAuthURL)
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/as/token.oauth2")!, networkRoute.apiTokenURL)

    let vin = "12345X"
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/vehicle-summary/12345X"),
      networkRoute.vehicleSummaryURL(vin: vin))
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/car-finder/12345X/position"),
      networkRoute.vehiclePositionURL(vin: vin))
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/vcs/capabilities/12345X"),
      networkRoute.vehicleCapabilitiesURL(vin: vin))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/J1/12345X?timezone=Europe/Dublin"
      ), networkRoute.vehicleEmobilityURL(vin: vin, capabilities: capabilities!))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/J1/12345X?timezone=Europe/Dublin"
      ), networkRoute.vehicleEmobilityURL(vin: vin))
    XCTAssertEqual(
      URL(
        string: "http://localhost:\(kTestServerPort)/service-vehicle/honk-and-flash/12345X/flash"),
      networkRoute.vehicleFlashURL(vin: vin))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/honk-and-flash/12345X/honk-and-flash"
      ), networkRoute.vehicleHonkAndFlashURL(vin: vin))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/honk-and-flash/12345X/123456/status"),
      networkRoute.vehicleHonkAndFlashRemoteCommandStatusURL(
        vin: vin, remoteCommand: RemoteCommandAccepted(id: "123456", lastUpdated: Date())))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/J1/12345X/toggle-direct-charging/true"
      ),
      networkRoute.vehicleToggleDirectChargingURL(
        vin: vin, capabilities: capabilities!, enable: true))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/J1/12345X/toggle-direct-charging/true"
      ),
      networkRoute.vehicleToggleDirectChargingURL(vin: vin, enable: true))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/J1/12345X/toggle-direct-charging/false"
      ),
      networkRoute.vehicleToggleDirectChargingURL(
        vin: vin, capabilities: capabilities!, enable: false))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/J1/12345X/toggle-direct-charging/false"
      ),
      networkRoute.vehicleToggleDirectChargingURL(vin: vin, enable: false))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/J1/12345X/toggle-direct-charging/status/123456"
      ),
      networkRoute.vehicleToggleDirectChargingRemoteCommandStatusURL(
        vin: vin,
        capabilities: capabilities!,
        remoteCommand: RemoteCommandAccepted(requestId: "123456")))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/J1/12345X/toggle-direct-charging/status/123456"
      ),
      networkRoute.vehicleToggleDirectChargingRemoteCommandStatusURL(
        vin: vin,
        remoteCommand: RemoteCommandAccepted(requestId: "123456")))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/12345X/toggle-direct-climatisation/true"
      ),
      networkRoute.vehicleToggleDirectClimatisationURL(vin: vin, enable: true))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/12345X/toggle-direct-climatisation/false"
      ),
      networkRoute.vehicleToggleDirectClimatisationURL(vin: vin, enable: false))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/e-mobility/ie/en_IE/12345X/toggle-direct-climatisation/status/123456"
      ),
      networkRoute.vehicleToggleDirectClimatisationRemoteCommandStatusURL(
        vin: vin,
        remoteCommand: RemoteCommandAccepted(requestId: "123456")))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/remote-lock-unlock/12345X/quick-lock"
      ),
      networkRoute.vehicleLockUnlockURL(vin: vin, lock: true))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/remote-lock-unlock/12345X/security-pin/unlock"
      ),
      networkRoute.vehicleLockUnlockURL(vin: vin, lock: false))
    XCTAssertEqual(
      URL(
        string:
          "http://localhost:\(kTestServerPort)/service-vehicle/remote-lock-unlock/12345X/123456/status"
      ),
      networkRoute.vehicleLockUnlockRemoteCommandStatusURL(
        vin: vin, remoteCommand: RemoteCommandAccepted(requestId: "123456")))
    XCTAssertEqual(
      URL(
        string: "http://localhost:\(kTestServerPort)/service-vehicle/ie/en_IE/trips/12345X/SHORT_TERM"),
      networkRoute.vehicleShortTermTripsURL(
        vin: vin))
    XCTAssertEqual(
      URL(
        string: "http://localhost:\(kTestServerPort)/service-vehicle/ie/en_IE/trips/12345X/LONG_TERM"),
      networkRoute.vehicleLongTermTripsURL(
        vin: vin))
    XCTAssertEqual(
      URL(
        string: "http://localhost:\(kTestServerPort)/predictive-maintenance/information/12345X"),
      networkRoute.vehicleMaintenanceURL(
        vin: vin))
  }
}
