import Foundation

public struct AuthResponse: Decodable {
  public let accessToken: String
  public let idToken: String
  public let tokenType: String
  public let expiresIn: Double
}
