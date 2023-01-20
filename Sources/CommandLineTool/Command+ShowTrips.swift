import ArgumentParser
import Foundation
import PorscheConnect

extension Porsche {
    
  struct ShowTrips: AsyncParsableCommand {
    
    enum TripType: String, ExpressibleByArgument {
        case short, long
    }
    
    // MARK: - Properties
    
    @OptionGroup()
    var options: Options
    
    @Argument(help: ArgumentHelp(NSLocalizedString("Your vehicle VIN.", comment: "")))
    var vin: String
    
    @Option(help: ArgumentHelp(NSLocalizedString("Use \"short\" for short term trips, and \"long\" for long term trips.", comment: "")))
    var tripType: TripType = .short
    
    // MARK: - Lifecycle
    
    func run() async throws {
      let porscheConnect = PorscheConnect(
        username: options.username,
        password: options.password,
        environment: options.resolvedEnvironment
      )
      await callTripService(porscheConnect: porscheConnect, vin: vin)
      dispatchMain()
    }
    
    // MARK: - Private functions
    
    private func callTripService(porscheConnect: PorscheConnect, vin: String) async {
      
      do {
        let type = tripType == .short ? Trip.TripType.shortTerm : Trip.TripType.longTerm
        let result = try await porscheConnect.trips(vin: vin, type: type)
        printTrips(result.trips)
        Porsche.ShowTrips.exit()
      } catch {
        Porsche.ShowTrips.exit(withError: error)
      }
    }
    
    private func printTrips(_ trips: [Trip]?) {
      guard let trips = trips else { return }
      
      trips.enumerated().forEach { (index, trip) in
        printTrip(trip, at: index)
      }
    }
    
    private func printTrip(_ trip: Trip, at index: Int) {
      let output = NSLocalizedString(
        "#\(index+1) => Trip ID: \(trip.id); Timestamp: \(TimestampFormatter(timestamp: trip.timestamp).formatted()); Distance: \(trip.tripMileage.valueInKilometers) km; Average speed: \(trip.averageSpeed.valueInKmh) km/h; EV consumption: \(trip.averageElectricEngineConsumption.valueKwhPer100Km) kWh/100km",
        comment: "") //TODO: Implement locales for units
      print(output)
    }
  }
}
