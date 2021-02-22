import Foundation

// MARK: E-Mobility - Not Charging

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

// MARK: E-Mobility - AC Charging

// MARK: E-Mobility - DC Charging
