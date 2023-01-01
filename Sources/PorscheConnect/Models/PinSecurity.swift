import Foundation
import CryptoKit

public struct PinSecurity: Codable {

  // MARK: Properties

  public let securityToken: String
  public let challenge: String

  // MARK: Public

  public func computeHash(pin: String) -> String? {
    guard let data = (pin+challenge).data(using: .utf8) else { return nil }
    return SHA512.hash(data: data).makeIterator().map { String(format: "%02x", $0) }.joined().uppercased()
  }
}

public struct UnlockSecurity: Codable { //TODO: find a beter name for this

  // MARK: Properties

  public let challenge: String
  public let securityPinHash: String
  public let securityToken: String
}
  
