//import Foundation
//import ArgumentParser
//import PorscheConnect
//
//extension Porsche {
//  
//  struct ShowPosition: ParsableCommand {
//    
//    // MARK: - Properties
//    
//    @OptionGroup() var options: Options
//    
//    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
//    var vin: String
//    
//    // MARK: - Lifecycle
//    
//    func run() throws {
//      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
//      let vehicle = Vehicle(vin: vin)
//      callPositionService(porscheConnect: porscheConnect, vehicle: vehicle)
//      dispatchMain()
//    }
//    
//    // MARK: - Private functions
//    
//    private func callPositionService(porscheConnect: PorscheConnect, vehicle: Vehicle) {
//      porscheConnect.position(vehicle: vehicle) { result in
//        switch result {
//        case .success(let (position, _)):
//          if let position = position {
//            printPosition(position)
//          }
//          Porsche.ShowPosition.exit()
//        case .failure(let error):
//          Porsche.ShowPosition.exit(withError: error)
//        }
//      }
//    }
//    
//    private func printPosition(_ position: Position) {
//      let output = NSLocalizedString("Latitude: \(position.carCoordinate.latitude); Longitude: \(position.carCoordinate.longitude); Heading: \(String(format: "%.0f" ,position.heading))", comment: "")
//      print(output)
//    }
//  }
//}
