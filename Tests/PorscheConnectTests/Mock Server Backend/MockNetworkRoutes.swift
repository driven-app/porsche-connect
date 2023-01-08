import Ambassador
import Foundation

final class MockNetworkRoutes {

  // MARK: - Properties

  private static let getHelloWorldPath = "/hello_world.json"
  private static let getApiAuthPath = "/as/authorization.oauth2"
  private static let getVehiclesPath = "/core/api/v3/ie/en_IE/vehicles"
  private static let getSummaryPath = "/service-vehicle/vehicle-summary/A1234"
  private static let getPositionPath = "/service-vehicle/car-finder/A1234/position"
  private static let getCapabilitiesPath = "/service-vehicle/vcs/capabilities/A1234"
  private static let getStatusPath = "/vehicle-data/ie/en_IE/status/A1234"
  private static let getEmobilityPath = "/e-mobility/ie/en_IE/J1/A1234"

  private static let getHonkAndFlashRemoteCommandStatusPath =
    "/service-vehicle/honk-and-flash/A1234/999/status"
  private static let getToggleDirectChargingRemoteCommandStatusPath =
    "/e-mobility/ie/en_IE/J1/A1234/toggle-direct-charging/status/999"
  private static let getToggleDirectClimatisationRemoteCommandStatusPath =
    "/e-mobility/ie/en_IE/A1234/toggle-direct-climatisation/status/999"
  private static let getLockUnlockRemoteCommandStatusPath =
    "service-vehicle/remote-lock-unlock/A1234/999/status"

  private static let postLoginAuthPath = "/auth/api/v1/ie/en_IE/public/login"
  private static let postApiTokenPath = "/as/token.oauth2"
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

  // MARK: - Post Login Auth

  func mockPostLoginAuthSuccessful(router: Router) {
    router[MockNetworkRoutes.postLoginAuthPath] = DataResponse(
      statusCode: 200, statusMessage: "ok", headers: [("Set-Cookie", "CIAM.status=mockValue")])
  }

  func mockPostLoginAuthFailure(router: Router) {
    router[MockNetworkRoutes.postLoginAuthPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: - Get Api Auth

  func mockGetApiAuthSuccessful(router: Router) {
    router[MockNetworkRoutes.getApiAuthPath] = DataResponse(
      statusCode: 200, statusMessage: "ok",
      headers: [
        ("cdn-original-uri", "/static/cms/auth.html?code=fqFQlQSUfNkMGtMLj0zRK0RriKdPySGVMmVXPAAC")
      ])
  }

  func mockGetApiAuthFailure(router: Router) {
    router[MockNetworkRoutes.getApiAuthPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
  }

  // MARK: - Post Api Token

  func mockPostApiTokenSuccessful(router: Router) {
    router[MockNetworkRoutes.postApiTokenPath] = JSONResponse(statusCode: 200) { _ -> Any in
      return self.mockApiTokenResponse()
    }
  }

  func mockPostApiTokenFailure(router: Router) {
    router[MockNetworkRoutes.postApiTokenPath] = DataResponse(
      statusCode: 400, statusMessage: "bad request")
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
        ],
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
      ],
      "mileage": [
        "value": 2195,
        "unit": "KILOMETERS",
        "originalValue": 2195,
        "originalUnit": "KILOMETERS",
        "valueInKilometers": 2195,
        "unitTranslationKey": "GRAY_SLICE_UNIT_KILOMETER",
        "unitTranslationKeyV2": "TC.UNIT.KILOMETER",
      ],
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
          ],
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
        ],
        "electricalRange": [
          "distance": [
            "value": 294,
            "unit": "KILOMETERS",
            "originalValue": 294,
            "originalUnit": "KILOMETERS",
            "valueInKilometers": 294,
            "unitTranslationKey": "GRAY_SLICE_UNIT_KILOMETER",
            "unitTranslationKeyV2": "TC.UNIT.KILOMETER",
          ],
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
}
