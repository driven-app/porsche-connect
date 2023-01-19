import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct Unlock: AsyncParsableCommand {

    // MARK: - Properties

    @OptionGroup()
    var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String

    @Argument(help: ArgumentHelp(NSLocalizedString("Your PIN/Security Code.", comment: "")))
    var pin: String

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(
        username: options.username,
        password: options.password,
        environment: options.resolvedEnvironment
      )
      await callUnlock(porscheConnect: porscheConnect, vin: vin, pin: pin)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callUnlock(porscheConnect: PorscheConnect, vin: String, pin: String) async {

      do {
        let result = try await porscheConnect.unlock(vin: vin, pin: pin)
        if let remoteCommandAccepted = result.remoteCommandAccepted {
          printRemoteCommandAccepted(remoteCommandAccepted)
        }
        Porsche.Unlock.exit()
      } catch {
        Porsche.Unlock.exit(withError: error)
      }
    }

    private func printRemoteCommandAccepted(_ remoteCommandAccepted: RemoteCommandAccepted) {
      if remoteCommandAccepted.pcckErrorKey != nil {
        printError(remoteCommandAccepted)
      } else {
        print(
          NSLocalizedString(
            "Remote command \"Unlock\" accepted by Porsche API with ID \(remoteCommandAccepted.identifier!)",
            comment: ""))
      }
    }

    private func printError(_ remoteCommandAccepted: RemoteCommandAccepted) {
      switch remoteCommandAccepted.pcckErrorKey {
      case .lockedFor60Minutes:
        print(
          NSLocalizedString(
            "Remote command \"Unlock\" returned with a \"Locked for 60 minutes\" error",
            comment: ""))
      case .incorrectPin:
        print(
          NSLocalizedString(
            "Remote command \"Unlock\" returned with a \"Incorrect PIN\" error",
            comment: ""))
      default:
        break
      }
    }
  }
}
