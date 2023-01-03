import XCTest

@testable import PorscheConnect

final class ModelsRemoteCommandAcceptedTests: XCTestCase {
  
  // MARK: – Remote Command Status

  func testRemoteCommandStatusInProgress() {
    let remoteCommandStatus = buildRemoteCommandStatusInProgress()

    XCTAssertNotNil(remoteCommandStatus)
    XCTAssertEqual("IN_PROGRESS", remoteCommandStatus.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, remoteCommandStatus.remoteStatus)
  }

  func testRemoteCommandStatusSuccess() {
    let remoteCommandStatus = buildRemoteCommandStatusInSuccess()

    XCTAssertNotNil(remoteCommandStatus)
    XCTAssertEqual("SUCCESS", remoteCommandStatus.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, remoteCommandStatus.remoteStatus)
  }

  func testRemoteCommandStatusUnknown() {
    let remoteCommandStatus = buildRemoteCommandStatusInUnknown()

    XCTAssertNotNil(remoteCommandStatus)
    XCTAssertNil(remoteCommandStatus.remoteStatus)
  }

  func testUnlockRemoteCommandSecurityTimeout() {
    let remoteCommandStatus = buildUnlockRemoteCommandSecurityTimeout()

    XCTAssertNotNil(remoteCommandStatus)
    XCTAssertNil(remoteCommandStatus.id)
    XCTAssertNil(remoteCommandStatus.requestId)
    XCTAssertNil(remoteCommandStatus.vin)
    XCTAssertNil(remoteCommandStatus.lastUpdated)
    XCTAssertNil(remoteCommandStatus.remoteCommand)
    XCTAssertNil(remoteCommandStatus.pcckErrorMessage)
    XCTAssertNil(remoteCommandStatus.pcckErrorCode)
    XCTAssert((remoteCommandStatus.pcckIsBusinessError != nil) && remoteCommandStatus.pcckIsBusinessError!)
    XCTAssertEqual(RemoteCommandAccepted.PcckErrorKey.lockedFor60Minutes, remoteCommandStatus.pcckErrorKey)
    XCTAssert(remoteCommandStatus.pcckErrorKey != nil && remoteCommandStatus.pcckErrorKey == .lockedFor60Minutes)
  }

  func testUnlockRemoteCommandSecurityIncorrect() {
    let remoteCommandStatus = buildUnlockRemoteCommandSecurityIncorrect()

    XCTAssertNotNil(remoteCommandStatus)
    XCTAssertNil(remoteCommandStatus.id)
    XCTAssertNil(remoteCommandStatus.requestId)
    XCTAssertNil(remoteCommandStatus.vin)
    XCTAssertNil(remoteCommandStatus.lastUpdated)
    XCTAssertNil(remoteCommandStatus.remoteCommand)
    XCTAssertNil(remoteCommandStatus.pcckErrorMessage)
    XCTAssertNil(remoteCommandStatus.pcckErrorCode)
    XCTAssert((remoteCommandStatus.pcckIsBusinessError != nil) && !remoteCommandStatus.pcckIsBusinessError!)
    XCTAssertEqual(RemoteCommandAccepted.PcckErrorKey.incorrectPin, remoteCommandStatus.pcckErrorKey)
    XCTAssert(remoteCommandStatus.pcckErrorKey != nil && remoteCommandStatus.pcckErrorKey == .incorrectPin)
  }

  // MARK: - Private functions

  private func buildUnlockRemoteCommandSecurityTimeout() -> RemoteCommandAccepted {
    let json = "{\"pcckErrorKey\" : \"LOCKED_60_MINUTES\", \"pcckErrorMessage\" : null, \"pcckErrorCode\": null, \"pcckIsBusinessError\": true}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601

    return try! decoder.decode(RemoteCommandAccepted.self, from: json)
  }

  private func buildUnlockRemoteCommandSecurityIncorrect() -> RemoteCommandAccepted {
    let json = "{\"pcckErrorKey\" : \"INCORRECT\", \"pcckErrorMessage\" : null, \"pcckErrorCode\": null, \"pcckIsBusinessError\": false}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601

    return try! decoder.decode(RemoteCommandAccepted.self, from: json)
  }

  private func buildRemoteCommandStatusInProgress() -> RemoteCommandStatus {
    let json = "{\"status\" : \"IN_PROGRESS\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(RemoteCommandStatus.self, from: json)
  }

  private func buildRemoteCommandStatusInSuccess() -> RemoteCommandStatus {
    let json = "{\"status\" : \"SUCCESS\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(RemoteCommandStatus.self, from: json)
  }

  private func buildRemoteCommandStatusInUnknown() -> RemoteCommandStatus {
    let json = "{\"status\" : \"Not Known\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(RemoteCommandStatus.self, from: json)
  }

}
