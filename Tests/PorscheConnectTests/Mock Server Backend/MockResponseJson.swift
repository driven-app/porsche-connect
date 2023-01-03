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

// MARK: Overview

let kOverviewJson = """
  {
    \"vin\" : \"WP0ZZZY4MSA38703\",
    \"oilLevel\" : null,
    \"fuelLevel\" : null,
    \"batteryLevel\" : {
      \"value\" : 51,
      \"unit\" : \"PERCENT\",
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_PERCENT\",
      \"unitTranslationKeyV2\" : \"TC.UNIT.PERCENT\"
    },
    \"remainingRanges\" : {
      \"conventionalRange\" : {
        \"distance\" : null,
        \"engineType\" : \"UNSUPPORTED\",
        \"isPrimary\" : false
      },
      \"electricalRange\" : {
        \"distance\" : {
          \"value\" : 193,
          \"unit\" : \"KILOMETERS\",
          \"originalValue\" : 193,
          \"originalUnit\" : \"KILOMETERS\",
          \"valueInKilometers\" : 193,
          \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\",
          \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\"
        },
        \"engineType\" : \"ELECTRIC\",
        \"isPrimary\" : true
      }
    },
    \"mileage\" : {
      \"value\" : 50819,
      \"unit\" : \"KILOMETERS\",
      \"originalValue\" : 50819,
      \"originalUnit\" : \"KILOMETERS\",
      \"valueInKilometers\" : 50819,
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\",
      \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\"
    },
    \"parkingLight\" : \"OFF\",
    \"parkingLightStatus\" : null,
    \"parkingBreak\" : \"ACTIVE\",
    \"parkingBreakStatus\" : null,
    \"doors\" : {
      \"frontLeft\" : \"CLOSED_LOCKED\",
      \"frontRight\" : \"CLOSED_LOCKED\",
      \"backLeft\" : \"CLOSED_LOCKED\",
      \"backRight\" : \"CLOSED_LOCKED\",
      \"frontTrunk\" : \"CLOSED_UNLOCKED\",
      \"backTrunk\" : \"CLOSED_LOCKED\",
      \"overallLockStatus\" : \"CLOSED_LOCKED\"
    },
    \"serviceIntervals\" : {
      \"oilService\" : {
        \"distance\" : null,
        \"time\" : null
      },
      \"inspection\" : {
        \"distance\" : {
          \"value\" : 0,
          \"unit\" : \"KILOMETERS\",
          \"originalValue\" : 0,
          \"originalUnit\" : \"KILOMETERS\",
          \"valueInKilometers\" : 0,
          \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\",
          \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\"
        },
        \"time\" : {
          \"value\" : 2,
          \"unit\" : \"DAYS\",
          \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_DAY\",
          \"unitTranslationKeyV2\" : \"TC.UNIT.DAYS\"
        }
      }
    },
    \"tires\" : {
      \"frontLeft\" : {
        \"currentPressure\" : null,
        \"optimalPressure\" : null,
        \"differencePressure\" : null,
        \"tirePressureDifferenceStatus\" : \"UNKNOWN\"
      },
      \"frontRight\" : {
        \"currentPressure\" : null,
        \"optimalPressure\" : null,
        \"differencePressure\" : null,
        \"tirePressureDifferenceStatus\" : \"UNKNOWN\"
      },
      \"backLeft\" : {
        \"currentPressure\" : null,
        \"optimalPressure\" : null,
        \"differencePressure\" : null,
        \"tirePressureDifferenceStatus\" : \"UNKNOWN\"
      },
      \"backRight\" : {
        \"currentPressure\" : null,
        \"optimalPressure\" : null,
        \"differencePressure\" : null,
        \"tirePressureDifferenceStatus\" : \"UNKNOWN\"
      }
    },
    \"windows\" : {
      \"frontLeft\" : \"CLOSED\",
      \"frontRight\" : \"CLOSED\",
      \"backLeft\" : \"CLOSED\",
      \"backRight\" : \"CLOSED\",
      \"roof\" : \"UNSUPPORTED\",
      \"maintenanceHatch\" : \"UNSUPPORTED\",
      \"sunroof\" : {
        \"status\" : \"UNSUPPORTED\",
        \"positionInPercent\" : null
      }
    },
    \"parkingTime\" : \"30.12.2022 17:39:59\",
    \"overallOpenStatus\" : \"CLOSED\"
  }
  """.data(using: .utf8)!
