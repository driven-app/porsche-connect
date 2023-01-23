import Foundation

extension PorscheConnect {
  
  public func trips(vin: String, type tripType: Trip.TripType = .shortTerm) async throws -> (trips: [Trip]?, response: HTTPURLResponse) {
    let headers = try await performAuthFor(application: .api)
    let url = tripType == .shortTerm ? networkRoutes.vehicleShortTermTripsURL(vin: vin) : networkRoutes.vehicleLongTermTripsURL(vin: vin)
    
    let result = try await networkClient.get(
      [Trip].self, url: url, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (trips: result.data, response: result.response)
  }
}

// MARK: - Response types

public struct Trip: Codable {

  public enum TripType: String, Codable {
    case shortTerm = "SHORT_TERM"
    case longTerm = "LONG_TERM"
  }

  // MARK: Properties

  public let type: TripType
  public let id: Int
  public let travelTime: Int // TODO: Consider using Swift 5.7's Duration struct
  public let timestamp: Date
  public let averageSpeed: Speed
  public let averageFuelConsumption: FuelConsumption
  public let averageElectricEngineConsumption: ElectricEngineConsumption
  public let tripMileage: Distance
  public let startMileage: Distance
  public let endMileage: Distance
  public let zeroEmissionDistance: Distance
}
