import CryptoKit
import Foundation

extension PorscheConnect {
  public func unlock(vin: String, pin: String) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleLockUnlockURL(vin: vin, lock: false)

    let pinSecurity = try await networkClient.get(
      PinSecurity.self, url: url, headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys
    ).data

    guard let pinSecurity = pinSecurity, let pinHash = pinSecurity.generateSecurityPinHash(pin: pin)
    else {
      throw PorscheConnectError.UnlockChallengeFailure
    }

    let unlockSecurity = UnlockSecurity(
      challenge: pinSecurity.challenge,
      securityPinHash: pinHash,
      securityToken: pinSecurity.securityToken)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: unlockSecurity, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)

    switch result.data?.pcckErrorKey {
    case .lockedFor60Minutes:
      throw PorscheConnectError.lockedFor60Minutes
    case .incorrectPin:
      throw PorscheConnectError.IncorrectPin
    case .none:
      break
    }

    result.data?.remoteCommand = .unlock
    return (remoteCommandAccepted: result.data, response: result.response)
  }
}

// MARK: - Response types

public struct PinSecurity: Codable {

  // MARK: Properties

  public let securityToken: String
  public let challenge: String

  // MARK: Public

  public func generateSecurityPinHash(pin: String) -> String? {
    let input = (pin + challenge).hex
    let hash = SHA512.hash(data: Data(bytes: input, count: input.count))

    return hash.makeIterator().map { String(format: "%02x", $0) }.joined().uppercased()
  }
}

public struct UnlockSecurity: Codable { //TODO: find a beter name for this

  // MARK: Properties

  public let challenge: String
  public let securityPinHash: String
  public let securityToken: String
}

