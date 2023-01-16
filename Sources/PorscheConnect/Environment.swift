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

/// The set of locales known to be supported by the Porsche API endpoints.
///
/// The list of supported locales was determined via brute force authorization attempts using
/// the following code:
///
///    let identifiers = Locale.availableIdentifiers
///    for identifier in identifiers {
///      guard let environment = Environment(locale: Locale(identifier: identifier)) else {
///        continue
///      }
///      let porscheConnect = PorscheConnect(
///        username: options.username,
///        password: options.password,
///        environment: environment
///      )
///      await callListVehiclesService(porscheConnect: porscheConnect)
///    }
public enum SupportedLocale: String, CaseIterable {
  case china = "zh_CN"
  case czechia = "cs_CZ"
  case denmark = "da_DK"
  case estonia = "et_EE"
  case finland = "fi_FI"
  case france = "fr_FR"
  case germany = "de_DE"
  case italy = "it_IT"
  case japan = "ja_JP"
  case korea = "ko_KR"
  case latvia = "lv_LV"
  case lithuania = "lt_LT"
  case netherlands = "nl_NL"
  case poland = "pl_PL"
  case portugal = "pt_PT"
  case russia = "ru_RU"
  case spain = "es_ES"
  case sweden = "sv_SE"
  case taiwan = "zh_TW"
  case turkey = "tr_TR"
  case unitedKingdom = "en_GB"
  case unitedStates = "en_US"

  public static var `default`: Locale {
    // If no locale was provided, try to use the user's current locale.
    if let currentLocale = SupportedLocale(rawValue: Locale.current.identifier) {
      return Locale(identifier: currentLocale.rawValue)
    }
    // If the system locale wasn't supported at all, fall back to Germany.
    return Locale(identifier: SupportedLocale.germany.rawValue)
  }
}
