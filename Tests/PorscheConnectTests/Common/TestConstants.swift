import Foundation
@testable import PorscheConnect

let kDefaultTestTimeout: TimeInterval = 10
let kBlankString = ""
let kBlankData: Data = "".data(using: .utf8)!
let kTestServerPort = 8080

// MARK: - Test Objects & Value Types

let kTestPorschePortalAuth =  PorscheAuth(accessToken: "zVb3smCN32iOslsoXa7XIYPrenGz",
                                    idToken: "yJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiI5NWhPT0ZlSDdzZW9yaVZ2bUNhTWdWIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQwOTE2LCJleHAiOjE2MTI3NDEyMTYsInBpLnNyaSI6IkVYYjZSSlFpRWZLazNRZWk0Y1dyTWlwSmgxSSJ9.bVzapayesKjA85pRwVBZN_TfKzPNFTOb6nszPSWElMU2-MOzmJjy6dWHTjN3jCCx3Ui20XDwHkkDOdIUZqIQq6nve5ihbRlNi1ywrNiKKLOL7nmfzmM7yBPMZfwxtCP_-imypF_n19i1rZDkatIkW0Ejs7lcc0xRD9JewGMhfALqpFuOciIX3SIInHE56WSmTNyEB1LTNNLXiwaBWygPVbYDAYYc4u-w3V_GPZR3kTSTJjwnfXM9Qke6wBcoXDaON4_NfNcTQf0vXYwhC749dJd8Z2eDcRTl-Yl06BTHHTIL-yInfk8yjCO1iaCv01ROjK_nGAyPsOvUKtVgsaXxnw",
                                    tokenType: "Bearer",
                                    expiresIn: 7199)

let kEmobilityNotChargingJson = """
{
\"batteryChargeStatus\": {
  \"plugState\": \"DISCONNECTED\",
  \"lockState\": \"UNLOCKED\",
  \"chargingState\": \"OFF\",
  \"chargingReason\": \"INVALID\",
  \"externalPowerSupplyState\": \"UNAVAILABLE\",
  \"ledColor\": \"NONE\",
  \"ledState\": \"OFF\",
  \"chargingMode\": \"OFF\",
  \"stateOfChargeInPercentage\": 56,
  \"remainingChargeTimeUntil100PercentInMinutes\": null,
  \"remainingERange\": {
    \"value\": 191,
    \"unit\": \"KILOMETER\",
    \"originalValue\": 191,
    \"originalUnit\": \"KILOMETER\",
    \"valueInKilometers\": 191,
    \"unitTranslationKey\": \"GRAY_SLICE_UNIT_KILOMETER\"
  },
  \"remainingCRange\": null,
  \"chargingTargetDateTime\": \"2021-02-19T01:09\",
  \"status\": null,
  \"chargeRate\": {
    \"value\": 0,
    \"unit\": \"KM_PER_MIN\",
    \"valueInKmPerHour\": 0,
    \"unitTranslationKey\": \"EC.COMMON.UNIT.KM_PER_MIN\"
  },
  \"chargingPower\": 0,
  \"chargingInDCMode\": false
},
\"directCharge\": {
  \"disabled\": false,
  \"isActive\": false
},
\"directClimatisation\": {
  \"climatisationState\": \"OFF\",
  \"remainingClimatisationTime\": null
},
\"chargingStatus\": \"NOT_CHARGING\",
\"timers\": [
  {
    \"timerID\": \"1\",
    \"departureDateTime\": \"2021-02-20T07:00:00.000Z\",
    \"preferredChargingTimeEnabled\": false,
    \"preferredChargingStartTime\": null,
    \"preferredChargingEndTime\": null,
    \"frequency\": \"CYCLIC\",
    \"climatised\": false,
    \"weekDays\": {
      \"THURSDAY\": true,
      \"MONDAY\": true,
      \"WEDNESDAY\": true,
      \"SUNDAY\": true,
      \"SATURDAY\": true,
      \"FRIDAY\": true,
      \"TUESDAY\": true
    },
    \"active\": true,
    \"chargeOption\": true,
    \"targetChargeLevel\": 80,
    \"e3_CLIMATISATION_TIMER_ID\": \"4\",
    \"climatisationTimer\": false
  }
],
\"climateTimer\": null,
\"chargingProfiles\": {
  \"currentProfileId\": 4,
  \"profiles\": [
    {
      \"profileId\": 4,
      \"profileName\": \"Allgemein\",
      \"profileActive\": true,
      \"chargingOptions\": {
        \"minimumChargeLevel\": 100,
        \"smartChargingEnabled\": true,
        \"preferredChargingEnabled\": false,
        \"preferredChargingTimeStart\": \"00:00\",
        \"preferredChargingTimeEnd\": \"06:00\"
      },
      \"position\": {
        \"latitude\": 0,
        \"longitude\": 0
      }
    },
    {
      \"profileId\": 5,
      \"profileName\": \"HOME\",
      \"profileActive\": true,
      \"chargingOptions\": {
        \"minimumChargeLevel\": 25,
        \"smartChargingEnabled\": false,
        \"preferredChargingEnabled\": true,
        \"preferredChargingTimeStart\": \"23:00\",
        \"preferredChargingTimeEnd\": \"08:00\"
      },
      \"position\": {
        \"latitude\": 53.376328,
        \"longitude\": -6.332705
      }
    }
  ]
},
\"errorInfo\": []
}
""".data(using: .utf8)!


// MARK: - Helper Functions

func buildCapabilites() -> Capabilities {
  let json = "{\"displayParkingBrake\": true, \"needsSPIN\": true, \"hasRDK\": true, \"engineType\": \"BEV\", \"carModel\": \"J1\", \"onlineRemoteUpdateStatus\": {\"editableByUser\": true, \"active\": true }, \"heatingCapabilities\": {\"frontSeatHeatingAvailable\": true, \"rearSeatHeatingAvailable\": false}, \"steeringWheelPosition\": \"RIGHT\", \"hasHonkAndFlash\": true }".data(using: .utf8)!
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .useDefaultKeys
   return try! decoder.decode(Capabilities.self, from: json)
}

