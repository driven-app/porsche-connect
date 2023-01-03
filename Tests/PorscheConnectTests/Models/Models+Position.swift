import XCTest

@testable import PorscheConnect

final class ModelsPositionTests: XCTestCase {

  // MARK: - Position tests

  func testPositionDecodingJsonIntoModel() {
    let position = buildPosition()

    XCTAssertNotNil(position)
    XCTAssertNotNil(position.carCoordinate)
    XCTAssertEqual(53.365771, position.carCoordinate.latitude)
    XCTAssertEqual(-6.330550, position.carCoordinate.longitude)
    XCTAssertEqual(68, position.heading)
  }

  // MARK: - Private functions

  private func buildPosition() -> Position {
    let json =
      "{\"carCoordinate\": {\"geoCoordinateSystem\": \"WGS84\",\"latitude\": 53.365771, \"longitude\": -6.330550}, \"heading\": 68}"
      .data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(Position.self, from: json)
  }
}
