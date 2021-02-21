import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {
  
  struct ShowEmobility: ParsableCommand {
    
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
          callEmobilityService(porscheConnect: porscheConnect, vehicle: vehicle, capabilities: capabilities)
        case .failure(let error):
          Porsche.ShowEmobility.exit(withError: error)
        }
      }
    }
    
    private func callEmobilityService(porscheConnect: PorscheConnect, vehicle: Vehicle, capabilities: Capabilities?) {
      guard let capabilities = capabilities else { return }
      
      porscheConnect.emobility(vehicle: vehicle, capabilities: capabilities) { result in
        switch result {
        case .success(let (emobility, _)):
          if let emobility = emobility {
            printEmobility(emobility)
            Porsche.ShowEmobility.exit()
          }
        case .failure(let error):
          Porsche.ShowEmobility.exit(withError: error)
        }
      }
    }
    
    private func printEmobility(_ emobility: Emobility) {
      let output = NSLocalizedString("Battery Level %: \(emobility.batteryChargeStatus.stateOfChargeInPercentage); Remaining Range (in KM): \(emobility.batteryChargeStatus.remainingERange.valueInKilometers); Charging Status: \(emobility.chargingStatus); Plug Status: \(emobility.batteryChargeStatus.plugState)", comment: "")
      print(output)
    }
  }
}
