import Foundation

public struct GenericValue: Codable {
  public let value: Double
  public let unit: String
  public let unitTranslationKey: String
  public let unitTranslationKeyV2: String
}
