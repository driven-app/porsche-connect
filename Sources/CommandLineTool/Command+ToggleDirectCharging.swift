import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct ToggleDirectCharging: AsyncParsableCommand {

    // MARK: - Properties

    @OptionGroup() var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Toggle Direct Charging on.", comment: "")))
    var toggleDirectChargingOn: Bool

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(
        username: options.username,
        password: options.password,
        environment: options.resolvedEnvironment
      )
      let vehicle = Vehicle(vin: vin)
      await callCapabilitiesService(porscheConnect: porscheConnect, vehicle: vehicle)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callCapabilitiesService(porscheConnect: PorscheConnect, vehicle: Vehicle) async {
      do {
        let result = try await porscheConnect.capabilities(vehicle: vehicle)
        await callToggleDirectChargeService(
          porscheConnect: porscheConnect, vehicle: vehicle, capabilities: result.capabilities,
          enable: toggleDirectChargingOn)
      } catch {
        Porsche.ToggleDirectCharging.exit(withError: error)
      }
    }

    private func callToggleDirectChargeService(
      porscheConnect: PorscheConnect, vehicle: Vehicle, capabilities: Capabilities?, enable: Bool
    ) async {
      guard let capabilities = capabilities else { return }

      do {
        let result = try await porscheConnect.toggleDirectCharging(
          vehicle: vehicle, capabilities: capabilities, enable: enable)
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
