import XCTest

@testable import PorscheConnect

final class TimestampFormatterTests: XCTestCase {

  let timestamp = ISO8601DateFormatter().date(from: "2023-01-17T20:58:30Z")!

  func testFormatterIrelandLocale() {
    let formatter = TimestampFormatter()
    formatter.locale = Locale(identifier: "en_IE")
    formatter.timeZone = .init(abbreviation: "GMT")!
    XCTAssertEqual("17 Jan 2023 at 20:58:30", formatter.formatted(from: timestamp))
  }

  func testFormatterUnitedStatesLocale() {
    let formatter = TimestampFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.timeZone = .init(abbreviation: "GMT")!
    XCTAssertEqual("Jan 17, 2023 at 8:58:30 PM", formatter.formatted(from: timestamp))
  }

  func testFormatterGermanyLocale() {
    let formatter = TimestampFormatter()
    formatter.locale = Locale(identifier: "de_DE")
    formatter.timeZone = .init(abbreviation: "GMT")!
    XCTAssertEqual("17.01.2023, 20:58:30", formatter.formatted(from: timestamp))
  }

  func testFormatterChinaLocale() {
    let formatter = TimestampFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.timeZone = .init(abbreviation: "GMT")!
    XCTAssertEqual("2023年1月17日 20:58:30", formatter.formatted(from: timestamp))
  }
}

