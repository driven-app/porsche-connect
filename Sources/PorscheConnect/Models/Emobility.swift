import CoreLocation
import Foundation

public struct Emobility: Codable {

  // MARK: Properties

  public let batteryChargeStatus: BatteryChargeStatus
  public let directCharge: DirectCharge
  public let directClimatisation: DirectClimatisation
  /// Can be any of:
  /// - `INSTANT_CHARGING`
  public let chargingStatus: String
  public let chargingProfiles: ChargingProfiles
  public let climateTimer: String?  // TBD when set
  public let timers: [Timer]?

  // MARK: -

  public struct BatteryChargeStatus: Codable {

    // MARK: Properties

    /// Can be any of:
    /// - `CONNECTED`
    /// - `DISCONNECTED`
    public let plugState: String
    /// Can be any of:
    /// - `LOCKED`
    /// - `UNLOCKED`
    public let lockState: String
    /// Can be any of:
    /// - `CHARGING`
    /// - `OFF`-
    public let chargingState: String
    /// Can be any of:
    /// - `IMMEDIATE`
    /// - `INVALID`
    public let chargingReason: String
    /// Can be any of:
    /// - `AVAILABLE`
    /// - `UNAVAILABLE`
    public let externalPowerSupplyState: String
    /// Can be any of:
    /// - `GREEN`
    /// - `NONE`
    public let ledColor: String
    /// Can be any of:
    /// - `BLINK`
    /// - `OFF`
    public let ledState: String
    /// Can be any of:
    /// - `AC`
    /// - `OFF`
    public let chargingMode: String
    public let stateOfChargeInPercentage: Double
    public let remainingChargeTimeUntil100PercentInMinutes: Int?
    public let remainingERange: RemainingERange
    public let remainingCRange: String?  // TBD while charging
    public let chargingTargetDateTime: String  //2021-02-19T01:09
    public let status: String?  // TBD while charging
    public let chargeRate: ChargeRate
    public let chargingPower: Double
    public let chargingInDCMode: Bool

    // MARK: -

    public struct RemainingERange: Codable {

      // MARK: Properties

      public let value: Double
      /// Can be any of:
      /// - `MILES`
      /// - `KILOMETERS`
      public let unit: String
      public let originalValue: Double
      public let originalUnit: String
      public let valueInKilometers: Int
      public let unitTranslationKey: String
    }

    // MARK: -

    public struct ChargeRate: Codable {

      // MARK: Properties

      public let value: Double
      /// Can be any of:
      /// - `MILES_PER_MIN`
      public let unit: String
      public let valueInKmPerHour: Double
      public let unitTranslationKey: String  // "EC.COMMON.UNIT.KM_PER_MIN"
    }
  }

  // MARK: -

  public struct DirectCharge: Codable {

    // MARK: Properties

    public let disabled: Bool
    public let isActive: Bool
  }

  // MARK: -

  public struct DirectClimatisation: Codable {

    // MARK: Properties

    /// Can be any of:
    /// - `OFF`
    public let climatisationState: String
    public let remainingClimatisationTime: String?  // TBD when set
    public let targetTemperature: String
    /// Can be any of:
    /// - `false`
    public let climatisationWithoutHVpower: String
    /// Can be any of:
    /// - `electric`
    public let heaterSource: String
  }

  // MARK: -

  public struct ChargingProfiles: Codable {

    // MARK: Properties

    public let currentProfileId: Int
    public let profiles: [Profile]
  }

  // MARK: -

  public struct Profile: Codable {

    // MARK: Properties

    public let profileId: Int
    public let profileName: String
    public let profileActive: Bool
    public let chargingOptions: ChargingOptions
    public let position: Position

    // MARK: -

    public struct ChargingOptions: Codable {

      // MARK: Properties

      public let minimumChargeLevel: Int
      public let smartChargingEnabled: Bool
      public let preferredChargingEnabled: Bool
      /// In the format "HH:MM"
      public let preferredChargingTimeStart: String
      /// In the format "HH:MM"
      public let preferredChargingTimeEnd: String
    }

    // MARK: -

    public struct Position: Codable {

      // MARK: Properties

      public let latitude: CLLocationDegrees
      public let longitude: CLLocationDegrees
    }
  }

  // MARK: -

  public struct Timer: Codable {

    // MARK: Properties

    public let timerID: String
    public let departureDateTime: String
    public let preferredChargingTimeEnabled: Bool
    public let preferredChargingStartTime: String?
    public let preferredChargingEndTime: String?
    public let frequency: String
    public let climatised: Bool
    public let weekDays: Weekdays?
    public let active: Bool
    public let chargeOption: Bool
    public let targetChargeLevel: Int
    public let climatisationTimer: Bool

    // MARK: -

    public struct Weekdays: Codable {

      // MARK: Properties

      public let SUNDAY: Bool
      public let MONDAY: Bool
      public let TUESDAY: Bool
      public let WEDNESDAY: Bool
      public let THURSDAY: Bool
      public let FRIDAY: Bool
      public let SATURDAY: Bool
    }
  }
}
