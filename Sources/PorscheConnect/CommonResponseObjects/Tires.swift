import Foundation

/// The status of all tires on the vehicle.
public struct Tires: Codable {
  public let frontLeft: Tire
  public let frontRight: Tire
  public let backLeft: Tire
  public let backRight: Tire
}

/// The status of a single tire on the vehicle.
public struct Tire: Codable {
  public let currentPressure: Pressure?
  public let optimalPressure: Pressure?
  public let differencePressure: Pressure?

  /// Can be any of:
  /// - `DIVERGENT`
  public let tirePressureDifferenceStatus: String
}
