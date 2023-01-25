import Foundation

/// The status of all doors on the vehicle.
public struct Doors: Codable {
  public let frontLeft: DoorStatus
  public let frontRight: DoorStatus
  public let backLeft: DoorStatus
  public let backRight: DoorStatus
  public let frontTrunk: DoorStatus
  public let backTrunk: DoorStatus
  public let overallLockStatus: DoorStatus

  public enum DoorStatus: String, Codable {
    case closedAndLocked = "CLOSED_LOCKED"
    case closedAndUnlocked = "CLOSED_UNLOCKED"
    case openAndUnlocked = "OPEN_UNLOCKED"
    case invalid = "INVALID"
  }
}
