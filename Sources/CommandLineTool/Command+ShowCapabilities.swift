import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {
  
  struct ShowCapabilities: ParsableCommand {
    
    // MARK: - Properties
    
    @OptionGroup() var options: Options
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String
    
    // MARK: - Lifecycle
    
    func run() throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      callCapabilitiesService(porscheConnect: porscheConnect, vehicle: vehicle)
      dispatchMain()
    }
    
    // MARK: - Private functions
    
    private func callCapabilitiesService(porscheConnect: PorscheConnect, vehicle: Vehicle) {
      porscheConnect.capabilities(vehicle: vehicle) { result in
        switch result {
        case .success(let (capabilities, _)):
          if let capabilities = capabilities {
            printCapabilities(capabilities)
          }
        case .failure(let error):
          Porsche.ShowEmobility.exit(withError: error)
        }
      }
    }
    
    private func printCapabilities(_ capabilities: Capabilities) {
      let output = NSLocalizedString("Display parking brake: \(capabilities.displayParkingBrake.displayString); Needs SPIN: \(capabilities.needsSPIN.displayString); Has RDK: \(capabilities.hasRDK.displayString); Engine Type: \(capabilities.engineType); Car Model: \(capabilities.carModel); Front Seat Heating: \(capabilities.heatingCapabilities.frontSeatHeatingAvailable.displayString); Rear Seat Heating: \(capabilities.heatingCapabilities.rearSeatHeatingAvailable.displayString); Steering Wheel Position: \(capabilities.steeringWheelPosition); Honk & Flash: \(capabilities.hasHonkAndFlash.displayString)", comment: "")
      print(output)
    }
  }
}
