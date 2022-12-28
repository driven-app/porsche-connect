import Foundation

/// A response from one of the Porsche Connect authorization endpoints.
///
/// This type is not meant to be stored to disk as it includes a relative time value that is only meaningful when
/// first decoded from the server. If you need to store an AuthResponse longer-term, use OAuthToken instead.
public struct AuthResponse: Decodable {
  public let accessToken: String
  public let idToken: String
  public let tokenType: String
  public let expiresIn: Double
}
