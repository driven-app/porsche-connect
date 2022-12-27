import CoreLocation
import Foundation
import SwiftUI

public struct PorscheAuth: Codable {

  // MARK: Properties

  public let accessToken: String
  public let idToken: String
  public let tokenType: String
  public let expiresIn: Double
  public let expiresAt: Date

  public var apiKey: String? {
    let idTokenComponents = idToken.components(separatedBy: ".")
    let paddedBase64EncodedString = idTokenComponents[1].padding(
      toLength: ((idTokenComponents[1].count + 3) / 4) * 4, withPad: "=", startingAt: 0)

    if let decodedString = String(
      data: Data(base64Encoded: paddedBase64EncodedString) ?? kBlankData, encoding: .utf8),
      let data = decodedString.data(using: .utf8),
      let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        as? [String: Any],
      let apiKey = dict["aud"] as? String
    {
      return apiKey
    } else {
      return nil
    }
  }

  public var expired: Bool {
    return Date() > expiresAt
  }

  // MARK: Lifecycle

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.accessToken = try values.decode(String.self, forKey: .accessToken)
    self.idToken = try values.decode(String.self, forKey: .idToken)
    self.tokenType = try values.decode(String.self, forKey: .tokenType)
    self.expiresIn = try values.decode(Double.self, forKey: .expiresIn)
    self.expiresAt = Date().addingTimeInterval(self.expiresIn)
  }

  public init(accessToken: String, idToken: String, tokenType: String, expiresIn: Double) {
    self.accessToken = accessToken
    self.idToken = idToken
    self.tokenType = tokenType
    self.expiresIn = expiresIn
    self.expiresAt = Date().addingTimeInterval(self.expiresIn)
  }
}

// MARK: -

public struct Vehicle: Codable {

  // MARK: Properties

  public let vin: String
  public let modelDescription: String
  public let modelType: String
  public let modelYear: String
  public let exteriorColor: String?
  public let exteriorColorHex: String?
  public let attributes: [VehicleAttribute]?
  public let pictures: [VehiclePicture]?

  // MARK: Computed Properties

  public var color: Color? {
    if let hex = exteriorColorHex {
      return Color(hex: hex)
    }
    return nil
  }

  // MARK: -

  public struct VehicleAttribute: Codable {

    // MARK: Properties

    public let name: String
    public let value: String
  }

  // MARK: -

  public struct VehiclePicture: Codable {

    // MARK: Properties

    public let url: URL
    public let view: String
    public let size: Int
    public let width: Int
    public let height: Int
    public let transparent: Bool
    public let placeholder: String?
  }

  // MARK: - Public

  public init(
    vin: String, modelDescription: String, modelType: String, modelYear: String,
    exteriorColor: String?, exteriorColorHex: String?, attributes: [VehicleAttribute]?,
    pictures: [VehiclePicture]?
  ) {
    self.vin = vin
    self.modelDescription = modelDescription
    self.modelType = modelType
    self.modelYear = modelYear
    self.exteriorColor = exteriorColor
    self.exteriorColorHex = exteriorColorHex
    self.attributes = attributes
    self.pictures = pictures
  }

  public init(vin: String, modelDescription: String, modelType: String, modelYear: String) {
    self.vin = vin
    self.modelDescription = modelDescription
    self.modelType = modelType
    self.modelYear = modelYear
    self.exteriorColor = nil
    self.exteriorColorHex = nil
    self.attributes = nil
    self.pictures = nil
  }

  public init(vin: String) {
    self.vin = vin
    self.modelDescription = kBlankString
    self.modelType = kBlankString
    self.modelYear = kBlankString
    self.exteriorColor = nil
    self.exteriorColorHex = nil
    self.attributes = nil
    self.pictures = nil
  }
}

// MARK: -

public struct Summary: Codable {

  // MARK: Properties

  public let modelDescription: String
  public let nickName: String?
}

// MARK: -

public struct Position: Codable {

  // MARK: Properties

  public let carCoordinate: CarCoordinate
  public let heading: CLLocationDirection

  // MARK: -

  public struct CarCoordinate: Codable {

    // MARK: Properties

    public let geoCoordinateSystem: String
    public let latitude: CLLocationDegrees
    public let longitude: CLLocationDegrees
  }
}

// MARK: -

public struct Capabilities: Codable {

  // MARK: Properties

  public let displayParkingBrake: Bool
  public let needsSPIN: Bool
  public let hasRDK: Bool
  public let engineType: String
  public let carModel: String
  public let onlineRemoteUpdateStatus: OnlineRemoteUpdateStatus
  public let heatingCapabilities: HeatingCapabilities
  public let steeringWheelPosition: String
  public let hasHonkAndFlash: Bool

  // MARK: -

  public struct OnlineRemoteUpdateStatus: Codable {

    // MARK: Properties

    public let editableByUser: Bool
    public let active: Bool

    // MARK: - Public

    public init(editableByUser: Bool, active: Bool) {
      self.editableByUser = editableByUser
      self.active = active
    }
  }

  // MARK: -

  public struct HeatingCapabilities: Codable {

    // MARK: Properties

    public let frontSeatHeatingAvailable: Bool
    public let rearSeatHeatingAvailable: Bool

    // MARK: - Public

    public init(frontSeatHeatingAvailable: Bool, rearSeatHeatingAvailable: Bool) {
      self.frontSeatHeatingAvailable = frontSeatHeatingAvailable
      self.rearSeatHeatingAvailable = rearSeatHeatingAvailable
    }
  }

  // MARK: - Public

  public init(engineType: String, carModel: String) {
    self.displayParkingBrake = false
    self.needsSPIN = false
    self.hasRDK = false
    self.engineType = engineType
    self.carModel = carModel
    self.steeringWheelPosition = kBlankString
    self.hasHonkAndFlash = false
    self.onlineRemoteUpdateStatus = OnlineRemoteUpdateStatus(editableByUser: true, active: true)
    self.heatingCapabilities = HeatingCapabilities(
      frontSeatHeatingAvailable: true, rearSeatHeatingAvailable: false)
  }
}

// MARK: -

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

// MARK -

public struct RemoteCommandAccepted: Codable {

  public enum RemoteCommand: Codable {
    case honkAndFlash  //, lockAndUnlock
  }

  // MARK: Properties

  public let id: String
  public let lastUpdated: Date
  public var remoteCommand: RemoteCommand?
}

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
