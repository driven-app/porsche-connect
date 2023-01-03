import Foundation

public struct Overview: Codable {

  public enum OverallOpenStatus: String, Codable {
    case OPEN, CLOSED
  }

  // MARK: Properties

  public let vin: String
  //  public let parkingTime: Date
  public let overallOpenStatus: OverallOpenStatus

}
