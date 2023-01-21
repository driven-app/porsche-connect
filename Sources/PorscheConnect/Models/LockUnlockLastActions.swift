import Foundation

/// Status of all doors on the car. Meant to be called after initiating a lock/unlock command.
public struct LockUnlockLastActions: Codable {
  public let vin: String
  public let doors: Doors
  public let rluResult: Int
  public let bsError: Int
}
