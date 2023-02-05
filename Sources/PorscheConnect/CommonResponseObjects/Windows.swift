import Foundation

/// The status of all windows on the vehicle.
public struct Windows: Codable {
  public let frontLeft: Status
  public let frontRight: Status
  public let backLeft: Status
  public let backRight: Status
  public let roof: Status
  public let maintenanceHatch: Status

  public struct Sunroof: Codable {
    public let status: Status
    public let positionInPercent: Double?
  }
  public let sunroof: Sunroof

  public enum Status: String, Codable {
    case closed = "CLOSED"
    case open = "OPEN"
    case unsupported = "UNSUPPORTED"
  }
}
