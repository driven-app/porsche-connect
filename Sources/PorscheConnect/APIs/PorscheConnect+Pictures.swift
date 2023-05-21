import CoreLocation
import Foundation

extension PorscheConnect {
  public func pictures(vin: String) async throws -> (
    pictures: Pictures?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .api)

    let result = try await networkClient.get(
      Pictures.self, url: networkRoutes.vehiclePicturesURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (pictures: result.data, response: result.response)
  }
}

// MARK: - Response types

public struct Pictures: Codable {
  public let vin: String
  public let pictures: [Picture]
}
