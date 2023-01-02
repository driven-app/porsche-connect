import ArgumentParser
import Foundation
import PorscheConnect

// MARK: - Main

@main
struct Porsche: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: NSLocalizedString(
      "A command-line tool to call and interact with Porsche Connect services.", comment: ""),
    version: "0.1.19",
    subcommands: [
      ListVehicles.self, ShowSummary.self, ShowPosition.self, ShowCapabilities.self,
      ShowEmobility.self, ShowStatus.self, Flash.self, HonkAndFlash.self, ToggleDirectCharging.self,
      Lock.self, Unlock.self,
    ])

  struct Options: ParsableArguments {
    @Argument(
      help: ArgumentHelp(
        NSLocalizedString("Your MyPorsche username (registered email).", comment: "")))
    var username: String

    @Argument(help: ArgumentHelp(NSLocalizedString("Your MyPorsche password.", comment: "")))
    var password: String

    // The list of supported locales was determined via brute force authorization attempts using
    // the following code:
    //
    //    let identifiers = Locale.availableIdentifiers
    //    for identifier in identifiers {
    //      guard let environment = Environment(locale: Locale(identifier: identifier)) else {
    //        continue
    //      }
    //      let porscheConnect = PorscheConnect(
    //        username: options.username,
    //        password: options.password,
    //        environment: environment
    //      )
    //      await callListVehiclesService(porscheConnect: porscheConnect)
    //    }
    enum LocaleOption: String, ExpressibleByArgument, CaseIterable {
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
    }
    @Option(help: ArgumentHelp(NSLocalizedString(
      "The locale to use when making API calls. "
      + "Defaults to the system locale if possible, otherwise defaults to Germany. ",
      comment: ""
    )))
    var locale: LocaleOption? = nil

    private var resolvedLocale: Locale {
      // Prioritize the provided locale option, if one was given.
      if let givenLocale = locale {
        return Locale(identifier: givenLocale.rawValue)
      }
      // If no locale was provided, try to use the user's current locale.
      if let currentLocale = LocaleOption(rawValue: Locale.current.identifier) {
        return Locale(identifier: currentLocale.rawValue)
      }
      // If the system locale wasn't supported at all, fall back to Germany.
      return Locale(identifier: LocaleOption.germany.rawValue)
    }

    var resolvedEnvironment: Environment {
      return .init(locale: resolvedLocale) ?? .germany
    }
  }
}
