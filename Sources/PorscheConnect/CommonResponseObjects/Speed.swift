import Foundation

public struct Speed: Codable {
  public enum Unit: String, Codable {
    case kmh = "KMH"
    case mph = "MPH"
  }

  public let value: Double
  public let unit: Unit
  public let valueInKmh: Double
  public let unitTranslationKey: String
  public let unitTranslationKeyV2: String
}
