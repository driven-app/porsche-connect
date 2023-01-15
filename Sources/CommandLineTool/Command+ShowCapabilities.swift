import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {

  struct ShowCapabilities: AsyncParsableCommand {

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
        if let capabilities = result.capabilities {
          printCapabilities(capabilities)
        }
        Porsche.ShowCapabilities.exit()
      } catch {
        Porsche.ShowCapabilities.exit(withError: error)
      }
    }

    private func printCapabilities(_ capabilities: Capabilities) {
      let output = NSLocalizedString(
        "Display parking brake: \(capabilities.displayParkingBrake.displayString); Needs SPIN: \(capabilities.needsSPIN.displayString); Has RDK: \(capabilities.hasRDK.displayString); Engine Type: \(capabilities.engineType); Car Model: \(capabilities.carModel); Front Seat Heating: \(capabilities.heatingCapabilities.frontSeatHeatingAvailable.displayString); Rear Seat Heating: \(capabilities.heatingCapabilities.rearSeatHeatingAvailable.displayString); Steering Wheel Position: \(capabilities.steeringWheelPosition); Honk & Flash: \(capabilities.hasHonkAndFlash?.displayString ?? "Not currently available")",
        comment: "")
      print(output)
    }
  }
}
