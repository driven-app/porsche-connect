import Foundation
import ArgumentParser

// MARK: - Main

struct Porsche: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: NSLocalizedString("A command-line tool to call and interact with Porsche Connect services.", comment: ""),
    version: "0.1.0",
    subcommands: [ListVehicles.self, ShowSummary.self, ShowPosition.self])
  
  struct Options: ParsableArguments {
    @Argument(help: ArgumentHelp(NSLocalizedString("Your MyPorsche username (registered email).", comment: "")))
    var username: String
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Your MyPorsche password.", comment: "")))
    var password: String
  }
}

Porsche.main()
