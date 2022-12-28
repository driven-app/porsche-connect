import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct HonkAndFlash: AsyncParsableCommand {
    // MARK: - Properties

    @OptionGroup() var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      await callHonkAndFlash(porscheConnect: porscheConnect, vehicle: vehicle)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callHonkAndFlash(porscheConnect: PorscheConnect, vehicle: Vehicle) async {

      do {
        let result = try await porscheConnect.flash(vehicle: vehicle, andHonk: true)
        if let remoteCommandAccepted = result.remoteCommandAccepted {
          printRemoteCommandAccepted(remoteCommandAccepted)
        }
        Porsche.HonkAndFlash.exit()
      } catch {
        Porsche.HonkAndFlash.exit(withError: error)
      }
    }

    private func printRemoteCommandAccepted(_ remoteCommandAccepted: RemoteCommandAccepted) {
      print(
        NSLocalizedString(
          "Remote command \"Honk and Flash\" accepted by Porsche API with ID \(remoteCommandAccepted.identifier!)",
          comment: ""))
    }
  }
}
