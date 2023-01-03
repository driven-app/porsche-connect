import Foundation

public struct Overview: Codable {

  public enum PhysicalStatus: String, Codable {
    case open = "OPEN", closed = "CLOSED", unsupported = "UNSUPPORTED"
  }

  public enum ParkingLight: String, Codable {
    case off = "OFF", on = "ON"
  }

  // MARK: Properties

  public let vin: String
  public let batteryLevel: BatteryLevel?
  public let remainingRanges: RemaingRanges
  public let mileage: Distance
  public let parkingLight: ParkingLight
  public let windows: Windows
  public let parkingTime: Date
  public let overallOpenStatus: PhysicalStatus

  // MARK: -

  public struct BatteryLevel: Codable {

    // MARK: Properties

    public let value: Int
    public let unit: String
    public let unitTranslationKey: String
    public let unitTranslationKeyV2: String
  }

  // MARK: -

  public struct RemaingRanges: Codable {

    // MARK: Properties

    public let electricalRange: ElectricalRange
  }

  // MARK: -

  public struct Distance: Codable {

    // MARK: Properties

    public let value: Int
    public let unit: String
    public let originalValue: Int
    public let originalUnit: String
    public let valueInKilometers: Int
    public let unitTranslationKey: String
    public let unitTranslationKeyV2: String
  }

  // MARK: -

  public struct ElectricalRange: Codable {

    public enum EngineType: String, Codable {
      case electric = "ELECTRIC"
    }

    // MARK: Properties

    public let distance: Distance?
    public let engineType: EngineType
    public let isPrimary: Bool
  }

  // MARK: -

  public struct Windows: Codable {

    // MARK: Properties

    public let frontLeft: PhysicalStatus
    public let frontRight: PhysicalStatus
    public let backLeft: PhysicalStatus
    public let backRight: PhysicalStatus
    public let roof: PhysicalStatus
    public let maintenanceHatch: PhysicalStatus
    public let sunroof: Sunroof

    // MARK: -

    public struct Sunroof: Codable {

      // MARK: Properties

      public let status: PhysicalStatus
      public let positionInPercent: Int?

    }
  }
}
