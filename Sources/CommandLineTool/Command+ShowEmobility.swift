import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {

  struct ShowEmobility: AsyncParsableCommand {

    // MARK: - Properties

    @OptionGroup() var options: Options

    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String

    // MARK: - Lifecycle

    func run() async throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      await callCapabilitiesService(porscheConnect: porscheConnect, vehicle: vehicle)
      dispatchMain()
    }

    // MARK: - Private functions

    private func callCapabilitiesService(porscheConnect: PorscheConnect, vehicle: Vehicle) async {
      do {
        let result = try await porscheConnect.capabilities(vehicle: vehicle)
        await callEmobilityService(porscheConnect: porscheConnect, vehicle: vehicle, capabilities: result.capabilities)
      } catch {
        Porsche.ShowEmobility.exit(withError: error)
      }
    }

    private func callEmobilityService(porscheConnect: PorscheConnect, vehicle: Vehicle, capabilities: Capabilities?) async {
      guard let capabilities = capabilities else { return }

      do {
        let result = try await porscheConnect.emobility(vehicle: vehicle, capabilities: capabilities)
        if let emobility = result.emobility {
          printEmobility(emobility)
          Porsche.ShowEmobility.exit()
        }
      } catch {
        Porsche.ShowEmobility.exit(withError: error)
      }
    }

    private func printEmobility(_ emobility: Emobility) {
      let output = NSLocalizedString("Battery Level: \(emobility.batteryChargeStatus.stateOfChargeInPercentage)%; Remaining Range: \(emobility.batteryChargeStatus.remainingERange.valueInKilometers) KM; Charging Status: \(emobility.chargingStatus); Plug Status: \(emobility.batteryChargeStatus.plugState)", comment: "")
      print(output)
    }
  }
}
