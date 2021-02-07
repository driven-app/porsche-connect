import Foundation

public struct PorscheAuth: Codable {
  let accessToken: String
  let idToken: String
  let tokenType: String
  let expiresIn: Int
}
