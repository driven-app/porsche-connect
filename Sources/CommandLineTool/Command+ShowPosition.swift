import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {
  
  struct ShowPosition: ParsableCommand {
    @OptionGroup() var options: Options
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String
    
    func run() throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      
      porscheConnect.position(vehicle: vehicle) { result in
        switch result {
        case .success(let (position, _)):
          if let position = position {
            printPosition(position)
          }
        case .failure(let error):
          print(NSLocalizedString("Error \(error).", comment: ""))
        }
        
        Porsche.ShowSummary.exit()
      }
      
      dispatchMain()
    }
    
    private func printPosition(_ position: Position) {
      let output = NSLocalizedString("Latitude: \(position.carCoordinate.latitude); Longitude: \(position.carCoordinate.longitude); Heading: \(position.heading)", comment: "")
      print(output)
    }
  }
}
