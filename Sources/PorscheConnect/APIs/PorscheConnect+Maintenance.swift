import Foundation

extension PorscheConnect {
  
  public func maintenance(vin: String) async throws -> (maintenance: Maintenance?, response: HTTPURLResponse) {
    let headers = try await performAuthFor(application: .api)
    
    let result = try await networkClient.get(
      Maintenance.self, url: networkRoutes.vehicleMaintenanceURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (maintenance: result.data, response: result.response)
  }
}

// MARK: - Response types

public struct Maintenance: Codable {
  
  // MARK: Properties
  
  public let serviceAccess: ServiceAccess
  public let items: [MaintenanceItem]
  
  // MARK: Mappings
  
  enum CodingKeys: String, CodingKey {
    case serviceAccess = "serviceAccess"
    case items = "data"
  }
  
  // MARK: -
  
  public struct MaintenanceItem: Codable {
    
    // MARK: Properties
    
    public let id: String
    public let description: Description
    public let criticality: Int
    public let remainingLifeTimeInDays: Int?
    public let remainingLifeTimePercentage: Int?
    public let remainingLifeTimeInKm: Int?
    public let values: MaintenanceItemValues
  }
  
  // MARK: -
  
  public struct MaintenanceItemValues: Codable {
    
    public enum VisibilityState: String, Codable {
      case visible = "visible" // TODO: What's the other valid states?
    }
    
    public enum ModelState: String, Codable {
      case active = "active", inactive = "inactive"
    }
    
    public enum Source: String, Codable {
      case vehicle = "Vehicle"
    }
    
    public enum Event: String, Codable {
      case cyclic = "CYCLIC" // TODO: What's the other valid states?
    }
    
    // MARK: Properties
    
    public let modelName: String
    public let odometerLastReset: String
    public let modelVisibilityState: VisibilityState
    public let criticality: String
    public let modelId: String
    public let modelState: ModelState
    public let source: Source
    public let event: Event
  }
  
  // MARK: -
  
  public struct Description: Codable {
    
    // MARK: Properties
    
    public let shortName: String
    public let longName: String?
    public let criticalityText: String
    public let notificationText: String?
  }
  
  // MARK: -
  
  public struct ServiceAccess: Codable {
    
    // MARK: Properties
    
    public let access: Bool
  }
}
