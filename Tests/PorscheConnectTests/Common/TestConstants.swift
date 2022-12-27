import Foundation

@testable import PorscheConnect

let kDefaultTestTimeout: TimeInterval = 10
let kBlankString = ""
let kBlankData: Data = "".data(using: .utf8)!
let kTestServerPort = 8080

// MARK: - Test Objects & Value Types

let kTestPorschePortalAuth = PorscheAuth(
  accessToken: "zVb3smCN32iOslsoXa7XIYPrenGz",
  idToken:
    "yJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiI5NWhPT0ZlSDdzZW9yaVZ2bUNhTWdWIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQwOTE2LCJleHAiOjE2MTI3NDEyMTYsInBpLnNyaSI6IkVYYjZSSlFpRWZLazNRZWk0Y1dyTWlwSmgxSSJ9.bVzapayesKjA85pRwVBZN_TfKzPNFTOb6nszPSWElMU2-MOzmJjy6dWHTjN3jCCx3Ui20XDwHkkDOdIUZqIQq6nve5ihbRlNi1ywrNiKKLOL7nmfzmM7yBPMZfwxtCP_-imypF_n19i1rZDkatIkW0Ejs7lcc0xRD9JewGMhfALqpFuOciIX3SIInHE56WSmTNyEB1LTNNLXiwaBWygPVbYDAYYc4u-w3V_GPZR3kTSTJjwnfXM9Qke6wBcoXDaON4_NfNcTQf0vXYwhC749dJd8Z2eDcRTl-Yl06BTHHTIL-yInfk8yjCO1iaCv01ROjK_nGAyPsOvUKtVgsaXxnw",
  tokenType: "Bearer",
  expiresIn: 7199)

// MARK: - Helper Functions

func buildCapabilites() -> Capabilities {
  let json =
    "{\"displayParkingBrake\": true, \"needsSPIN\": true, \"hasRDK\": true, \"engineType\": \"BEV\", \"carModel\": \"J1\", \"onlineRemoteUpdateStatus\": {\"editableByUser\": true, \"active\": true }, \"heatingCapabilities\": {\"frontSeatHeatingAvailable\": true, \"rearSeatHeatingAvailable\": false}, \"steeringWheelPosition\": \"RIGHT\", \"hasHonkAndFlash\": true }"
    .data(using: .utf8)!
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .useDefaultKeys
  return try! decoder.decode(Capabilities.self, from: json)
}
