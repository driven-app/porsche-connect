import Foundation

public struct PorscheAuth: Codable {

  // MARK: Properties

  public let accessToken: String
  public let idToken: String
  public let tokenType: String
  public let expiresIn: Double
  public let expiresAt: Date

  public var apiKey: String? {
    let idTokenComponents = idToken.components(separatedBy: ".")
    let paddedBase64EncodedString = idTokenComponents[1].padding(
      toLength: ((idTokenComponents[1].count + 3) / 4) * 4, withPad: "=", startingAt: 0)

    if let decodedString = String(
      data: Data(base64Encoded: paddedBase64EncodedString) ?? kBlankData, encoding: .utf8),
      let data = decodedString.data(using: .utf8),
      let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        as? [String: Any],
      let apiKey = dict["aud"] as? String
    {
      return apiKey
    } else {
      return nil
    }
  }

  public var expired: Bool {
    return Date() > expiresAt
  }

  // MARK: Lifecycle

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.accessToken = try values.decode(String.self, forKey: .accessToken)
    self.idToken = try values.decode(String.self, forKey: .idToken)
    self.tokenType = try values.decode(String.self, forKey: .tokenType)
    self.expiresIn = try values.decode(Double.self, forKey: .expiresIn)
    self.expiresAt = Date().addingTimeInterval(self.expiresIn)
  }

  public init(accessToken: String, idToken: String, tokenType: String, expiresIn: Double) {
    self.accessToken = accessToken
    self.idToken = idToken
    self.tokenType = tokenType
    self.expiresIn = expiresIn
    self.expiresAt = Date().addingTimeInterval(self.expiresIn)
  }
}
