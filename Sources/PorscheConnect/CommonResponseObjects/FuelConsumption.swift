import Foundation

public struct FuelConsumption: Codable {
  public enum Unit: String, Codable {
    case litersPer100Km = "LITERS_PER_100_KM"
    case milesPerUSGallon = "MILES_PER_GALLON_US"
  }

  public let value: Double
  public let unit: Unit
  public let valueInLitersPer100Km: Double
  public let unitTranslationKey: String
  public let unitTranslationKeyV2: String
}
