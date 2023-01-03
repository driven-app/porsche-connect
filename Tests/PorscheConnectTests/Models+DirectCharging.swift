import XCTest

@testable import PorscheConnect

final class ModelsDirectChargingTests: XCTestCase {

  // MARK: – Direct Charging

  func testDirectChargingDecodingJsonIntoModel() {
    let remoteCommandAccepted = buildRemoteCommandAccepted()

    XCTAssertNotNil(remoteCommandAccepted)
    XCTAssertEqual("2119999", remoteCommandAccepted.identifier)
    XCTAssertEqual("2119999", remoteCommandAccepted.requestId)
    XCTAssertNil(remoteCommandAccepted.id)
    XCTAssertNil(remoteCommandAccepted.lastUpdated)
    XCTAssertNil(remoteCommandAccepted.vin)
  }

  // MARK: - Private functions

  private func buildRemoteCommandAccepted() -> RemoteCommandAccepted {
    let json = "{\"requestId\" : \"2119999\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601

    return try! decoder.decode(RemoteCommandAccepted.self, from: json)
  }
}
