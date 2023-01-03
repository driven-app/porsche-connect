import XCTest

@testable import PorscheConnect

final class ModelsCapabilitiesTests: XCTestCase {

  // MARK: - Capabilities tests

  func testCapabilitiesConstruction() {
    let capabilities = Capabilities(engineType: "Test Engine Type", carModel: "Test Car Model")
    XCTAssertEqual("Test Engine Type", capabilities.engineType)
    XCTAssertEqual("Test Car Model", capabilities.carModel)
    XCTAssertFalse(capabilities.displayParkingBrake)
    XCTAssertFalse(capabilities.needsSPIN)
    XCTAssertFalse(capabilities.hasRDK)
    XCTAssertFalse(capabilities.hasHonkAndFlash)
    XCTAssertTrue(capabilities.onlineRemoteUpdateStatus.active)
    XCTAssertTrue(capabilities.onlineRemoteUpdateStatus.editableByUser)
    XCTAssertTrue(capabilities.heatingCapabilities.frontSeatHeatingAvailable)
    XCTAssertFalse(capabilities.heatingCapabilities.rearSeatHeatingAvailable)
  }

  func testCapabilitiesDecodingJsonIntoModel() {
    let capabilities = buildCapabilites()

    XCTAssertNotNil(capabilities)
    XCTAssertNotNil(capabilities.heatingCapabilities)
    XCTAssertNotNil(capabilities.onlineRemoteUpdateStatus)
    XCTAssertTrue(capabilities.displayParkingBrake)
    XCTAssertTrue(capabilities.needsSPIN)
    XCTAssertTrue(capabilities.hasRDK)
    XCTAssertEqual("BEV", capabilities.engineType)
    XCTAssertEqual("J1", capabilities.carModel)
    XCTAssertTrue(capabilities.onlineRemoteUpdateStatus.editableByUser)
    XCTAssertTrue(capabilities.onlineRemoteUpdateStatus.active)
    XCTAssertTrue(capabilities.heatingCapabilities.frontSeatHeatingAvailable)
    XCTAssertFalse(capabilities.heatingCapabilities.rearSeatHeatingAvailable)
    XCTAssertEqual("RIGHT", capabilities.steeringWheelPosition)
    XCTAssertTrue(capabilities.hasHonkAndFlash)
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

// MARK: - Helper Functions

func buildCapabilites() -> Capabilities {
  let json =
    "{\"displayParkingBrake\": true, \"needsSPIN\": true, \"hasRDK\": true, \"engineType\": \"BEV\", \"carModel\": \"J1\", \"onlineRemoteUpdateStatus\": {\"editableByUser\": true, \"active\": true }, \"heatingCapabilities\": {\"frontSeatHeatingAvailable\": true, \"rearSeatHeatingAvailable\": false}, \"steeringWheelPosition\": \"RIGHT\", \"hasHonkAndFlash\": true }"
    .data(using: .utf8)!
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .useDefaultKeys
  return try! decoder.decode(Capabilities.self, from: json)
}
