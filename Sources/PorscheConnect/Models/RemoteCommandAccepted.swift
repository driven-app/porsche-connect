import Foundation

public struct RemoteCommandAccepted: Codable {

  public enum RemoteCommand: Codable {
    case honkAndFlash  //, lockAndUnlock
  }

  // MARK: Properties

  public let id: String
  public let lastUpdated: Date
  public var remoteCommand: RemoteCommand?
}
