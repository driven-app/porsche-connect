import Foundation
import ArgumentParser

extension Bool {
  var displayString: String {
    return self ? NSLocalizedString("yes", comment: "") : NSLocalizedString("no", comment: "")
  }
}

// MARK: - Support Async/Await

protocol AsyncParsableCommand: ParsableCommand {
  mutating func runAsync() async throws
}

extension ParsableCommand {
  static func main(_ arguments: [String]? = nil) async {
    do {
      var command = try parseAsRoot(arguments) as? AsyncParsableCommand
      try await command!.runAsync()
    } catch {
      exit(withError: error)
    }
  }
}
