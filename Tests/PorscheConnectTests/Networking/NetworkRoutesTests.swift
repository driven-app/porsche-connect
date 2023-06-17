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
    let application = OAuthApplication.api
    XCTAssertEqual("Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs", application.clientId)
  }

  func testNetworkRoutesGermany() {
    let networkRoute = NetworkRoutes(environment: .germany)
    XCTAssertEqual(
      URL(string: "https://identity.porsche.com/authorize?response_type=code&client_id=UYsK00My6bCqJdbQhTQ0PbWmcSdIAMig&code_challenge_method=S256&redirect_uri=https://my.porsche.com&uri_locales=de-DE&audience=https://api.porsche.com&scope=openid"),
      networkRoute.loginAuth0URL
    )
    XCTAssertEqual(
      URL(string: "https://identity.porsche.com/testing-second-authorize?response_type=code&client_id=UYsK00My6bCqJdbQhTQ0PbWmcSdIAMig&code_challenge_method=S256&redirect_uri=https://my.porsche.com&uri_locales=de-DE&audience=https://api.porsche.com&scope=openid"),
      networkRoute.resumeAuth0URL
    )
    XCTAssertEqual(
      URL(string: "https://identity.porsche.com/oauth/token"),
      networkRoute.accessTokenAuth0URL
    )
    XCTAssertEqual(
      URL(string: "https://identity.porsche.com/usernamepassword/login"),
      networkRoute.usernamePasswordLoginAuth0URL
    )
    XCTAssertEqual(
      URL(string: "https://identity.porsche.com/login/callback"),
      networkRoute.callbackAuth0URL
    )

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
      URL(string: "http://localhost:\(kTestServerPort)/authorize?response_type=code&client_id=UYsK00My6bCqJdbQhTQ0PbWmcSdIAMig&code_challenge_method=S256&redirect_uri=https://my.porsche.com&uri_locales=de-DE&audience=https://api.porsche.com&scope=openid"),
      networkRoute.loginAuth0URL
    )
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/testing-second-authorize?response_type=code&client_id=UYsK00My6bCqJdbQhTQ0PbWmcSdIAMig&code_challenge_method=S256&redirect_uri=https://my.porsche.com&uri_locales=de-DE&audience=https://api.porsche.com&scope=openid"),
      networkRoute.resumeAuth0URL
    )
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/oauth/token"),
      networkRoute.accessTokenAuth0URL
    )
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/usernamepassword/login"),
      networkRoute.usernamePasswordLoginAuth0URL
    )
    XCTAssertEqual(
      URL(string: "http://localhost:\(kTestServerPort)/login/callback"),
      networkRoute.callbackAuth0URL
    )

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
