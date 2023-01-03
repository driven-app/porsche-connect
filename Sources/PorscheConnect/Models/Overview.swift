import Foundation

public struct Overview: Codable {

  public enum OpenStatus: String, Codable {
    case open = "OPEN", closed = "CLOSED", unsupported = "UNSUPPORTED"
  }

  // MARK: Properties

  public let vin: String
  //  public let parkingTime: Date
  public let overallOpenStatus: OpenStatus
}

