import Foundation

// MARK: -

public struct Trip: Codable {
  
  public enum TripType: String, Codable {
    case shortTerm = "SHORT_TERM", longTerm = "LONG_TERM"
  }
  
  // MARK: Properties
  
  public let type: TripType
  public let id: Int
  public let travelTime: Int // TODO: Consider using Swift 5.7's Duration struct
  public let timestamp: Date
  public let averageSpeed: AverageSpeed
  public let averageFuelConsumption: AverageFuelConsumption
  public let averageElectricEngineConsumption: AverageElectricEngineConsumption
  public let tripMileage: TripMileage
  public let startMileage: TripMileage
  public let endMileage: TripMileage
  public let zeroEmissionDistance: TripMileage
  
  // MARK: -

  public struct AverageSpeed: Codable {
    
    // MARK: Properties

    public let value: Double
    public let unit: SpeedUnit
    public let valueInKmh: Double
    public let unitTranslationKey: String
    public let unitTranslationKeyV2: String
  }
  
  // MARK: -
  
  public struct AverageFuelConsumption: Codable {
    
    public enum FuelConsumptionUnit: String, Codable {
      case litersPer100Km = "LITERS_PER_100_KM" //TODO: add imperial units
    }
    
    // MARK: Properties

    public let value: Double
    public let unit: FuelConsumptionUnit
    public let valueInLitersPer100Km: Double
    public let unitTranslationKey: String
    public let unitTranslationKeyV2: String
  }
  
  // MARK: -
  
  public struct AverageElectricEngineConsumption: Codable {
    
    public enum ElectricConsumptionUnit: String, Codable {
      case kilowattHoursPer100Km = "KWH_PER_100KM" //TODO: add imperial units
    }
    
    // MARK: Properties

    public let value: Double
    public let unit: ElectricConsumptionUnit
    public let valueKwhPer100Km: Double
    public let unitTranslationKey: String
    public let unitTranslationKeyV2: String
  }
  
  // MARK: -
  
  public struct TripMileage: Codable {
    
    // MARK: Properties

    public let value: Int
    public let unit: DistanceUnit
    public let originalValue: Int
    public let originalUnit: DistanceUnit
    public let valueInKilometers: Int
    public let unitTranslationKey: String
    public let unitTranslationKeyV2: String
  }
}

// MARK: -

public enum DistanceUnit: String, Codable {
  case kilometers = "KILOMETERS", miles = "MILES"
}

// MARK: -

public enum SpeedUnit: String, Codable {
  case kmh = "KMH", mph = "MPH"
}
