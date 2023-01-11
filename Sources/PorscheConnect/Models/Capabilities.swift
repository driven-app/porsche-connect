import Foundation

public struct Capabilities: Codable {

  // MARK: Properties

  public let displayParkingBrake: Bool
  public let needsSPIN: Bool
  public let hasRDK: Bool
  public let engineType: String
  public let carModel: String
  public let onlineRemoteUpdateStatus: OnlineRemoteUpdateStatus?
  public let heatingCapabilities: HeatingCapabilities
  public let steeringWheelPosition: String
  public let hasHonkAndFlash: Bool?

  // MARK: -

  public struct OnlineRemoteUpdateStatus: Codable {

    // MARK: Properties

    public let editableByUser: Bool
    public let active: Bool

    // MARK: - Public

    public init(editableByUser: Bool, active: Bool) {
      self.editableByUser = editableByUser
      self.active = active
    }
  }

  // MARK: -

  public struct HeatingCapabilities: Codable {

    // MARK: Properties

    public let frontSeatHeatingAvailable: Bool
    public let rearSeatHeatingAvailable: Bool

    // MARK: - Public

    public init(frontSeatHeatingAvailable: Bool, rearSeatHeatingAvailable: Bool) {
      self.frontSeatHeatingAvailable = frontSeatHeatingAvailable
      self.rearSeatHeatingAvailable = rearSeatHeatingAvailable
    }
  }

  // MARK: - Public

  public init(engineType: String, carModel: String) {
    self.displayParkingBrake = false
    self.needsSPIN = false
    self.hasRDK = false
    self.engineType = engineType
    self.carModel = carModel
    self.steeringWheelPosition = kBlankString
    self.hasHonkAndFlash = false
    self.onlineRemoteUpdateStatus = OnlineRemoteUpdateStatus(editableByUser: true, active: true)
    self.heatingCapabilities = HeatingCapabilities(
      frontSeatHeatingAvailable: true, rearSeatHeatingAvailable: false)
  }
}
