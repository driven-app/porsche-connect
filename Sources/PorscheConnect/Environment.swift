import Foundation

/// The locale from which all API calls should be made.
///
/// The environment affects the units and localization of API responses.
public struct Environment: Equatable {
  public let countryCode: String
  public let languageCode: String
  public let regionCode: String

  public init(countryCode: String, languageCode: String, regionCode: String) {
    self.countryCode = countryCode
    self.languageCode = languageCode
    self.regionCode = regionCode
  }

  /// Initializes the Environment with a given locale, if possible.
  ///
  /// - Parameter locale:The Locale must have an identifier consisting of both the country and language,
  ///   separated by a `-` or `_` character. For example, `de_DE` or `en_US`.
  public init?(locale: Locale) {
    guard let regionCode = locale.regionCode, let languageCode = locale.languageCode else {
      return nil
    }
    self.countryCode = regionCode.lowercased()
    self.languageCode = languageCode.lowercased()
    self.regionCode = "\(countryCode)/\(locale.identifier.replacingOccurrences(of: "-", with: "_"))"
  }
  static public let germany = Environment(locale: Locale(identifier: "de_DE"))!
  static let test = Environment(locale: Locale(identifier: "en_IE"))!
}
