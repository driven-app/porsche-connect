import Foundation

public struct PorscheAuth: Codable {
  
  // MARK: - Properties
  
  public let accessToken: String
  public let idToken: String
  public let tokenType: String
  public let expiresIn: Int
  
  public var apiKey: String? {
    let idTokenComponents = idToken.components(separatedBy: ".")
    
    if let decodedString = String(data: Data(base64Encoded: idTokenComponents[1]) ?? kBlankData, encoding: .utf8),
       let data = decodedString.data(using: .utf8),
       let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any>,
       let apiKey = dict["aud"] as? String {
      return apiKey
    } else {
      return nil
    }
  }
  
  public init(accessToken: String, idToken: String, tokenType: String, expiresIn: Int) {
    self.accessToken = accessToken
    self.idToken = idToken
    self.tokenType = tokenType
    self.expiresIn = expiresIn
  }
}
