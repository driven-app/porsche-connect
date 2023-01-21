import Foundation

extension PorscheConnect {
  public func summary(vin: String) async throws -> (
    summary: Summary?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Summary.self, url: networkRoutes.vehicleSummaryURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (summary: result.data, response: result.response)
  }
}
