import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {

  struct Flash: AsyncParsableCommand {

    // MARK: - Properties

    @OptionGroup() var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      await callFlash(porscheConnect: porscheConnect, vehicle: vehicle)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callFlash(porscheConnect: PorscheConnect, vehicle: Vehicle) async {

      do {
        let result = try await porscheConnect.flash(vehicle: vehicle)
        if let remoteCommandAccepted = result.remoteCommandAccepted {
          printRemoteCommandAccepted(remoteCommandAccepted)
        }
        Porsche.Flash.exit()
      } catch {
        Porsche.Flash.exit(withError: error)
      }
    }

    private func printRemoteCommandAccepted(_ remoteCommandAccepted: RemoteCommandAccepted) {
      print(NSLocalizedString("Remote command \"Flash\" accepted by Porsche API with ID \(remoteCommandAccepted.id)", comment: ""))
    }
  }
}
