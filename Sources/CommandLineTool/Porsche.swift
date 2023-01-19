import ArgumentParser
import Foundation
import PorscheConnect

// MARK: Extensions

// Allow SupportedLocale to be used as a command line option.
extension SupportedLocale: ExpressibleByArgument {
}

// MARK: - Main

@main
struct Porsche: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: NSLocalizedString(
      "A command-line tool to call and interact with Porsche Connect services.", comment: ""),
    version: "0.1.19",
    subcommands: [
      ListVehicles.self, ShowSummary.self, ShowPosition.self, ShowCapabilities.self,
      ShowEmobility.self, ShowStatus.self, ShowTrips.self, Flash.self, HonkAndFlash.self, ToggleDirectCharging.self,
      Lock.self, Unlock.self,
    ])

  struct Options: ParsableArguments {
    @Argument(
      help: ArgumentHelp(
        NSLocalizedString("Your MyPorsche username (registered email).", comment: "")))
    var username: String

    @Argument(help: ArgumentHelp(NSLocalizedString("Your MyPorsche password.", comment: "")))
    var password: String

    @Option(help: ArgumentHelp(NSLocalizedString(
      "The locale to use when making API calls. "
      + "Defaults to the system locale if possible, otherwise defaults to Germany. ",
      comment: ""
    )))
    var locale: SupportedLocale? = nil

    private var resolvedLocale: Locale {
      // Prioritize the provided locale option, if one was given.
      if let givenLocale = locale {
        return Locale(identifier: givenLocale.rawValue)
      }
      return SupportedLocale.default
    }

    var resolvedEnvironment: Environment {
      return .init(locale: resolvedLocale) ?? .germany
    }
  }
}
