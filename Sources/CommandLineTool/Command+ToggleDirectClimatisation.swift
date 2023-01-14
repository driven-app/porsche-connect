import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct ToggleDirectClimatisation: AsyncParsableCommand {

    // MARK: - Properties

    @OptionGroup() var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Toggle Direct Climatisation on.", comment: "")))
    var toggleDirectClimatisationOn: Bool

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(
        username: options.username,
        password: options.password,
        environment: options.resolvedEnvironment
      )
      await callToggleDirectClimatisationService(porscheConnect: porscheConnect, vin: vin, enable: toggleDirectClimatisationOn)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callToggleDirectClimatisationService(
      porscheConnect: PorscheConnect, vin: String, enable: Bool
    ) async {
      do {
        let result = try await porscheConnect.toggleDirectClimatisation(vin: vin, enable: enable)
        if let remoteCommandAccepted = result.remoteCommandAccepted {
          printRemoteCommandAccepted(remoteCommandAccepted)
          Porsche.ToggleDirectCharging.exit()
        }
      } catch {
        Porsche.ToggleDirectCharging.exit(withError: error)
      }
    }

    private func printRemoteCommandAccepted(_ remoteCommandAccepted: RemoteCommandAccepted) {
      print(
        NSLocalizedString(
          "Remote command \"Toggle Direct Charging\" accepted by Porsche API with ID \(remoteCommandAccepted.identifier!)",
          comment: ""))
    }
  }
}
