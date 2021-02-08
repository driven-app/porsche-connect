import Foundation

public struct PorscheAuth: Codable {
  
  // MARK: - Properties
  
  public let accessToken: String
  public let idToken: String
  public let tokenType: String
  public let expiresIn: Int
  public let apiKey: String?
  
  
  public init?(accessToken: String, idToken: String, tokenType: String, expiresIn: Int) {
    self.accessToken = accessToken
    self.idToken = idToken
    self.tokenType = tokenType
    self.expiresIn = expiresIn
    
    let idTokenComponents = self.idToken.components(separatedBy: ".")
    let decodedString = String(data: Data(base64Encoded: idTokenComponents[1]) ?? kBlankData, encoding: .utf8)!
    let jwtDctionary = try! JSONSerialization.jsonObject(with: decodedString.data(using: .utf8)!, options: .mutableContainers) as! Dictionary<String, Any>
    self.apiKey = jwtDctionary["aud"] as! String
  }
}
