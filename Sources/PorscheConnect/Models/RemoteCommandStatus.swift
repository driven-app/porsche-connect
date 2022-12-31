import Foundation

public struct RemoteCommandStatus: Codable {

  public enum RemoteStatus: String {
    case inProgress = "IN_PROGRESS"
    case success = "SUCCESS"
    case failure = "FAILURE"
  }

  // MARK: Properties

  public let status: String
  public let errorType: String?

  // MARK: Computed Properties

  public var remoteStatus: RemoteStatus? {
    return RemoteStatus(rawValue: status)
  }
}
