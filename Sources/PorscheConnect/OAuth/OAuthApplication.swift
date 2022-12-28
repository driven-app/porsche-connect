import Foundation

/// The Porsche Connect service is composed of various independent OAuth applications, each providing
/// access to specific services and endpoints once authenticated.
///
/// Once authenticated, an instance of this type will typically be associated with an OAuthToken instance that
/// represents the user's authentication.
public struct OAuthApplication: Hashable {
  let clientId: String
  let redirectURL: URL

  static let api = OAuthApplication(
    clientId: "4mPO3OE5Srjb1iaUGWsbqKBvvesya8oA",
    redirectURL: URL(string: "https://my.porsche.com/core/de/de_DE")!
  )
  static let carControl = OAuthApplication(
    clientId: "Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs",
    redirectURL: URL(string: "https://my.porsche.com/myservices/auth/auth.html")!
  )
}

/// An OAuthToken is created as a result of a successful user authentication for a specific OAuthApplication.
public struct OAuthToken: Codable {

  // MARK: Properties

  public let accessToken: String
  public let idToken: String
  public let tokenType: String
  public let expiresIn: Double
  public let expiresAt: Date

  public var apiKey: String? {
    // Standard OAuth JWT decoding. See
    // https://www.oauth.com/oauth2-servers/access-tokens/self-encoded-access-tokens/
    // for more details. Porsche Connect requires an apikey field as part of all authenticated
    // requests. The apikey can be extracted from the jwt's "aud" field.
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
