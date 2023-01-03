import XCTest

@testable import PorscheConnect

final class ModelsOverviewTests: XCTestCase {

  // MARK: - Overview

  func testOverviewDecodingJsonIntoModel() {
    let overview = buildOverview()

    XCTAssertNotNil(overview)
    XCTAssertEqual("WP0ZZZY4MSA38703", overview.vin)
    XCTAssertEqual(Overview.OpenStatus.closed, overview.overallOpenStatus)
  }

  // MARK: - Private functions

  private func buildOverview() -> Overview {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601

    return try! decoder.decode(Overview.self, from: kOverviewJson)
  }
}

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
