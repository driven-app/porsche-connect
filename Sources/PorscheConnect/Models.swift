import Foundation
import SwiftUI
import CoreLocation

public struct PorscheAuth: Codable {
  
  // MARK: Properties
  
  public let accessToken: String
  public let idToken: String
  public let tokenType: String
  public let expiresIn: Double
  public let expiresAt: Date
  
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

// MARK: -

public struct Vehicle: Codable {
  
  // MARK: Properties
  
  public let vin: String
  public let modelDescription: String
  public let modelType: String
  public let modelYear: String
  public let exteriorColorHex: String
  public let attributes: [VehicleAttribute]?
  public let pictures: [VehiclePicture]?

  // MARK: Computed Properties
  
  public var externalColor: Color {
    return Color(hex: exteriorColorHex)
  }
  
  // MARK: -
  
  public struct VehicleAttribute: Codable {
    
    // MARK: Properties
    
    public let name: String
    public let value: String
  }

  // MARK: -
  
  public struct VehiclePicture: Codable {
    
    // MARK: Properties
    
    public let url: URL
    public let view: String
    public let size: Int
    public let width: Int
    public let height: Int
    public let transparent: Bool
    public let placeholder: String?
  }
  
  public init(vin: String, modelDescription: String, modelType: String, modelYear: String, exteriorColorHex: String, attributes: [VehicleAttribute]?, pictures: [VehiclePicture]?) {
    self.vin = vin
    self.modelDescription = modelDescription
    self.modelType = modelType
    self.modelYear = modelYear
    self.exteriorColorHex = exteriorColorHex
    self.attributes = attributes
    self.pictures = pictures
  }
  
  public init(vin: String) {
    self.vin = vin
    self.modelDescription = kBlankString
    self.modelType = kBlankString
    self.modelYear = kBlankString
    self.exteriorColorHex = kBlankString
    self.attributes = nil
    self.pictures = nil
  }
}

// MARK: -
  
public struct Summary: Codable {
  
  // MARK: Properties
  
  public let modelDescription: String
  public let nickName: String?
}

// MARK: -
  
public struct Position: Codable {
  
  // MARK: Properties
  public let carCoordinate: CarCoordinate
  public let heading: CLLocationDirection
  
  // MARK: -
  
  public struct CarCoordinate: Codable {
    
    // MARK: Properties
    
    public let geoCoordinateSystem: String
    public let latitude: CLLocationDegrees
    public let longitude: CLLocationDegrees
  }
}


