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
