import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {
    
  struct ListVehicles: AsyncParsableCommand {
    
    // MARK: - Properties
    
    @OptionGroup() var options: Options
    
    // MARK: - Lifecycle
    
    func run() async throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      await callListVehiclesService(porscheConnect: porscheConnect)
      dispatchMain()
    }
    
    // MARK: - Private functions
    
    private func callListVehiclesService(porscheConnect: PorscheConnect) async {      
      do {
        let result = try await porscheConnect.vehicles()
        printVehicles(result.vehicles)
        Porsche.ListVehicles.exit()
      } catch {
        Porsche.ListVehicles.exit(withError: error)
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
