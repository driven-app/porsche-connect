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
          \"latitude\": 53.365771,
          \"longitude\": -6.330550
        }
      }
    ]
  },
  \"errorInfo\": []
  }
  """.data(using: .utf8)!

// MARK: E-Mobility - AC Charging - Timer

let kEmobilityACTimerChargingJson = """
  {
    \"batteryChargeStatus\": {
      \"plugState\": \"CONNECTED\",
      \"lockState\": \"LOCKED\",
      \"chargingState\": \"CHARGING\",
      \"chargingReason\": \"TIMER1\",
      \"externalPowerSupplyState\": \"AVAILABLE\",
      \"ledColor\": \"GREEN\",
      \"ledState\": \"BLINK\",
      \"chargingMode\": \"AC\",
      \"stateOfChargeInPercentage\": 56,
      \"remainingChargeTimeUntil100PercentInMinutes\": 260,
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
        \"value\": 0.5,
        \"unit\": \"KM_PER_MIN\",
        \"valueInKmPerHour\": 30,
        \"unitTranslationKey\": \"EC.COMMON.UNIT.KM_PER_MIN\"
      },
      \"chargingPower\": 6.58,
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
    \"chargingStatus\": \"ONGOING_TIMER\",
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
            \"latitude\": 53.365771,
            \"longitude\": -6.330550
          }
        }
      ]
    },
    \"errorInfo\": []
  }
  """.data(using: .utf8)!

// MARK: E-Mobility - AC Charging - Direct Charge

let kEmobilityACDirectChargingJson = """
  {
    \"batteryChargeStatus\": {
      \"plugState\": \"CONNECTED\",
      \"lockState\": \"LOCKED\",
      \"chargingState\": \"CHARGING\",
      \"chargingReason\": \"IMMEDIATE\",
      \"externalPowerSupplyState\": \"AVAILABLE\",
      \"ledColor\": \"GREEN\",
      \"ledState\": \"BLINK\",
      \"chargingMode\": \"AC\",
      \"stateOfChargeInPercentage\": 56,
      \"remainingChargeTimeUntil100PercentInMinutes\": 260,
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
        \"value\": 1.1,
        \"unit\": \"KM_PER_MIN\",
        \"valueInKmPerHour\": 66,
        \"unitTranslationKey\": \"EC.COMMON.UNIT.KM_PER_MIN\"
      },
      \"chargingPower\": 20.71,
      \"chargingInDCMode\": false
    },
    \"directCharge\": {
      \"disabled\": false,
      \"isActive\": true
    },
    \"directClimatisation\": {
      \"climatisationState\": \"OFF\",
      \"remainingClimatisationTime\": null
    },
    \"chargingStatus\": \"INSTANT_CHARGING\",
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
          \"SATURDAY\": true,
          \"FRIDAY\": true,
          \"WEDNESDAY\": true,
          \"TUESDAY\": true,
          \"MONDAY\": true,
          \"THURSDAY\": true,
          \"SUNDAY\": true
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
            \"latitude\": 53.365771,
            \"longitude\": -6.330550
          }
        }
      ]
    },
    \"errorInfo\": []
  }

  """.data(using: .utf8)!

// MARK: E-Mobility - DC Charging

let kEmobilityDCChargingJson = """
  {
    \"batteryChargeStatus\": {
      \"plugState\": \"CONNECTED\",
      \"lockState\": \"LOCKED\",
      \"chargingState\": \"CHARGING\",
      \"chargingReason\": \"IMMEDIATE\",
      \"externalPowerSupplyState\": \"UNAVAILABLE\",
      \"ledColor\": \"GREEN\",
      \"ledState\": \"BLINK\",
      \"chargingMode\": \"DC\",
      \"stateOfChargeInPercentage\": 56,
      \"remainingChargeTimeUntil100PercentInMinutes\": 122,
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
        \"value\": 3,
        \"unit\": \"KM_PER_MIN\",
        \"valueInKmPerHour\": 180,
        \"unitTranslationKey\": \"EC.COMMON.UNIT.KM_PER_MIN\"
      },
      \"chargingPower\": 48.56,
      \"chargingInDCMode\": true
    },
    \"directCharge\": {
      \"disabled\": true,
      \"isActive\": false
    },
    \"directClimatisation\": {
      \"climatisationState\": \"OFF\",
      \"remainingClimatisationTime\": null
    },
    \"chargingStatus\": \"INSTANT_CHARGING\",
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
          \"SATURDAY\": true,
          \"FRIDAY\": true,
          \"WEDNESDAY\": true,
          \"TUESDAY\": true,
          \"MONDAY\": true,
          \"THURSDAY\": true,
          \"SUNDAY\": true
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
            \"latitude\": 53.365771,
            \"longitude\": -6.330550
          }
        }
      ]
    },
    \"errorInfo\": []
  }
  """.data(using: .utf8)!
