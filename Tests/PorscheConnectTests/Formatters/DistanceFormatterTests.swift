import XCTest

@testable import PorscheConnect

final class DistanceFormatterTests: XCTestCase {

  var formatter: DistanceFormatter!
  override func setUp() {
    formatter = DistanceFormatter()
  }

  override func tearDown() {
    formatter = nil
  }

  // MARK: - Defaults

  func testDefaultLocaleIsCurrent() {
    XCTAssertEqual(formatter.locale, .current)
  }

  // MARK: - Specific locales

  private let typicalMileage = Distance(
    value: 2195,
    unit: .kilometers,
    originalValue: 2195,
    originalUnit: .kilometers,
    valueInKilometers: 2195,
    unitTranslationKey: "GRAY_SLICE_UNIT_KILOMETER",
    unitTranslationKeyV2: "TC.UNIT.KILOMETER"
  )

  func testAmericanEnglishFormatting() {
    formatter.locale = Locale(identifier: "en_US")
    XCTAssertEqual(formatter.string(from: typicalMileage), "1,364 mi")
  }

  func testCanadianEnglishFormatting() {
    formatter.locale = Locale(identifier: "en_CA")
    XCTAssertEqual(formatter.string(from: typicalMileage), "2,195 km")
  }

  func testUnitedKingdomEnglishFormatting() {
    formatter.locale = Locale(identifier: "en_GB")
    XCTAssertEqual(formatter.string(from: typicalMileage), "1,364 mi")
  }

  func testChineseFormatting() {
    formatter.locale = Locale(identifier: "zh_CN")
    XCTAssertEqual(formatter.string(from: typicalMileage), "2,195公里")
  }

  func testGermanFormatting() {
    formatter.locale = Locale(identifier: "de_DE")
    XCTAssertEqual(formatter.string(from: typicalMileage), "2.195 km")
  }
}
