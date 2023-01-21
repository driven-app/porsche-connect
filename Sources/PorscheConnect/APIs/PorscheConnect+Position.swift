import Foundation

extension PorscheConnect {
  public func position(vin: String) async throws -> (
    position: Position?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Position.self, url: networkRoutes.vehiclePositionURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (position: result.data, response: result.response)
  }
}
