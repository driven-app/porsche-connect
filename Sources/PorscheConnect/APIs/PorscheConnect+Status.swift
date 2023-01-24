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

  // MARK: Properties

  public let vin: String

  // TODO: These properties are returned but it's unclear what format they are in.
  //  let fuelLevel
  //  let oilLevel

  public let batteryLevel: GenericValue
  public let mileage: Distance
  public let overallLockStatus: String

  public struct ServiceIntervals: Codable {
    public struct OilService: Codable {
      // TODO: These properties are returned but it's unclear what format they are in.
      //  let distance:
      //  let time
    }
    public let oilService: OilService
    public struct Inspection: Codable {
      public let distance: Distance
      public let time: GenericValue
    }
    public let inspection: Inspection
  }
  public let serviceIntervals: ServiceIntervals

  public struct RemainingRanges: Codable {
    public struct Range: Codable {
      public let distance: Distance?
      public let engineType: String
    }
    public let conventionalRange: Range
    public let electricalRange: Range
  }
  public let remainingRanges: RemainingRanges

  // MARK: - Common types

  public struct GenericValue: Codable {
    public let value: Double
    public let unit: String
    public let unitTranslationKey: String
    public let unitTranslationKeyV2: String
  }
}
