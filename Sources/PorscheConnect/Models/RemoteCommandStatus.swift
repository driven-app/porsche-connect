import Foundation

public struct RemoteCommandStatus: Codable {

  public enum RemoteStatus: String {
    // TODO: handle failure status (when we see what one looks like in real world)
    case inProgress = "IN_PROGRESS"
    case success = "SUCCESS"
  }

  // MARK: Properties

  public let status: String

  // MARK: Computed Properties

  public var remoteStatus: RemoteStatus? {
    return RemoteStatus(rawValue: status)
  }
}
