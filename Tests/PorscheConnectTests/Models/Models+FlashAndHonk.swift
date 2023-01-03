import XCTest

@testable import PorscheConnect

final class ModelsFlashAndHonkTests: XCTestCase {

  // MARK: - Flash & Honk

  func testFlashDecodingJsonIntoModel() {
    let remoteCommandAccepted = buildRemoteCommandAccepted()

    XCTAssertNotNil(remoteCommandAccepted)
    XCTAssertEqual("2119999", remoteCommandAccepted.identifier)
    XCTAssertEqual("2119999", remoteCommandAccepted.id)
    XCTAssertNil(remoteCommandAccepted.requestId)
    XCTAssertNil(remoteCommandAccepted.vin)
    XCTAssertEqual(
      ISO8601DateFormatter().date(from: "2022-12-27T13:19:23Z"), remoteCommandAccepted.lastUpdated)
  }

  // MARK: - Private functions

  private func buildRemoteCommandAccepted() -> RemoteCommandAccepted {
    let json = "{\"id\" : \"2119999\", \"lastUpdated\" : \"2022-12-27T13:19:23Z\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601

    return try! decoder.decode(RemoteCommandAccepted.self, from: json)
  }
}
