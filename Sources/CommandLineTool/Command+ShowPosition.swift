import Foundation
import ArgumentParser
import PorscheConnect

extension Porsche {
  
  struct ShowPosition: AsyncParsableCommand {
    
    // MARK: - Properties
    
    @OptionGroup() var options: Options
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String
    
    // MARK: - Lifecycle
    
    func run() async throws {
      let porscheConnect = PorscheConnect(username: options.username, password: options.password)
      let vehicle = Vehicle(vin: vin)
      await callPositionService(porscheConnect: porscheConnect, vehicle: vehicle)
      dispatchMain()
    }
    
    // MARK: - Private functions
    
    private func callPositionService(porscheConnect: PorscheConnect, vehicle: Vehicle) async {
      do {
        let result = try await porscheConnect.position(vehicle: vehicle)
        if let position = result.position {
          printPosition(position)
        }
        Porsche.ShowPosition.exit()
      } catch {
        Porsche.ShowPosition.exit(withError: error)
      }
    }
    
    private func printPosition(_ position: Position) {
      let output = NSLocalizedString("Latitude: \(position.carCoordinate.latitude); Longitude: \(position.carCoordinate.longitude); Heading: \(String(format: "%.0f" ,position.heading))", comment: "")
      print(output)
    }
  }
}
