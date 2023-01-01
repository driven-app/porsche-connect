import Foundation
import CryptoKit

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

