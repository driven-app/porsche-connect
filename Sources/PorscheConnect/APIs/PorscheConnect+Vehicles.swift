import Foundation

extension PorscheConnect {

  public func vehicles() async throws -> (vehicles: [Vehicle]?, response: HTTPURLResponse) {
    let headers = try await performAuthFor(application: .api)

    let result = try await networkClient.get(
      [Vehicle].self, url: networkRoutes.vehiclesURL, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (vehicles: result.data, response: result.response)
  }
}
