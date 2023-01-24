import Foundation

public struct ElectricEngineConsumption: Codable {
  public enum Unit: String, Codable {
    case kilowattHoursPer100Km = "KWH_PER_100KM"
    case kilowattHourPerMile = "KWH_PER_MILE"
  }

  public let value: Double
  public let unit: Unit
  public let valueKwhPer100Km: Double
  public let unitTranslationKey: String
  public let unitTranslationKeyV2: String
}

