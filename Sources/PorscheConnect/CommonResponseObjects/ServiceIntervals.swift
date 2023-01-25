import Foundation

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

