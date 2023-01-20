import Foundation

import XCTest

@testable import PorscheConnect

final class ModelsMaintenanceItemTests: XCTestCase {
  
  func testMaintenanceItemsDecodingJsonIntoModel() {
    let maintenance = buildMaintenance()
    
    let serviceAccess = maintenance.serviceAccess
    XCTAssert(serviceAccess.access)
    
    let maintenanceItems = maintenance.items
    XCTAssertEqual(2, maintenanceItems.count)
    
    // Maintenance Item One
    
    let maintenanceItemOne = maintenanceItems.first!
    XCTAssertEqual("0003", maintenanceItemOne.id)
    
    XCTAssertEqual("Service", maintenanceItemOne.description.shortName)
    XCTAssertEqual("No service is due at the moment.", maintenanceItemOne.description.criticalityText)
    XCTAssertNil(maintenanceItemOne.description.longName)
    XCTAssertNil(maintenanceItemOne.description.notificationText)
    
    XCTAssertEqual(1, maintenanceItemOne.criticality)
    XCTAssertNil(maintenanceItemOne.remainingLifeTimeInDays)
    XCTAssertNil(maintenanceItemOne.remainingLifeTimePercentage)
    XCTAssertNil(maintenanceItemOne.remainingLifeTimeInKm)
    
    XCTAssertEqual("Service-Intervall", maintenanceItemOne.values.modelName)
    XCTAssertEqual("0", maintenanceItemOne.values.odometerLastReset)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.VisibilityState.visible, maintenanceItemOne.values.modelVisibilityState)
    XCTAssertEqual("1", maintenanceItemOne.values.criticality)
    XCTAssertEqual("0003", maintenanceItemOne.values.modelId)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.ModelState.active, maintenanceItemOne.values.modelState)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.Source.vehicle, maintenanceItemOne.values.source)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.Event.cyclic, maintenanceItemOne.values.event)
    
    // Maintenance Item Two
    
    let maintenanceItemTwo = maintenanceItems.last!
    XCTAssertEqual("0005", maintenanceItemTwo.id)

    XCTAssertEqual("Brake pads", maintenanceItemTwo.description.shortName)
    XCTAssertEqual("No service is due at the moment.", maintenanceItemTwo.description.criticalityText)
    XCTAssertEqual("Changing the brake pads", maintenanceItemTwo.description.longName)
    XCTAssertNil(maintenanceItemTwo.description.notificationText)
    
    XCTAssertEqual(1, maintenanceItemTwo.criticality)
    XCTAssertNil(maintenanceItemTwo.remainingLifeTimeInDays)
    XCTAssertNil(maintenanceItemTwo.remainingLifeTimePercentage)
    XCTAssertNil(maintenanceItemTwo.remainingLifeTimeInKm)
    
    XCTAssertEqual("Service Bremse", maintenanceItemTwo.values.modelName)
    XCTAssertEqual("0", maintenanceItemTwo.values.odometerLastReset)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.VisibilityState.visible, maintenanceItemTwo.values.modelVisibilityState)
    XCTAssertEqual("1", maintenanceItemTwo.values.criticality)
    XCTAssertEqual("0005", maintenanceItemTwo.values.modelId)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.ModelState.active, maintenanceItemTwo.values.modelState)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.Source.vehicle, maintenanceItemTwo.values.source)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.Event.cyclic, maintenanceItemTwo.values.event)
  }
  
  // MARK: - Private functions

  private func buildMaintenance() -> Maintenance {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601

    return try! decoder.decode(Maintenance.self, from: kMaintenanceItemsJson)
  }
}
