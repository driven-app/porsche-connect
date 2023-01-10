import XCTest

@testable import PorscheConnect

final class StatusFormatterTests: XCTestCase {

  var formatter: StatusFormatter!
  override func setUp() {
    formatter = StatusFormatter()
  }

  override func tearDown() {
    formatter = nil
  }

  // MARK: - Defaults

  func testDefaultLocaleIsCurrent() {
    XCTAssertEqual(formatter.locale, .current)
  }

  // MARK: - Specific locales

  func testAmericanEnglishFormatting() {
    formatter.locale = Locale(identifier: "en_US")
    XCTAssertEqual(formatter.batteryLevel(from: templateStatus), "12%")
    XCTAssertEqual(formatter.mileage(from: templateStatus), "1,364 mi")
    XCTAssertEqual(formatter.electricalRange(from: templateStatus), "183 mi")
  }

  func testCanadianEnglishFormatting() {
    formatter.locale = Locale(identifier: "en_CA")
    XCTAssertEqual(formatter.batteryLevel(from: templateStatus), "12%")
    XCTAssertEqual(formatter.mileage(from: templateStatus), "2,195 km")
    XCTAssertEqual(formatter.electricalRange(from: templateStatus), "294 km")
  }

  func testUnitedKingdomEnglishFormatting() {
    formatter.locale = Locale(identifier: "en_GB")
    XCTAssertEqual(formatter.batteryLevel(from: templateStatus), "12%")
    XCTAssertEqual(formatter.mileage(from: templateStatus), "1,364 mi")
    XCTAssertEqual(formatter.electricalRange(from: templateStatus), "183 mi")
  }

  func testChineseFormatting() {
    formatter.locale = Locale(identifier: "zh_CN")
    XCTAssertEqual(formatter.batteryLevel(from: templateStatus), "12%")
    XCTAssertEqual(formatter.mileage(from: templateStatus), "2,195公里")
    XCTAssertEqual(formatter.electricalRange(from: templateStatus), "294公里")
  }

  func testGermanFormatting() {
    formatter.locale = Locale(identifier: "de_DE")
    XCTAssertEqual(formatter.batteryLevel(from: templateStatus), "12 %")
    XCTAssertEqual(formatter.mileage(from: templateStatus), "2.195 km")
    XCTAssertEqual(formatter.electricalRange(from: templateStatus), "294 km")
  }
}

private let templateStatus = Status(
  vin: "abc123",
  batteryLevel: Status.GenericValue(
    value: 12,
    unit: "PERCENT",
    unitTranslationKey: "GRAY_SLICE_UNIT_PERCENT",
    unitTranslationKeyV2: "TC.UNIT.PERCENT"),
  mileage: Status.Distance(
    value: 2195,
    unit: "KILOMETERS",
    originalValue: 2195,
    originalUnit: "KILOMETERS",
    valueInKilometers: 2195,
    unitTranslationKey: "GRAY_SLICE_UNIT_KILOMETER",
    unitTranslationKeyV2: "TC.UNIT.KILOMETER"),
  overallLockStatus: "CLOSED_LOCKED",
  serviceIntervals: Status.ServiceIntervals(
    oilService: Status.ServiceIntervals.OilService(),
    inspection: Status.ServiceIntervals.Inspection(
      distance: Status.Distance(
        value: -27842,
        unit: "KILOMETERS",
        originalValue: -27842,
        originalUnit: "KILOMETERS",
        valueInKilometers: -27842,
        unitTranslationKey: "GRAY_SLICE_UNIT_KILOMETER",
        unitTranslationKeyV2: "TC.UNIT.KILOMETER"
      ),
      time: Status.GenericValue(
        value: -710,
        unit: "DAYS",
        unitTranslationKey: "GRAY_SLICE_UNIT_DAY",
        unitTranslationKeyV2: "TC.UNIT.DAYS"
      )
    )
  ),
  remainingRanges: Status.RemainingRanges(
    conventionalRange: Status.RemainingRanges.Range(
      distance: nil,
      engineType: "UNSUPPORTED"
    ),
    electricalRange: Status.RemainingRanges.Range(
      distance: Status.Distance(
        value: 294,
        unit: "KILOMETERS",
        originalValue: 294,
        originalUnit: "KILOMETERS",
        valueInKilometers: 294,
        unitTranslationKey: "GRAY_SLICE_UNIT_KILOMETER",
        unitTranslationKeyV2: "TC.UNIT.KILOMETER"
      ),
      engineType: "ELECTRIC"
    )
  )
)
