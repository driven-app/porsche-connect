import Foundation

extension PorscheConnect {
  public func stored(vin: String) async throws -> (
    stored: Stored?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .api)

    let result = try await networkClient.get(
      Stored.self, url: networkRoutes.vehicleStoredURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (stored: result.data, response: result.response)
  }
}

// MARK: - Response types

public struct Stored: Codable {
  public let vin: String

  // TODO: These properties are returned but it's unclear what format they are in.
  //  let oilLevel
  //  let fuelLevel

  public let batteryLevel: GenericValue
  public let remainingRanges: RemainingRanges
  public let mileage: Distance

  /// Can be any of:
  /// - `OFF`
  public let parkingLight: String
  // TODO: parkingLightStatus is returned but format is unknown.

  /// Can be any of:
  /// - `ACTIVE`
  public let parkingBreak: String
  // TODO: parkingBreakStatus is returned but format is unknown.

  public let doors: Doors
  public let serviceIntervals: ServiceIntervals
  public let tires: Tires
  public let windows: Windows

  /// Example format: `23.01.2023 23:04:04`
  public let parkingTime: String?

  /// Can be any of:
  /// - `CLOSED`
  public let overallOpenStatus: String
}
