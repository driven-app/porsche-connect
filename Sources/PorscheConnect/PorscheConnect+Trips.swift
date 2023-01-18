import Foundation

extension PorscheConnect {
  
  public func trips(vin: String, type tripType: Trip.TripType = .shortTerm) async throws -> (trips: [Trip]?, response: HTTPURLResponse) {
    let headers = try await performAuthFor(application: .api)
    
    let result = try await networkClient.get(
      [Trip].self, url: networkRoutes.vehicleShortTermTripsURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (trips: result.data, response: result.response)
  }
}
