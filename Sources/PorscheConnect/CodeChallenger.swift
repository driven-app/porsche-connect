import Foundation
import CryptoKit

struct CodeChallenger {
  
  private let length: Int
  
  init(length: Int) {
    self.length = length
  }
  
  func generateCodeChallenge() -> String? {
    guard let verifier = createCodeVerifier(), let data = verifier.data(using: .utf8) else { return nil }
    
    let hash = Data(SHA256.hash(data: data))
    
    return base64encode(data: hash)
  }
  
  // MARK: - Private
  
  private func createCodeVerifier() -> String? {
    var buffer = [UInt8](repeating: 0, count: length)
    let result = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
    
    guard result == errSecSuccess else { return nil }
  
    return base64encode(data: Data(buffer))
  }
  
  private func base64encode(data: Data) -> String {
    return data.base64EncodedString()
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")
      .trimmingCharacters(in: .whitespaces)
  }
}
