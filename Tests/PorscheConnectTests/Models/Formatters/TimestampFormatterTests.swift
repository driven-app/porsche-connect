import XCTest

@testable import PorscheConnect

final class TimestampFormatterTests: XCTestCase {
 
  let timestamp = ISO8601DateFormatter().date(from: "2023-01-17T20:58:30Z")!
  
  func testFormatterIrelandLocale() {
    let formatter = TimestampFormatter(timestamp: timestamp, locale: Locale(identifier: "en_IE"))
    XCTAssertEqual("17 Jan 2023 at 20:58:30", formatter.formatted())
  }
  
  func testFormatterUnitedStatesLocale() {
    let formatter = TimestampFormatter(timestamp: timestamp, locale: Locale(identifier: "en_US"))
    XCTAssertEqual("Jan 17, 2023 at 8:58:30 PM", formatter.formatted())
  }
  
  func testFormatterGermanyLocale() {
    let formatter = TimestampFormatter(timestamp: timestamp, locale: Locale(identifier: "de_DE"))
    XCTAssertEqual("17.01.2023, 20:58:30", formatter.formatted())
  }
  
  func testFormatterChinaLocale() {
    let formatter = TimestampFormatter(timestamp: timestamp, locale: Locale(identifier: "zh_CN"))
    XCTAssertEqual("2023年1月17日 20:58:30", formatter.formatted())
  }
}
