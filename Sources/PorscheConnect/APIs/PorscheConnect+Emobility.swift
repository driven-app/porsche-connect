import Foundation

extension PorscheConnect {
  public func emobility(vin: String, capabilities: Capabilities) async throws -> (
    emobility: Emobility?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Emobility.self,
      url: networkRoutes.vehicleEmobilityURL(vin: vin, capabilities: capabilities),
      headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (emobility: result.data, response: result.response)
  }
}
