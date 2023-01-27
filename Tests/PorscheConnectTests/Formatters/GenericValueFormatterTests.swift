import XCTest

@testable import PorscheConnect

final class GenericValueFormatterTests: XCTestCase {

  var formatter: GenericValueFormatter!
  override func setUp() {
    formatter = GenericValueFormatter(date: DateComponents(calendar: Calendar(identifier: .gregorian),
                                                           timeZone: .init(abbreviation: "GMT"),
                                                           year: 2023,
                                                           month: 1,
                                                           day: 26,
                                                           hour: 0,
                                                           minute: 0,
                                                           second: 0).date!)
    formatter.timeZone = .init(abbreviation: "GMT")!
  }
  
  override func tearDown() {
    formatter = nil
  }
  
  // MARK: - Defaults

  func testDefaultLocaleIsCurrent() {
    XCTAssertEqual(formatter.locale, .current)
  }

  // MARK: - Specific locales

  private let typicalBatteryPercentage = GenericValue(
    value: 12,
    unit: "PERCENT",
    unitTranslationKey: "GRAY_SLICE_UNIT_PERCENT",
    unitTranslationKeyV2: "TC.UNIT.PERCENT"
  )
  private let typicalDaysRemaining = GenericValue(
    value: -710,
    unit: "DAYS",
    unitTranslationKey: "GRAY_SLICE_UNIT_DAY",
    unitTranslationKeyV2: "TC.UNIT.DAYS"
  )

  func testAmericanEnglishFormatting() {
    formatter.locale = Locale(identifier: "en_US")
    XCTAssertEqual(formatter.string(from: typicalBatteryPercentage, scalar: 0.01), "12%")
    XCTAssertEqual(formatter.string(from: typicalDaysRemaining, scalar: -1), "Jan 5, 2025")
  }

  func testCanadianEnglishFormatting() {
    formatter.locale = Locale(identifier: "en_CA")
    XCTAssertEqual(formatter.string(from: typicalBatteryPercentage, scalar: 0.01), "12%")
    XCTAssertEqual(formatter.string(from: typicalDaysRemaining, scalar: -1), "Jan 5, 2025")
  }

  func testUnitedKingdomEnglishFormatting() {
    formatter.locale = Locale(identifier: "en_GB")
    XCTAssertEqual(formatter.string(from: typicalBatteryPercentage, scalar: 0.01), "12%")
    XCTAssertEqual(formatter.string(from: typicalDaysRemaining, scalar: -1), "5 Jan 2025")
  }

  func testChineseFormatting() {
    formatter.locale = Locale(identifier: "zh_CN")
    XCTAssertEqual(formatter.string(from: typicalBatteryPercentage, scalar: 0.01), "12%")
    XCTAssertEqual(formatter.string(from: typicalDaysRemaining, scalar: -1), "2025年1月5日")
  }

  func testGermanFormatting() {
    formatter.locale = Locale(identifier: "de_DE")
    XCTAssertEqual(formatter.string(from: typicalBatteryPercentage, scalar: 0.01), "12 %")
    XCTAssertEqual(formatter.string(from: typicalDaysRemaining, scalar: -1), "05.01.2025")
  }
}
