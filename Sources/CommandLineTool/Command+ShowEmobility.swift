import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct ShowEmobility: AsyncParsableCommand {

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
      await callCapabilitiesService(porscheConnect: porscheConnect, vin: vin)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callCapabilitiesService(porscheConnect: PorscheConnect, vin: String) async {
      do {
        let result = try await porscheConnect.capabilities(vin: vin)
        await callEmobilityService(
          porscheConnect: porscheConnect, vin: vin, capabilities: result.capabilities)
      } catch {
        Porsche.ShowEmobility.exit(withError: error)
      }
    }

    private func callEmobilityService(
      porscheConnect: PorscheConnect, vin: String, capabilities: Capabilities?
    ) async {
      guard let capabilities = capabilities else { return }

      do {
        let result = try await porscheConnect.emobility(vin: vin, capabilities: capabilities)
        if let emobility = result.emobility {
          printEmobility(emobility)
          Porsche.ShowEmobility.exit()
        }
      } catch {
        Porsche.ShowEmobility.exit(withError: error)
      }
    }

    private func printEmobility(_ emobility: Emobility) {
      let output = NSLocalizedString(
        "Battery Level: \(emobility.batteryChargeStatus.stateOfChargeInPercentage)%; Remaining Range: \(emobility.batteryChargeStatus.remainingERange.valueInKilometers) KM; Charging Status: \(emobility.chargingStatus); Plug Status: \(emobility.batteryChargeStatus.plugState)",
        comment: "")
      print(output)
    }
  }
}
