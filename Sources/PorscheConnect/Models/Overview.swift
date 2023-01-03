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
  public let parkingTime: Date
  public let batteryLevel: BatteryLevel?
  public let remainingRanges: RemaingRanges
  public let mileage: Distance
  public let parkingLight: ParkingLight
  public let tires: Tires
  public let windows: Windows
  public let serviceIntervals: ServiceIntervals
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

  public struct Time: Codable {

    // MARK: Properties

    public let value: Int
    public let unit: String
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

  public struct ServiceIntervals: Codable {

    // MARK: Properties

    public let inspection: Inspection

    // MARK: -

    public struct Inspection: Codable {

      // MARK: Properties

      public let distance: Distance?
      public let time: Time?
    }
  }

  // MARK: -

  public struct Tires: Codable {

    // MARK: Properties

    public let frontLeft: TirePressure
    public let frontRight: TirePressure
    public let backLeft: TirePressure
    public let backRight: TirePressure

    // MARK: -

    public struct TirePressure: Codable {

      public enum DifferenceStatus: String, Codable {
        case unknown = "UNKNOWN"
      }

      // MARK: Properties

      public let currentPressure: Double?
      public let optimalPressure: Double?
      public let differencePressure: Double?
      public let tirePressureDifferenceStatus: DifferenceStatus
    }
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
