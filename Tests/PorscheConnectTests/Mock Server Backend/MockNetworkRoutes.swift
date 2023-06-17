import Ambassador
import Foundation

final class MockNetworkRoutes {

  // MARK: - Properties

  private static let getHelloWorldPath = "/hello_world.json"
  private static let getAuth0LoginPath = "/authorize"
  private static let getAuth0ResumeAuthPath = "/testing-second-authorize"
  private static let getVehiclesPath = "/core/api/v3/ie/en_IE/vehicles"
  private static let getSummaryPath = "/service-vehicle/vehicle-summary/A1234"
  private static let getPositionPath = "/service-vehicle/car-finder/A1234/position"
  private static let getCapabilitiesPath = "/service-vehicle/vcs/capabilities/A1234"
  private static let getStatusPath = "/vehicle-data/ie/en_IE/status/A1234"
  private static let getEmobilityPath = "/e-mobility/ie/en_IE/J1/A1234"
  private static let getShortTermTripsPath = "/service-vehicle/ie/en_IE/trips/A1234/SHORT_TERM"
  private static let getLongTermTripsPath = "/service-vehicle/ie/en_IE/trips/A1234/LONG_TERM"
  private static let getMaintenancePath = "/predictive-maintenance/information/A1234"
  private static let getHonkAndFlashRemoteCommandStatusPath =
    "/service-vehicle/honk-and-flash/A1234/999/status"
  private static let getToggleDirectChargingRemoteCommandStatusPath =
    "/e-mobility/ie/en_IE/J1/A1234/toggle-direct-charging/status/999"
  private static let getToggleDirectClimatisationRemoteCommandStatusPath =
    "/e-mobility/ie/en_IE/A1234/toggle-direct-climatisation/status/999"
  private static let getLockUnlockRemoteCommandStatusPath =
    "service-vehicle/remote-lock-unlock/A1234/999/status"

  private static let postAuth0LoginDetailsPath = "/usernamepassword/login"
  private static let postAuth0CallbackPath = "/login/callback"
  private static let postAuth0AccessTokenPath = "/oauth/token"
  private static let postFlashPath = "/service-vehicle/honk-and-flash/A1234/flash"
  private static let postHonkAndFlashPath = "/service-vehicle/honk-and-flash/A1234/honk-and-flash"
  private static let postToggleDirectChargingOnPath =
    "/e-mobility/ie/en_IE/J1/A1234/toggle-direct-charging/true"
  private static let postToggleDirectChargingOffPath =
    "/e-mobility/ie/en_IE/J1/A1234/toggle-direct-charging/false"
  private static let postLockPath = "/service-vehicle/remote-lock-unlock/A1234/quick-lock"
  private static let getPostUnockPath =
    "/service-vehicle/remote-lock-unlock/A1234/security-pin/unlock"

  // MARK: - Hello World

  func mockGetHelloWorldSuccessful(router: Router) {
    router[MockNetworkRoutes.getHelloWorldPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockHelloWorldResponse()
    }
  }

  func mockGetHelloWorldFailure(router: Router) {
    router[MockNetworkRoutes.getHelloWorldPath] = JSONResponse(
      statusCode: 401, statusMessage: "unauthorized")
  }

  // MARK: – Get Auth0 Initial State
  
  func mockGetAuth0InitialStateSuccessful(router: Router) {
    router[MockNetworkRoutes.getAuth0LoginPath] = DataResponse(
      statusCode: 302, statusMessage: "Found",
      headers: [
        ("Location", "/login?state=hKFo2SAyMU45djQ4bEdVeVpfRnBPajE2dktQcmVMTExLTTBFVqFupWxvZ2luo3RpZNkgYzZGOE5TeWpoTzZ4Y0hTSTFJZ1BWTWh1M2k4WW12T2OjY2lk2SBVWXNLMDBNeTZiQ3FKZGJRaFRRMFBiV21jU2RJQU1pZw&client=UYsK00My6bCqJdbQhTQ0PbWmcSdIAMig&protocol=oauth2&response_type=code&code_challenge_method=S256&redirect_uri=https%3A%2F%2Fmy.porsche.com&uri_locales=de-DE&audience=https%3A%2F%2Fapi.porsche.com&scope=openid")
      ])
  }
  
  // MARK: – Post Auth0 Loging Details
  
  func mockPostLoginDetailsAuth0Successful(router: Router) {
    router[MockNetworkRoutes.postAuth0LoginDetailsPath] = DataResponse(
      statusCode: 200, statusMessage: "ok", contentType: "text/html") { environ -> Data in
        return Data("<form method=\"post\" name=\"hiddenform\" action=\"https://identity.porsche.com/login/callback\">\n    <input type=\"hidden\" name=\"wa\" value=\"wsignin1.0\">\n    <input type=\"hidden\" \n           name=\"wresult\" \n           value=\"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1c2VyX2lkIjoiNjQ3NmEyNTZmNzUzZmY1NWFmY2IzY2JkIiwiZW1haWwiOiJkYW1pZW4uZ2xhbmN5QGljbG91ZC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwic2lkIjoiSTRlZkE1akVYWXNfRjJnZDVKVnlPQ2dEWGc4b3pBbFEiLCJpYXQiOjE2ODcwMjIzMDMsImV4cCI6MTY4NzAyMjM2MywiYXVkIjoidXJuOmF1dGgwOnBvcnNjaGUtcHJvZHVjdGlvbjpVc2VybmFtZS1QYXNzd29yZC1BdXRoZW50aWNhdGlvbiIsImlzcyI6InVybjphdXRoMCJ9.MH8OBE55g8dPPHHpH0lQEF7NFvy6hYN5zIHZlbpFr8XRl29P8TVRlLrpcFft85cn4e5u16PVCnXROmdt_SAko_AWB4TZ0WgQDDDr5z-x8XHkJfkAlsoz4DG0t3tu9hnyv1gNh-NDKqv8GRAEjHTvZgKRIG5Jjo3uoRlEWIrj9TVGT04czlK18p-zgc68XOE2TPkmlbwPD9RLygAyNwJboYWlwVRpkvHGwEghMF6zyss3B1K_YZMGHPUal8k_HktvDgW6-1yDluJAQ0Sz3vG4iG7UyYms6XuARrJFO4GtA5uyEbkF8wz3vCbUar4Z_rS-d9Q9VV0ycH8WKFcekIHoAg\">\n    <input type=\"hidden\" name=\"wctx\" value=\"{&#34;strategy&#34;:&#34;auth0&#34;,&#34;auth0Client&#34;:&#34;&#34;,&#34;tenant&#34;:&#34;porsche-production&#34;,&#34;connection&#34;:&#34;Username-Password-Authentication&#34;,&#34;client_id&#34;:&#34;UYsK00My6bCqJdbQhTQ0PbWmcSdIAMig&#34;,&#34;response_type&#34;:&#34;code&#34;,&#34;redirect_uri&#34;:&#34;https://my.porsche.com/&#34;,&#34;state&#34;:&#34;hKFo2SBUbnJVZ2hEM1FrYXJWNlUydG96WHBKeDd3NEk0bzljbaFupWxvZ2luo3RpZNkgeHVfbTJ3TDZlRFdSa3lyVTJJUUZhSW91WjZGRFMtMHqjY2lk2SBVWXNLMDBNeTZiQ3FKZGJRaFRRMFBiV21jU2RJQU1pZw&#34;,&#34;sid&#34;:&#34;I4efA5jEXYs_F2gd5JVyOCgDXg8ozAlQ&#34;,&#34;audience&#34;:&#34;https://api.porsche.com&#34;,&#34;realm&#34;:&#34;Username-Password-Authentication&#34;}\">\n    <noscript>\n        <p>\n            Script is disabled. Click Submit to continue.\n        </p><input type=\"submit\" value=\"Submit\">\n    </noscript>\n</form>".utf8)
      }
  }

  // MARK: – Post Auth0 Callback
  
  func mockGetAuth0CallbackSuccessful(router: Router) {
    router[MockNetworkRoutes.postAuth0CallbackPath] = DataResponse(
      statusCode: 302, statusMessage: "Found")
  }
  
  // MARK: – Get Auth0 Resume Auth
  
  func mockGetAuth0ResumeAuthSuccessful(router: Router) {
    router[MockNetworkRoutes.getAuth0ResumeAuthPath] = DataResponse(
      statusCode: 302, statusMessage: "Found",
      headers: [
        ("Location", "https://my.porsche.com/?code=k4b1NKzJ1lkC_E1ox9wgcbno9_FNI_XDLGs51yE1PJCWB")
      ])
  }
  
  // MARK: – Post Access Token
  
  func mockPostAuth0AccessTokenSuccessful(router: Router) {
    router[MockNetworkRoutes.postAuth0AccessTokenPath] = JSONResponse(statusCode: 302) { _ -> Any in
      return self.mockApiTokenResponse()
    }
  }
  
  // MARK: - Get Vehicles

  func mockGetVehiclesSuccessful(router: Router) {
    router[MockNetworkRoutes.getVehiclesPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockVehiclesResponse()
    }
  }

  func mockGetVehiclesFailure(router: Router) {
    router[MockNetworkRoutes.getVehiclesPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: - Get Summary

  func mockGetSummarySuccessful(router: Router) {
    router[MockNetworkRoutes.getSummaryPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockSummaryResponse()
    }
  }

  func mockGetSummaryFailure(router: Router) {
    router[MockNetworkRoutes.getSummaryPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: - Get Position

  func mockGetPositionSuccessful(router: Router) {
    router[MockNetworkRoutes.getPositionPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockPositionResponse()
    }
  }

  func mockGetPositionFailure(router: Router) {
    router[MockNetworkRoutes.getPositionPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: - Get Capabilities

  func mockGetCapabilitiesSuccessful(router: Router) {
    router[MockNetworkRoutes.getCapabilitiesPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockCapabilitiesResponse()
    }
  }

  func mockGetCapabilitiesFailure(router: Router) {
    router[MockNetworkRoutes.getCapabilitiesPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: - Get Status

  func mockGetStatusSuccessful(router: Router) {
    router[MockNetworkRoutes.getStatusPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockStatusResponse()
    }
  }

  func mockGetStatusFailure(router: Router) {
    router[MockNetworkRoutes.getStatusPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: - Get Emobility

  func mockGetEmobilityNotChargingSuccessful(router: Router) {
    router[MockNetworkRoutes.getEmobilityPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockEmobilityResponse(mockedResponse: kEmobilityNotChargingJson)
    }
  }

  func mockGetEmobilityACTimerChargingSuccessful(router: Router) {
    router[MockNetworkRoutes.getEmobilityPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockEmobilityResponse(mockedResponse: kEmobilityACTimerChargingJson)
    }
  }

  func mockGetEmobilityACDirectChargingSuccessful(router: Router) {
    router[MockNetworkRoutes.getEmobilityPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockEmobilityResponse(mockedResponse: kEmobilityACDirectChargingJson)
    }
  }

  func mockGetEmobilityDCChargingSuccessful(router: Router) {
    router[MockNetworkRoutes.getEmobilityPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockEmobilityResponse(mockedResponse: kEmobilityDCChargingJson)
    }
  }

  func mockGetEmobilityFailure(router: Router) {
    router[MockNetworkRoutes.getEmobilityPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: – Get Honk and Flash

  func mockPostFlashSuccessful(router: Router) {
    router[MockNetworkRoutes.postFlashPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandAcceptedVariantOne()
      })
  }

  func mockPostFlashFailure(router: Router) {
    router[MockNetworkRoutes.postFlashPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  func mockPostHonkAndFlashSuccessful(router: Router) {
    router[MockNetworkRoutes.postHonkAndFlashPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandAcceptedVariantOne()
      })
  }

  func mockPostHonkAndFlashFailure(router: Router) {
    router[MockNetworkRoutes.postHonkAndFlashPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: – Post Toggle Direct Charging

  func mockPostToggleDirectChargingOnSuccessful(router: Router) {
    router[MockNetworkRoutes.postToggleDirectChargingOnPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandAcceptedVariantTwo()
      })
  }

  func mockPostToggleDirectChargingOnFailure(router: Router) {
    router[MockNetworkRoutes.postToggleDirectChargingOnPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  func mockPostToggleDirectChargingOffSuccessful(router: Router) {
    router[MockNetworkRoutes.postToggleDirectChargingOffPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandAcceptedVariantTwo()
      })
  }

  func mockPostToggleDirectChargingOffFailure(router: Router) {
    router[MockNetworkRoutes.postToggleDirectChargingOffPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: – Post Lock Vehicle

  func mockPostLockSuccessful(router: Router) {
    router[MockNetworkRoutes.postLockPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandAcceptedVariantThree()
      })
  }

  func mockPostLockFailure(router: Router) {
    router[MockNetworkRoutes.postLockPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: – Post Unlock Vehicle

  func mockGetPostUnlockSuccessful(router: Router) {
    router[MockNetworkRoutes.getPostUnockPath] = JSONResponse(
      statusCode: 200,
      handler: { (req) -> Any in
        guard let method = req["REQUEST_METHOD"] as? String else { return }
        return method == "GET"
          ? self.mockUnlockSecurityResponse() : self.mockRemoteCommandAcceptedVariantThree()
      })
  }

  func mockGetPostUnlockLockedError(router: Router) {
    router[MockNetworkRoutes.getPostUnockPath] = JSONResponse(
      statusCode: 200,
      handler: { (req) -> Any in
        guard let method = req["REQUEST_METHOD"] as? String else { return }
        return method == "GET"
          ? self.mockUnlockSecurityResponse() : self.mockRemoteCommandAcceptedLockedError()
      })
  }

  func mockGetPostUnlockIncorrectPinError(router: Router) {
    router[MockNetworkRoutes.getPostUnockPath] = JSONResponse(
      statusCode: 200,
      handler: { (req) -> Any in
        guard let method = req["REQUEST_METHOD"] as? String else { return }
        return method == "GET"
          ? self.mockUnlockSecurityResponse() : self.mockRemoteCommandAcceptedIncorrectPinError()
      })
  }

  func mockGetPostUnlockFailure(router: Router) {
    router[MockNetworkRoutes.getPostUnockPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: – Short Term Trips

  func mockGetShortTermTripsSuccessful(router: Router) {
    router[MockNetworkRoutes.getShortTermTripsPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockArrayResponse(mockedResponse: kShortTermTripsInMetricJson)
    }
  }
  
  func mockGetShortTermTripsFailure(router: Router) {
    router[MockNetworkRoutes.getShortTermTripsPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }
  
  // MARK: – Long Term Trips

  func mockGetLongTermTripsSuccessful(router: Router) {
    router[MockNetworkRoutes.getLongTermTripsPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockArrayResponse(mockedResponse: kLongTermTripsInMetricJson)
    }
  }
  
  func mockGetLongTermTripsFailure(router: Router) {
    router[MockNetworkRoutes.getLongTermTripsPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }
  
  // MARK: – Maintenance

  func mockGetMaintenanceSuccessful(router: Router) {
    router[MockNetworkRoutes.getMaintenancePath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockDictionaryResponse(mockedResponse: kMaintenanceItemsJson)
    }
  }
  
  func mockGetMaintenanceFailure(router: Router) {
    router[MockNetworkRoutes.getMaintenancePath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: – Remote Command Status

  func mockGetHonkAndFlashRemoteCommandStatusInProgress(router: Router) {
    router[MockNetworkRoutes.getHonkAndFlashRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusInProgress()
      })
  }

  func mockGetHonkAndFlashRemoteCommandStatusSuccess(router: Router) {
    router[MockNetworkRoutes.getHonkAndFlashRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusSuccess()
      })
  }

  func mockGetHonkAndFlashRemoteCommandStatusFailure(router: Router) {
    router[MockNetworkRoutes.getHonkAndFlashRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusFailure()
      })
  }

  func mockGetToggleDirectChargingRemoteCommandStatusInProgress(router: Router) {
    router[MockNetworkRoutes.getToggleDirectChargingRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusInProgress()
      })
  }

  func mockGetToggleDirectChargingRemoteCommandStatusSuccess(router: Router) {
    router[MockNetworkRoutes.getToggleDirectChargingRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusSuccess()
      })
  }

  func mockGetToggleDirectChargingRemoteCommandStatusFailure(router: Router) {
    router[MockNetworkRoutes.getToggleDirectChargingRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusFailure()
      })
  }
  
  func mockGetToggleDirectClimatisationRemoteCommandStatusInProgress(router: Router) {
    router[MockNetworkRoutes.getToggleDirectClimatisationRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusInProgress()
      })
  }

  func mockGetToggleDirectClimatisationRemoteCommandStatusSuccess(router: Router) {
    router[MockNetworkRoutes.getToggleDirectClimatisationRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusSuccess()
      })
  }

  func mockGetToggleDirectClimatisationRemoteCommandStatusFailure(router: Router) {
    router[MockNetworkRoutes.getToggleDirectClimatisationRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusFailure()
      })
  }

  func mockGetLockUnlockRemoteCommandStatusInProgress(router: Router) {
    router[MockNetworkRoutes.getLockUnlockRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusInProgress()
      })
  }

  func mockGetLockUnlockRemoteCommandStatusSuccess(router: Router) {
    router[MockNetworkRoutes.getLockUnlockRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusSuccess()
      })
  }

  func mockGetLockUnlockRemoteCommandStatusFailure(router: Router) {
    router[MockNetworkRoutes.getLockUnlockRemoteCommandStatusPath] = JSONResponse(
      statusCode: 200,
      handler: { _ -> Any in
        return self.mockRemoteCommandStatusFailure()
      })
  }

  // MARK: - Mock Responses

  private func mockHelloWorldResponse() -> [String: Any] {
    return ["message": "Hello World!"]
  }
  
  private func mockApiTokenResponse() -> [String: Any] {
    return [
      "access_token": "Kpjg2m1ZXd8GM0pvNIB3jogWd0o6",
      "id_token":
        "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ",
      "token_type": "Bearer",
      "scope": "openid",
      "expires_in": 7199,
    ]
  }

  private func mockVehiclesResponse() -> [[String: Any]] {
    return [
      [
        "vin": "VIN12345",
        "modelDescription": "Porsche Taycan 4S",
        "modelType": "A Test Model Type",
        "modelYear": "2021",
        "exteriorColorHex": "#47402e",
        "attributes": [["name": "licenseplate", "value": "Porsche Taycan"]],
      ]
    ]
  }

  private func mockSummaryResponse() -> [String: Any] {
    return [
      "modelDescription": "Taycan 4S",
      "nickName": "211-D-12345",
    ]
  }

  private func mockPositionResponse() -> [String: Any] {
    return [
      "carCoordinate":
        [
          "geoCoordinateSystem": "WGS84",
          "latitude": 53.395367,
          "longitude": -6.389296,
        ] as [String : Any] as [String : Any],
      "heading": 68,
    ]
  }

  private func mockCapabilitiesResponse() -> [String: Any] {
    return [
      "displayParkingBrake": true,
      "needsSPIN": true,
      "hasRDK": true,
      "engineType": "BEV",
      "carModel": "J1",
      "onlineRemoteUpdateStatus": [
        "editableByUser": true,
        "active": true,
      ],
      "heatingCapabilities": [
        "frontSeatHeatingAvailable": true,
        "rearSeatHeatingAvailable": false,
      ],
      "steeringWheelPosition": "RIGHT",
      "hasHonkAndFlash": true,
    ]
  }

  private func mockStatusResponse() -> [String: Any?] {
    return [
      "vin": "ABC123",
      "fuelLevel": nil,
      "oilLevel": nil,
      "batteryLevel": [
        "value": 73,
        "unit": "PERCENT",
        "unitTranslationKey": "GRAY_SLICE_UNIT_PERCENT",
        "unitTranslationKeyV2": "TC.UNIT.PERCENT",
      ] as [String : Any],
      "mileage": [
        "value": 2195,
        "unit": "KILOMETERS",
        "originalValue": 2195,
        "originalUnit": "KILOMETERS",
        "valueInKilometers": 2195,
        "unitTranslationKey": "GRAY_SLICE_UNIT_KILOMETER",
        "unitTranslationKeyV2": "TC.UNIT.KILOMETER",
      ] as [String : Any],
      "overallLockStatus": "CLOSED_LOCKED",
      "serviceIntervals": [
        "oilService": [
          "distance": nil,
          "time": nil,
        ],
        "inspection": [
          "distance": [
            "value": -27842,
            "unit": "KILOMETERS",
            "originalValue": -27842,
            "originalUnit": "KILOMETERS",
            "valueInKilometers": -27842,
            "unitTranslationKey": "GRAY_SLICE_UNIT_KILOMETER",
            "unitTranslationKeyV2": "TC.UNIT.KILOMETER",
          ] as [String : Any],
          "time": [
            "value": -710,
            "unit": "DAYS",
            "unitTranslationKey": "GRAY_SLICE_UNIT_DAY",
            "unitTranslationKeyV2": "TC.UNIT.DAYS",
          ],
        ],
      ],
      "remainingRanges": [
        "conventionalRange": [
          "distance": nil,
          "engineType": "UNSUPPORTED",
        ] as [String : Any?],
        "electricalRange": [
          "distance": [
            "value": 294,
            "unit": "KILOMETERS",
            "originalValue": 294,
            "originalUnit": "KILOMETERS",
            "valueInKilometers": 294,
            "unitTranslationKey": "GRAY_SLICE_UNIT_KILOMETER",
            "unitTranslationKeyV2": "TC.UNIT.KILOMETER",
          ] as [String : Any],
          "engineType": "ELECTRIC",
        ],
      ],
    ]
  }

  private func mockEmobilityResponse(mockedResponse: Data) -> [String: Any] {
    return try! (JSONSerialization.jsonObject(with: mockedResponse, options: []) as! [String: Any])
  }

  private func mockRemoteCommandAcceptedVariantOne() -> [String: Any] {
    return ["id": "123456789", "lastUpdated": "2022-12-27T13:19:23Z"]
  }

  private func mockRemoteCommandAcceptedVariantTwo() -> [String: Any] {
    return ["requestId": "123456789"]
  }

  private func mockRemoteCommandAcceptedVariantThree() -> [String: Any] {
    return ["requestId": "123456789", "vin": "WP0ZZZY4MSA38703"]
  }

  private func mockRemoteCommandStatusInProgress() -> [String: Any] {
    return ["status": "IN_PROGRESS"]
  }

  private func mockRemoteCommandStatusSuccess() -> [String: Any] {
    return ["status": "SUCCESS"]
  }

  private func mockRemoteCommandStatusFailure() -> [String: Any] {
    return ["status": "FAILURE", "errorType": "INTERNAL"]
  }

  private func mockUnlockSecurityResponse() -> [String: Any] {
    return [
      "securityToken": "62xuTQXWgJgnCNsqPoWv8emAeFKCMhPWH6mVwp0OaKqT61uuGxptmNVaq4evL",
      "challenge": "D951A4D79D90EFE70C9F75A100632D756625A326110E921566B3336C32DFAE32",
    ]
  }

  private func mockRemoteCommandAcceptedLockedError() -> [String: Any?] {
    return [
      "pcckErrorKey": "LOCKED_60_MINUTES", "pcckErrorMessage": nil, "pcckErrorCode": nil,
      "pcckIsBusinessError": true,
    ]
  }

  private func mockRemoteCommandAcceptedIncorrectPinError() -> [String: Any?] {
    return [
      "pcckErrorKey": "INCORRECT", "pcckErrorMessage": nil, "pcckErrorCode": nil,
      "pcckIsBusinessError": false,
    ]
  }
  
  private func mockArrayResponse(mockedResponse: Data) -> [[String: Any]] {
    return try! (JSONSerialization.jsonObject(with: mockedResponse, options: []) as! [[String: Any]])
  }
  
  private func mockDictionaryResponse(mockedResponse: Data) -> [String: Any] {
    return try! (JSONSerialization.jsonObject(with: mockedResponse, options: []) as! [String: Any])
  }
}
