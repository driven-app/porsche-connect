import XCTest

@testable import PorscheConnect

final class ModelsSummaryTests: XCTestCase {

  // MARK: - Summary tests

  func testSummaryConstruction() {
    let summary = Summary(modelDescription: "A model description", nickName: nil)
    XCTAssertNotNil(summary)
    XCTAssertNil(summary.nickName)
  }

  func testSummaryDecodingJsonIntoModel() {
    let json = "{\n \"modelDescription\": \"Taycan 4S\", \n \"nickName\": \"211-D-12345\"}".data(
      using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    let summary = try! decoder.decode(Summary.self, from: json)
    XCTAssertNotNil(summary)
    XCTAssertEqual("Taycan 4S", summary.modelDescription)
    XCTAssertEqual("211-D-12345", summary.nickName!)
  }

  func testSummaryDecodingJsonIntoModelWithNoNickname() {
    let json = "{\"modelDescription\": \"Taycan 4S\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    let summary = try! decoder.decode(Summary.self, from: json)
    XCTAssertNotNil(summary)
    XCTAssertEqual("Taycan 4S", summary.modelDescription)
    XCTAssertNil(summary.nickName)
  }
}
