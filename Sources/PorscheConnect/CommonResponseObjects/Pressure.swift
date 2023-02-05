import Foundation

public struct Pressure: Codable {
  public enum Unit: String, Codable {
    case bar = "BAR"
    case psi = "PSI"
  }

  public let value: Double
  public let unit: Unit
  public let valueInBar: Double
  public let unitTranslationKey: String
  public let unitTranslationKeyV2: String
}
