import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct Lock: AsyncParsableCommand {

    // MARK: - Properties

    @OptionGroup() var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(
        username: options.username,
        password: options.password,
        environment: options.resolvedEnvironment
      )
      let vehicle = Vehicle(vin: vin)
      await callLock(porscheConnect: porscheConnect, vehicle: vehicle)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callLock(porscheConnect: PorscheConnect, vehicle: Vehicle) async {

      do {
        let result = try await porscheConnect.lock(vehicle: vehicle)
        if let remoteCommandAccepted = result.remoteCommandAccepted {
          printRemoteCommandAccepted(remoteCommandAccepted)
        }
        Porsche.Lock.exit()
      } catch {
        Porsche.Lock.exit(withError: error)
      }
    }

    private func printRemoteCommandAccepted(_ remoteCommandAccepted: RemoteCommandAccepted) {
      print(
        NSLocalizedString(
          "Remote command \"Lock\" accepted by Porsche API with ID \(remoteCommandAccepted.identifier!)",
          comment: ""))
    }
  }
}
