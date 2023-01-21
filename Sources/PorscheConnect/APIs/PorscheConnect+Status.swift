import Foundation

extension PorscheConnect {
  public func status(vin: String) async throws -> (
    status: Status?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .api)

    let result = try await networkClient.get(
      Status.self, url: networkRoutes.vehicleStatusURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (status: result.data, response: result.response)
  }
}
