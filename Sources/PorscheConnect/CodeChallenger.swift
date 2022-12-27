import Foundation
import CryptoKit

/// A utility for generating code verifier and code challenge as part of the OAuth2 specification:
/// https://www.oauth.com/oauth2-servers/pkce/authorization-request/
struct CodeChallenger {

  private let length: Int

  init(length: Int = 40) {
    self.length = length
  }

  func generateCodeVerifier() -> String? {
    var buffer = [UInt8](repeating: 0, count: length)
    let result = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)

    guard result == errSecSuccess else { return nil }

    return Data(buffer).base64EncodedString()
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "-")
      .replacingOccurrences(of: "=", with: "-")
      .trimmingCharacters(in: .whitespaces)
  }

  func codeChallenge(for codeVerifier: String) -> String? {
    guard let data = codeVerifier.data(using: .utf8) else { return nil }

    let encodedHash = Data(SHA256.hash(data: data)).base64EncodedString()
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")

    return encodedHash
  }
}
