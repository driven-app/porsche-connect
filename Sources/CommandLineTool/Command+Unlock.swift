import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct Unlock: AsyncParsableCommand {

    // MARK: - Properties

    @OptionGroup() var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String

    @Argument(help: ArgumentHelp(NSLocalizedString("Your PIN/Security Code.", comment: "")))
    var pin: String

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      await callUnlock(porscheConnect: porscheConnect, vehicle: vehicle, pin: pin)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callUnlock(porscheConnect: PorscheConnect, vehicle: Vehicle, pin: String) async {

      do {
        let result = try await porscheConnect.unlock(vehicle: vehicle, pin: pin)
        if let remoteCommandAccepted = result.remoteCommandAccepted {
          printRemoteCommandAccepted(remoteCommandAccepted)
        }
        Porsche.Unlock.exit()
      } catch {
        Porsche.Unlock.exit(withError: error)
      }
    }

    private func printRemoteCommandAccepted(_ remoteCommandAccepted: RemoteCommandAccepted) {
      print(
        NSLocalizedString(
          "Remote command \"Unlock\" accepted by Porsche API with ID \(remoteCommandAccepted.identifier!)",
          comment: ""))
    }
  }
}

