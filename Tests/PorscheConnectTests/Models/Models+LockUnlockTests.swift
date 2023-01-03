import XCTest

@testable import PorscheConnect

final class ModelsLockUnlockTests: XCTestCase {

  // MARK: – Lock Vehicle

  func testLockVehicleDecodingJsonIntoModel() {
    let remoteCommandAccepted = buildRemoteCommandAccepted()

    XCTAssertNotNil(remoteCommandAccepted)
    XCTAssertEqual("2119999", remoteCommandAccepted.identifier)
    XCTAssertEqual("2119999", remoteCommandAccepted.requestId)
    XCTAssertEqual("WP0ZZZY4MSA38703", remoteCommandAccepted.vin)
    XCTAssertNil(remoteCommandAccepted.id)
    XCTAssertNil(remoteCommandAccepted.lastUpdated)
  }

  // MARK: – Unlock Vehicle

  func testUnlockVehicleDecodingJsonIntoModel() {
    let remoteCommandAccepted = buildRemoteCommandAccepted()

    XCTAssertNotNil(remoteCommandAccepted)
    XCTAssertEqual("2119999", remoteCommandAccepted.identifier)
    XCTAssertEqual("2119999", remoteCommandAccepted.requestId)
    XCTAssertEqual("WP0ZZZY4MSA38703", remoteCommandAccepted.vin)
    XCTAssertNil(remoteCommandAccepted.id)
    XCTAssertNil(remoteCommandAccepted.lastUpdated)
  }

  // MARK: - Private functions

  private func buildRemoteCommandAccepted() -> RemoteCommandAccepted {
    let json = "{\"requestId\" : \"2119999\", \"vin\" : \"WP0ZZZY4MSA38703\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601

    return try! decoder.decode(RemoteCommandAccepted.self, from: json)
  }
}
