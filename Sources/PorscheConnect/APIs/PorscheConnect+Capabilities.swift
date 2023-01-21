import Foundation

extension PorscheConnect {
  public func capabilities(vin: String) async throws -> (
    capabilities: Capabilities?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Capabilities.self, url: networkRoutes.vehicleCapabilitiesURL(vin: vin),
      headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (capabilities: result.data, response: result.response)
  }
}
