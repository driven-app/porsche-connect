import Foundation

public struct RemoteCommandAccepted: Codable {

  public enum RemoteCommand: Codable {
    case honkAndFlash, toggleDirectCharge, lock, unlock
  }

  public enum PcckErrorKey: String, Codable {
    case lockedFor60Minutes = "LOCKED_60_MINUTES", incorrectPin = "INCORRECT"
  }

  // MARK: Properties

  public var id: String? = nil
  public var requestId: String? = nil
  public var vin: String? = nil
  public var lastUpdated: Date? = nil
  public var remoteCommand: RemoteCommand?

  public var pcckErrorKey: PcckErrorKey? = nil
  public var pcckErrorMessage: String? = nil
  public var pcckErrorCode: String? = nil
  public var pcckIsBusinessError: Bool? = nil
  
  // MARK: Computed Properties

  // Porsche Connect remote command endpoints can return either an "id" or a "requestId"
  // or nothing (i.e. unlock credentials error)
  
  public var identifier: String? {
    return id ?? requestId ?? nil
  }
}
