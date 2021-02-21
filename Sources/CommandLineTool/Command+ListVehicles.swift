import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {
    
  struct ListVehicles: ParsableCommand {
    
    // MARK: - Properties
    
    @OptionGroup() var options: Options
    
    // MARK: - Lifecycle
    
    func run() throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      callListVehiclesService(porscheConnect: porscheConnect)
      dispatchMain()
    }
    
    // MARK: - Private functions
    
    private func callListVehiclesService(porscheConnect: PorscheConnect) {
      porscheConnect.vehicles { result in
        switch result {
        case .success(let (vehicles, _)):
          printVehicles(vehicles)
          Porsche.ListVehicles.exit()
        case .failure(let error):
          Porsche.ListVehicles.exit(withError: error)
        }
      }
    }
    
    private func printVehicles(_ vehicles: [Vehicle]?) {
      guard let vehicles = vehicles else { return }
      
      vehicles.enumerated().forEach { (index, vehicle) in
        printVehicle(vehicle, at: index)
      }
    }
    
    private func printVehicle(_ vehicle: Vehicle, at index: Int) {
      let output = NSLocalizedString("#\(index+1) => Model: \(vehicle.modelDescription); Year: \(vehicle.modelYear); Type: \(vehicle.modelType); VIN: \(vehicle.vin)", comment: "")
      print(output)
    }
  }
}
