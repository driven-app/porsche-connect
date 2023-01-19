import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct Flash: AsyncParsableCommand {

    // MARK: - Properties

    @OptionGroup()
    var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(
        username: options.username,
        password: options.password,
        environment: options.resolvedEnvironment
      )
      await callFlash(porscheConnect: porscheConnect, vin: vin)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callFlash(porscheConnect: PorscheConnect, vin: String) async {

      do {
        let result = try await porscheConnect.flash(vin: vin)
        if let remoteCommandAccepted = result.remoteCommandAccepted {
          printRemoteCommandAccepted(remoteCommandAccepted)
        }
        Porsche.Flash.exit()
      } catch {
        Porsche.Flash.exit(withError: error)
      }
    }

    private func printRemoteCommandAccepted(_ remoteCommandAccepted: RemoteCommandAccepted) {
      print(
        NSLocalizedString(
          "Remote command \"Flash\" accepted by Porsche API with ID \(remoteCommandAccepted.identifier!)",
          comment: ""))
    }
  }
}
