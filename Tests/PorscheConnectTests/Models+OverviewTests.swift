import XCTest

@testable import PorscheConnect

final class ModelsOverviewTests: XCTestCase {

  // MARK: - Overview

  func testOverviewDecodingJsonIntoModel() {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.YYYY HH:mm:ss"
    let overview = buildOverview()

    XCTAssertNotNil(overview)
    XCTAssertEqual("WP0ZZZY4MSA38703", overview.vin)

    XCTAssertNotNil(overview.batteryLevel)
    XCTAssertEqual(51, overview.batteryLevel!.value)
    XCTAssertEqual("PERCENT", overview.batteryLevel!.unit)
    XCTAssertEqual("GRAY_SLICE_UNIT_PERCENT", overview.batteryLevel!.unitTranslationKey)
    XCTAssertEqual("TC.UNIT.PERCENT", overview.batteryLevel!.unitTranslationKeyV2)

    XCTAssertNotNil(overview.remainingRanges)
    XCTAssertNotNil(overview.remainingRanges.electricalRange)
    XCTAssertEqual(Overview.ElectricalRange.EngineType.electric, overview.remainingRanges.electricalRange.engineType)
    XCTAssertTrue(overview.remainingRanges.electricalRange.isPrimary)

    XCTAssertNotNil(overview.remainingRanges.electricalRange.distance)
    XCTAssertEqual(193, overview.remainingRanges.electricalRange.distance!.value)
    XCTAssertEqual("KILOMETERS", overview.remainingRanges.electricalRange.distance!.unit)
    XCTAssertEqual(193, overview.remainingRanges.electricalRange.distance!.originalValue)
    XCTAssertEqual("KILOMETERS", overview.remainingRanges.electricalRange.distance!.originalUnit)
    XCTAssertEqual(193, overview.remainingRanges.electricalRange.distance!.valueInKilometers)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", overview.remainingRanges.electricalRange.distance!.unitTranslationKey)
    XCTAssertEqual("TC.UNIT.KILOMETER", overview.remainingRanges.electricalRange.distance!.unitTranslationKeyV2)

    XCTAssertNotNil(overview.mileage)
    XCTAssertEqual(50819, overview.mileage.value)
    XCTAssertEqual("KILOMETERS", overview.mileage.unit)
    XCTAssertEqual(50819, overview.mileage.originalValue)
    XCTAssertEqual("KILOMETERS", overview.mileage.originalUnit)
    XCTAssertEqual(50819, overview.mileage.valueInKilometers)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", overview.mileage.unitTranslationKey)
    XCTAssertEqual("TC.UNIT.KILOMETER", overview.mileage.unitTranslationKeyV2)

    XCTAssertEqual(Overview.ParkingLight.off, overview.parkingLight)

    XCTAssertNotNil(overview.serviceIntervals)
    XCTAssertNotNil(overview.serviceIntervals.inspection)
    XCTAssertNotNil(overview.serviceIntervals.inspection.distance)
    XCTAssertEqual(0, overview.serviceIntervals.inspection.distance!.value)
    XCTAssertEqual("KILOMETERS", overview.serviceIntervals.inspection.distance!.unit)
    XCTAssertEqual(0, overview.serviceIntervals.inspection.distance!.originalValue)
    XCTAssertEqual("KILOMETERS", overview.serviceIntervals.inspection.distance!.originalUnit)
    XCTAssertEqual(0, overview.serviceIntervals.inspection.distance!.valueInKilometers)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", overview.serviceIntervals.inspection.distance!.unitTranslationKey)
    XCTAssertEqual("TC.UNIT.KILOMETER", overview.serviceIntervals.inspection.distance!.unitTranslationKeyV2)

    XCTAssertNotNil(overview.serviceIntervals.inspection.time)
    XCTAssertEqual(2, overview.serviceIntervals.inspection.time!.value)
    XCTAssertEqual("DAYS", overview.serviceIntervals.inspection.time!.unit)
    XCTAssertEqual("GRAY_SLICE_UNIT_DAY", overview.serviceIntervals.inspection.time!.unitTranslationKey)
    XCTAssertEqual("TC.UNIT.DAYS", overview.serviceIntervals.inspection.time!.unitTranslationKeyV2)

    XCTAssertNotNil(overview.tires)
    XCTAssertNotNil(overview.tires.frontLeft)
    XCTAssertNil(overview.tires.frontLeft.currentPressure)
    XCTAssertNil(overview.tires.frontLeft.differencePressure)
    XCTAssertNil(overview.tires.frontLeft.optimalPressure)
    XCTAssertEqual(Overview.Tires.TirePressure.DifferenceStatus.unknown, overview.tires.frontLeft.tirePressureDifferenceStatus)

    XCTAssertNotNil(overview.tires.frontRight)
    XCTAssertNil(overview.tires.frontRight.currentPressure)
    XCTAssertNil(overview.tires.frontRight.differencePressure)
    XCTAssertNil(overview.tires.frontRight.optimalPressure)
    XCTAssertEqual(Overview.Tires.TirePressure.DifferenceStatus.unknown, overview.tires.frontRight.tirePressureDifferenceStatus)

    XCTAssertNotNil(overview.tires.backLeft)
    XCTAssertNil(overview.tires.backLeft.currentPressure)
    XCTAssertNil(overview.tires.backLeft.differencePressure)
    XCTAssertNil(overview.tires.backLeft.optimalPressure)
    XCTAssertEqual(Overview.Tires.TirePressure.DifferenceStatus.unknown, overview.tires.backLeft.tirePressureDifferenceStatus)

    XCTAssertNotNil(overview.tires.backRight)
    XCTAssertNil(overview.tires.backRight.currentPressure)
    XCTAssertNil(overview.tires.backRight.differencePressure)
    XCTAssertNil(overview.tires.backRight.optimalPressure)
    XCTAssertEqual(Overview.Tires.TirePressure.DifferenceStatus.unknown, overview.tires.backRight.tirePressureDifferenceStatus)

    XCTAssertNotNil(overview.windows)
    XCTAssertEqual(Overview.PhysicalStatus.closed, overview.windows.frontRight)
    XCTAssertEqual(Overview.PhysicalStatus.closed, overview.windows.frontLeft)
    XCTAssertEqual(Overview.PhysicalStatus.closed, overview.windows.backRight)
    XCTAssertEqual(Overview.PhysicalStatus.closed, overview.windows.backLeft)
    XCTAssertEqual(Overview.PhysicalStatus.unsupported, overview.windows.roof)
    XCTAssertEqual(Overview.PhysicalStatus.unsupported, overview.windows.maintenanceHatch)

    XCTAssertNotNil(overview.windows.sunroof)
    XCTAssertEqual(Overview.PhysicalStatus.unsupported, overview.windows.sunroof.status)
    XCTAssertNil(overview.windows.sunroof.positionInPercent)

    XCTAssertEqual(formatter.date(from: "30.12.2022 17:39:59"), overview.parkingTime)
    XCTAssertEqual(Overview.PhysicalStatus.closed, overview.overallOpenStatus)
  }

  // MARK: - Private functions

  private func buildOverview() -> Overview {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.YYYY HH:mm:ss" // example: 30.12.2022 17:39:59

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .formatted(formatter)

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
