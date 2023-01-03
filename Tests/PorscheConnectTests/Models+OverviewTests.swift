import XCTest

@testable import PorscheConnect

final class ModelsOverviewTests: XCTestCase {

  // MARK: - Overview

  func testOverviewDecodingJsonIntoModel() {
    let overview = buildOverview()

    XCTAssertNotNil(overview)
    XCTAssertEqual("WP0ZZZY4MSA38703", overview.vin)
    XCTAssertEqual(Overview.OverallOpenStatus.CLOSED, overview.overallOpenStatus)
  }

  // MARK: - Private functions

  private func buildOverview() -> Overview {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601

    return try! decoder.decode(Overview.self, from: kOverviewJson)
  }
}
