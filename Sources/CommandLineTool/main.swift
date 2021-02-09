import Foundation
import ArgumentParser
import PorscheConnect

// MARK: - Main

struct Porsche: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "A command-line tool to call and interact with Porsche Connect services",
    version: "0.1.0",
    subcommands: [ListVehicles.self])
  
  struct Options: ParsableArguments {
    @Argument(help: "Your MyPorsche username (registered email).")
    var username: String
    
    @Argument(help: "Your MyPorsche password")
    var password: String
  }
}

Porsche.main()

// MARK: - Vehicles

extension Porsche {
  struct ListVehicles: ParsableCommand {
    @OptionGroup() var options: Options
    
    func run() throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      porscheConnect.vehicles { result in
        switch result {
        case .success(let (vehicles, _)):
          printVehicles(vehicles)
        case .failure(let error):
          print("Error: \(error)")
        }
        
        Porsche.ListVehicles.exit()
      }
    
      dispatchMain()
    }
    
    func printVehicles(_ vehicles: [Vehicle]?) {
      guard let vehicles = vehicles else { return }
      
      vehicles.enumerated().forEach { (index, vehicle) in
        printVehicle(vehicle, at: index)
      }
    }
    
    func printVehicle(_ vehicle: Vehicle, at index: Int) {
      print("#\(index+1) => Model: \(vehicle.modelDescription); Year: \(vehicle.modelYear); Type: \(vehicle.modelType); VIN: \(vehicle.vin)")
    }
  }
}
