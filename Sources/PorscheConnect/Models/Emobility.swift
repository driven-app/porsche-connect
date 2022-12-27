import CoreLocation
import Foundation

public struct Emobility: Codable {

  // MARK: Properties

  public let batteryChargeStatus: BatteryChargeStatus
  public let directCharge: DirectCharge
  public let directClimatisation: DirectClimatisation
  public let chargingStatus: String
  public let chargingProfiles: ChargingProfiles
  public let climateTimer: String?  // TBD when set
  public let timers: [Timer]?

  // MARK: -

  public struct BatteryChargeStatus: Codable {

    // MARK: Properties

    public let plugState: String
    public let lockState: String
    public let chargingState: String
    public let chargingReason: String
    public let externalPowerSupplyState: String
    public let ledColor: String
    public let ledState: String
    public let chargingMode: String
    public let stateOfChargeInPercentage: Int
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

      public let value: Int
      public let unit: String
      public let originalValue: Int
      public let originalUnit: String
      public let valueInKilometers: Int
      public let unitTranslationKey: String
    }

    // MARK: -

    public struct ChargeRate: Codable {

      // MARK: Properties

      public let value: Double
      public let unit: String
      public let valueInKmPerHour: Int
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

    public let climatisationState: String
    public let remainingClimatisationTime: String?  // TBD when set
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
      public let preferredChargingTimeStart: String
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
