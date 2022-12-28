import Foundation

/// The locale from which all API calls should be made.
///
/// The environment affects the units and localization of API responses.
public struct Environment: Equatable {
  public let countryCode: CountryCode
  public let languageCode: LanguageCode
  public let regionCode: String

  static public let germany = Environment(
    countryCode: .germany, languageCode: .german, regionCode: "de/de_DE")
  static let test = Environment(
    countryCode: .ireland, languageCode: .english, regionCode: "ie/en_IE")
}

public enum CountryCode: String {
  case germany = "de"
  case ireland = "ie"
  case unitedStates = "us"
}

public enum LanguageCode: String {
  case english = "en"
  case german = "de"
}
