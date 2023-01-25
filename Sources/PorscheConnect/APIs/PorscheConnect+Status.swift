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

// MARK: - Response types

public struct Status: Codable {
  public let vin: String

  // TODO: These properties are returned but it's unclear what format they are in.
  //  let fuelLevel
  //  let oilLevel

  public let batteryLevel: GenericValue
  public let mileage: Distance
  public let overallLockStatus: String
  public let serviceIntervals: ServiceIntervals
  public let remainingRanges: RemainingRanges
}
