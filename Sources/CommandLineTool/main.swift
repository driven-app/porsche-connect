import Foundation
import ArgumentParser
import PorscheConnect

// MARK: - Main

struct Porsche: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: NSLocalizedString("A command-line tool to call and interact with Porsche Connect services.", comment: ""),
    version: "0.1.0",
    subcommands: [ListVehicles.self])
  
  struct Options: ParsableArguments {
    @Argument(help: ArgumentHelp(NSLocalizedString("Your MyPorsche username (registered email).", comment: "")))
    var username: String
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Your MyPorsche password.", comment: "")))
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
          print(NSLocalizedString("Error \(error).", comment: ""))
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
      print(NSLocalizedString("#\(index+1) => Model: \(vehicle.modelDescription); Year: \(vehicle.modelYear); Type: \(vehicle.modelType); VIN: \(vehicle.vin)", comment: ""))
    }
  }
}
