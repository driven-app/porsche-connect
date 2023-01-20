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

// MARK: Long Term Trips

let kLongTermTripsInMetricJson = """
  [{
  \"type\" : \"LONG_TERM\",
  \"id\" : 1158728093,
  \"averageSpeed\" : {
    \"value\" : 39,
    \"unit\" : \"KMH\",
    \"valueInKmh\" : 39,
    \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KMH\",
    \"unitTranslationKeyV2\" : \"TC.UNIT.KMH\"
  },
  \"averageFuelConsumption\" : {
    \"value\" : 0,
    \"unit\" : \"LITERS_PER_100_KM\",
    \"valueInLitersPer100Km\" : 0,
    \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_LITERS_PER_100_KM\",
    \"unitTranslationKeyV2\" : \"TC.UNIT.LITERS_PER_100_KM\"
  },
  \"tripMileage\" : {
    \"value\" : 1448,
    \"unit\" : \"KILOMETERS\",
    \"originalValue\" : 1448,
    \"originalUnit\" : \"KILOMETERS\",
    \"valueInKilometers\" : 1448,
    \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\",
    \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\"
  },
  \"travelTime\" : 2279,
  \"startMileage\" : {
    \"value\" : -1,
    \"unit\" : \"KILOMETERS\",
    \"originalValue\" : -1,
    \"originalUnit\" : \"KILOMETERS\",
    \"valueInKilometers\" : -1,
    \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\",
    \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\"
  },
  \"endMileage\" : {
    \"value\" : 1448,
    \"unit\" : \"KILOMETERS\",
    \"originalValue\" : 1448,
    \"originalUnit\" : \"KILOMETERS\",
    \"valueInKilometers\" : 1448,
    \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\",
    \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\"
  },
  \"timestamp\" : \"2023-01-17T20:10:14Z\",
  \"zeroEmissionDistance\" : {
    \"value\" : 1448,
    \"unit\" : \"KILOMETERS\",
    \"originalValue\" : 1448,
    \"originalUnit\" : \"KILOMETERS\",
    \"valueInKilometers\" : 1448,
    \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\",
    \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\"
  },
  \"averageElectricEngineConsumption\" : {
    \"value\" : 29.9,
    \"unit\" : \"KWH_PER_100KM\",
    \"valueKwhPer100Km\" : 29.9,
    \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KWH_PER_100KM\",
    \"unitTranslationKeyV2\" : \"TC.UNIT.KWH_PER_100KM\"
  }
  }]
  """.data(using: .utf8)!

// MARK: Short Term Trips

let kShortTermTripsInMetricJson = """
  [{
    \"type\" : \"SHORT_TERM\",
    \"id\" : 1162572771,
    \"averageSpeed\" : {
      \"value\" : 11,
      \"unit\" : \"KMH\",
      \"valueInKmh\" : 11,
      \"unitTranslationKeyV2\" : \"TC.UNIT.KMH\",
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KMH\"
    },
    \"averageFuelConsumption\" : {
      \"value\" : 0,
      \"unit\" : \"LITERS_PER_100_KM\",
      \"valueInLitersPer100Km\" : 0,
      \"unitTranslationKeyV2\" : \"TC.UNIT.LITERS_PER_100_KM\",
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_LITERS_PER_100_KM\"
    },
    \"tripMileage\" : {
      \"value\" : 6,
      \"unit\" : \"KILOMETERS\",
      \"originalValue\" : 6,
      \"originalUnit\" : \"KILOMETERS\",
      \"valueInKilometers\" : 6,
      \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\",
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\"
    },
    \"travelTime\" : 31,
    \"startMileage\" : {
      \"value\" : 1442,
      \"unit\" : \"KILOMETERS\",
      \"originalValue\" : 1442,
      \"originalUnit\" : \"KILOMETERS\",
      \"valueInKilometers\" : 1442,
      \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\",
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\"
    },
    \"endMileage\" : {
      \"value\" : 1448,
      \"unit\" : \"KILOMETERS\",
      \"originalValue\" : 1448,
      \"originalUnit\" : \"KILOMETERS\",
      \"valueInKilometers\" : 1448,
      \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\",
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\"
    },
    \"timestamp\" : \"2023-01-17T20:10:14Z\",
    \"zeroEmissionDistance\" : {
      \"value\" : 6,
      \"unit\" : \"KILOMETERS\",
      \"originalValue\" : 6,
      \"originalUnit\" : \"KILOMETERS\",
      \"valueInKilometers\" : 6,
      \"unitTranslationKeyV2\" : \"TC.UNIT.KILOMETER\",
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KILOMETER\"
    },
    \"averageElectricEngineConsumption\" : {
      \"value\" : 39.6,
      \"unit\" : \"KWH_PER_100KM\",
      \"valueKwhPer100Km\" : 39.6,
      \"unitTranslationKeyV2\" : \"TC.UNIT.KWH_PER_100KM\",
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KWH_PER_100KM\"
    }
  }]
  """.data(using: .utf8)!

let kShortTermTripsInImperialJson = """
  [{
    \"type\" : \"SHORT_TERM\",
    \"id\" : 1162658714,
    \"averageSpeed\" : {
      \"value\" : 44.11735,
      \"unit\" : \"MPH\",
      \"valueInKmh\" : 70.99999,
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_MPH\",
      \"unitTranslationKeyV2\" : \"TC.UNIT.MPH\"
    },
    \"averageFuelConsumption\" : {
      \"value\" : 0,
      \"unit\" : \"MILES_PER_GALLON_US\",
      \"valueInLitersPer100Km\" : 0,
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_MILES_PER_GALLON_US\",
      \"unitTranslationKeyV2\" : \"TC.UNIT.MILES_PER_GALLON_US\"
    },
    \"tripMileage\" : {
      \"value\" : 17.39839,
      \"unit\" : \"MILES\",
      \"originalValue\" : 28,
      \"originalUnit\" : \"KILOMETERS\",
      \"valueInKilometers\" : 28,
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_MILES\",
      \"unitTranslationKeyV2\" : \"TC.UNIT.MILES\"
    },
    \"travelTime\" : 24,
    \"startMileage\" : {
      \"value\" : 14781.8,
      \"unit\" : \"MILES\",
      \"originalValue\" : 23789,
      \"originalUnit\" : \"KILOMETERS\",
      \"valueInKilometers\" : 23789,
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_MILES\",
      \"unitTranslationKeyV2\" : \"TC.UNIT.MILES\"
    },
    \"endMileage\" : {
      \"value\" : 14799.2,
      \"unit\" : \"MILES\",
      \"originalValue\" : 23817,
      \"originalUnit\" : \"KILOMETERS\",
      \"valueInKilometers\" : 23817,
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_MILES\",
      \"unitTranslationKeyV2\" : \"TC.UNIT.MILES\"
    },
    \"timestamp\" : \"2023-01-17T20:58:58Z\",
    \"zeroEmissionDistance\" : {
      \"value\" : 17.39839,
      \"unit\" : \"MILES\",
      \"originalValue\" : 28,
      \"originalUnit\" : \"KILOMETERS\",
      \"valueInKilometers\" : 28,
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_MILES\",
      \"unitTranslationKeyV2\" : \"TC.UNIT.MILES\"
    },
    \"averageElectricEngineConsumption\" : {
      \"value\" : 0.3250875,
      \"unit\" : \"KWH_PER_MILE\",
      \"valueKwhPer100Km\" : 20.2,
      \"unitTranslationKey\" : \"GRAY_SLICE_UNIT_KWH_PER_MILE\",
      \"unitTranslationKeyV2\" : \"TC.UNIT.KWH_PER_MILE\"
    }
  }]
  """.data(using: .utf8)!


let kMaintenanceItemsJson = """
{
  \"data\" : [ {
    \"id\" : \"0003\",
    \"description\" : {
      \"shortName\" : \"Service\",
      \"longName\" : null,
      \"criticalityText\" : \"No service is due at the moment.\",
      \"notificationText\" : null
    },
    \"criticality\" : 1,
    \"remainingLifeTimeInDays\" : null,
    \"remainingLifeTimePercentage\" : null,
    \"remainingLifeTimeInKm\" : null,
    \"values\" : {
      \"modelName\" : \"Service-Intervall\",
      \"odometerLastReset\" : \"0\",
      \"modelVisibilityState\" : \"visible\",
      \"WarnID100\" : \"0\",
      \"modelId\" : \"0003\",
      \"modelState\" : \"active\",
      \"criticality\" : \"1\",
      \"timestampLastReset\" : \"1999-11-30T00:00:00\",
      \"WarnID99\" : \"0\",
      \"source\" : \"Vehicle\",
      \"event\" : \"CYCLIC\"
    }
  }, {
    \"id\" : \"0005\",
    \"description\" : {
      \"shortName\" : \"Brake pads\",
      \"longName\" : \"Changing the brake pads\",
      \"criticalityText\" : \"No service is due at the moment.\",
      \"notificationText\" : null
    },
    \"criticality\" : 1,
    \"remainingLifeTimeInDays\" : null,
    \"remainingLifeTimePercentage\" : null,
    \"remainingLifeTimeInKm\" : null,
    \"values\" : {
      \"modelName\" : \"Service Bremse\",
      \"odometerLastReset\" : \"0\",
      \"modelVisibilityState\" : \"visible\",
      \"modelId\" : \"0005\",
      \"modelState\" : \"active\",
      \"criticality\" : \"1\",
      \"timestampLastReset\" : \"2022-12-08T17:20:05\",
      \"source\" : \"Vehicle\",
      \"event\" : \"CYCLIC\",
      \"WarnID26\" : \"0\"
    }
  }],
  \"serviceAccess\" : {
    \"access\" : true
  }
}
""".data(using: .utf8)!
