import Foundation

public struct Distance: Codable {
  public enum Unit: String, Codable {
    case kilometers = "KILOMETER"
    case miles = "MILE"
  }

  public let value: Double
  public let unit: Unit
  public let originalValue: Double
  public let originalUnit: Unit
  public let valueInKilometers: Double
  public let unitTranslationKey: String
  public let unitTranslationKeyV2: String?
}

extension Distance.Unit {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let unit = try container.decode(String.self)
    if let unit = Self(rawValue: unit) {
      self = unit
      return
    }
    if unit == "KILOMETERS" {
      self = .kilometers
      return
    }
    if unit == "MILES" {
      self = .miles
      return
    }
    throw DecodingError.typeMismatch(
      String.self,
      .init(codingPath: decoder.codingPath,
            debugDescription: "No valid case found for DistanceUnit with value of: \(unit)")
    )
  }
}
