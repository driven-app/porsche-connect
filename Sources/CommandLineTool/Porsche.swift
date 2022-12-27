import Foundation
import ArgumentParser

// MARK: - Main

@main
struct Porsche: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: NSLocalizedString("A command-line tool to call and interact with Porsche Connect services.", comment: ""),
    version: "0.1.4",
    subcommands: [ListVehicles.self, ShowSummary.self, ShowPosition.self, ShowCapabilities.self, ShowEmobility.self, Flash.self, HonkAndFlash.self])
  
  struct Options: ParsableArguments {
    @Argument(help: ArgumentHelp(NSLocalizedString("Your MyPorsche username (registered email).", comment: "")))
    var username: String
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Your MyPorsche password.", comment: "")))
    var password: String
  }
}
