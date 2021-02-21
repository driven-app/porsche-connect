import XCTest
@testable import PorscheConnect

final class PorscheConnectCarControlTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: Application = .CarControl
  let vehicle = Vehicle(vin: "A1234")
  let capabilites = buildCapabilites()
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(username: "homer.simpson@icloud.example", password: "Duh!", environment: .Test)
    self.connect.auths[application] = kTestPorschePortalAuth
  }

  // MARK: - Summary Tests
  
  func testSummaryAuthRequiredSuccessful() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    
    mockNetworkRoutes.mockGetSummarySuccessful(router: MockServer.shared.router)
    
    XCTAssertFalse(self.connect.authorized(application: application))
    
    connect.summary(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (summary, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(summary)
        self.assertSummary(summary!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testSummaryNoAuthRequiredSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetSummarySuccessful(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))

    connect.summary(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (summary, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(summary)
        self.assertSummary(summary!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testSummaryNoAuthRequiredFailure() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetSummaryFailure(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))
    
    connect.summary(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testSummaryAuthRequiredAuthFailure() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)

    XCTAssertFalse(connect.authorized(application: application))
    
    connect.summary(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssertFalse(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  // MARK: - Position Tests
  
  func testPositionAuthRequiredSuccessful() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    
    mockNetworkRoutes.mockGetPositionSuccessful(router: MockServer.shared.router)

    XCTAssertFalse(self.connect.authorized(application: application))
    
    connect.position(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (position, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(position)
        self.assertPosition(position!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testPositionNoAuthRequiredSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetPositionSuccessful(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))

    connect.position(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (position, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(position)
        self.assertPosition(position!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testPositionNoAuthRequiredFailure() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetPositionFailure(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))
    
    connect.position(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testPositionAuthRequiredAuthFailure() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)

    XCTAssertFalse(connect.authorized(application: application))
    
    connect.position(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssertFalse(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  // MARK: - Capabilities Tests
  
  func testCapabilitiesAuthRequiredSuccessful() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    
    mockNetworkRoutes.mockGetCapabilitiesSuccessful(router: MockServer.shared.router)

    XCTAssertFalse(self.connect.authorized(application: application))
    
    connect.capabilities(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (capability, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(capability)
        self.assertCapabilities(capability!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testCapabilitiesNoAuthRequiredSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetCapabilitiesSuccessful(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))

    connect.capabilities(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (capability, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(capability)
        self.assertCapabilities(capability!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testCapabilitiesNoAuthRequiredFailure() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetCapabilitiesFailure(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))
    
    connect.capabilities(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testCapabilitiesAuthRequiredAuthFailure() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)

    XCTAssertFalse(connect.authorized(application: application))
    
    connect.capabilities(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssertFalse(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  // MARK: - Emobility Tests
  
  func testEmobilityAuthRequiredSuccessful() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    
    mockNetworkRoutes.mockGetEmobilitySuccessful(router: MockServer.shared.router)

    XCTAssertFalse(self.connect.authorized(application: application))
    
    connect.emobility(vehicle: vehicle, capabilities: capabilites) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (emobility, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(emobility)
        self.assertEmobility(emobility!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testEmobilityNoAuthRequiredSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetEmobilitySuccessful(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))

    connect.emobility(vehicle: vehicle, capabilities: capabilites) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (emobility, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(emobility)
        self.assertEmobility(emobility!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testEmobilityNoAuthRequiredFailure() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetEmobilityFailure(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))
    
    connect.emobility(vehicle: vehicle, capabilities: capabilites) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testEmobilityAuthRequiredAuthFailure() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)

    XCTAssertFalse(connect.authorized(application: application))
    
    connect.emobility(vehicle: vehicle, capabilities: capabilites) { result in
      expectation.fulfill()
      XCTAssertFalse(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  // MARK: - Private functions
  
  private func assertSummary(_ summary: Summary) {
    XCTAssertEqual("Taycan 4S", summary.modelDescription)
    XCTAssertEqual("211-D-12345", summary.nickName)
  }
  
  private func assertPosition(_ position: Position) {
    XCTAssertEqual(68, position.heading)
    let carCoordinate = position.carCoordinate
    
    XCTAssertEqual("WGS84", carCoordinate.geoCoordinateSystem)
    XCTAssertEqual(53.395367, carCoordinate.latitude)
    XCTAssertEqual(-6.389296, carCoordinate.longitude)
  }
  
  private func assertCapabilities(_ capabilities: Capabilities) {
    XCTAssertNotNil(capabilities.heatingCapabilities)
    XCTAssertNotNil(capabilities.onlineRemoteUpdateStatus)
    XCTAssertTrue(capabilities.displayParkingBrake)
    XCTAssertTrue(capabilities.needsSPIN)
    XCTAssertTrue(capabilities.hasRDK)
    XCTAssertEqual("BEV", capabilities.engineType)
    XCTAssertEqual("J1", capabilities.carModel)
    XCTAssertTrue(capabilities.onlineRemoteUpdateStatus.editableByUser)
    XCTAssertTrue(capabilities.onlineRemoteUpdateStatus.active)
    XCTAssertTrue(capabilities.heatingCapabilities.frontSeatHeatingAvailable)
    XCTAssertFalse(capabilities.heatingCapabilities.rearSeatHeatingAvailable)
    XCTAssertEqual("RIGHT", capabilities.steeringWheelPosition)
    XCTAssertTrue(capabilities.hasHonkAndFlash)
  }
  
  private func assertEmobility(_ emobility: Emobility) {
    XCTAssertNotNil(emobility.batteryChargeStatus)
    XCTAssertNotNil(emobility.directCharge)
    XCTAssertNotNil(emobility.directClimatisation)
    
    let batteryChargeStatus = emobility.batteryChargeStatus
    
    XCTAssertEqual("DISCONNECTED", batteryChargeStatus.plugState)
    XCTAssertEqual("UNLOCKED", batteryChargeStatus.lockState)
    XCTAssertEqual("OFF", batteryChargeStatus.chargingState)
    XCTAssertEqual("INVALID", batteryChargeStatus.chargingReason)
    XCTAssertEqual("UNAVAILABLE", batteryChargeStatus.externalPowerSupplyState)
    XCTAssertEqual("NONE", batteryChargeStatus.ledColor)
    XCTAssertEqual("OFF", batteryChargeStatus.ledState)
    XCTAssertEqual("OFF", batteryChargeStatus.chargingMode)
    XCTAssertEqual(56, batteryChargeStatus.stateOfChargeInPercentage)
    XCTAssertNil(batteryChargeStatus.remainingChargeTimeUntil100PercentInMinutes)
    
    XCTAssertNotNil(batteryChargeStatus.remainingERange)
    let remainingERange = batteryChargeStatus.remainingERange
    XCTAssertEqual(191, remainingERange.value)
    XCTAssertEqual("KILOMETER", remainingERange.unit)
    XCTAssertEqual(191, remainingERange.originalValue)
    XCTAssertEqual("KILOMETER", remainingERange.originalUnit)
    XCTAssertEqual(191, remainingERange.valueInKilometers)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", remainingERange.unitTranslationKey)
    
    XCTAssertNil(batteryChargeStatus.remainingCRange)
    XCTAssertEqual("2021-02-19T01:09", batteryChargeStatus.chargingTargetDateTime)
    XCTAssertNil(batteryChargeStatus.status)
    
    XCTAssertNotNil(batteryChargeStatus.chargeRate)
    let chargeRate = batteryChargeStatus.chargeRate
    XCTAssertEqual(0, chargeRate.value)
    XCTAssertEqual("KM_PER_MIN", chargeRate.unit)
    XCTAssertEqual(0, chargeRate.valueInKmPerHour)
    XCTAssertEqual("EC.COMMON.UNIT.KM_PER_MIN", chargeRate.unitTranslationKey)
    
    XCTAssertEqual(0, batteryChargeStatus.chargingPower)
    XCTAssertFalse(batteryChargeStatus.chargingInDCMode)
    
    let directCharge = emobility.directCharge
    XCTAssertFalse(directCharge.disabled)
    XCTAssertFalse(directCharge.isActive)
    
    let directClimatisation = emobility.directClimatisation
    XCTAssertEqual("OFF", directClimatisation.climatisationState)
    XCTAssertNil(directClimatisation.remainingClimatisationTime)
    
    XCTAssertEqual("NOT_CHARGING", emobility.chargingStatus)
    
    XCTAssertNotNil(emobility.chargingProfiles)
    let chargingProfiles = emobility.chargingProfiles
    XCTAssertEqual(4, chargingProfiles.currentProfileId)
    XCTAssertNotNil(chargingProfiles.profiles)
    XCTAssertEqual(2, chargingProfiles.profiles.count)
    
    let chargingProfile1 = chargingProfiles.profiles[0]
    XCTAssertNotNil(chargingProfile1)
    XCTAssertEqual(4, chargingProfile1.profileId)
    XCTAssertEqual("Allgemein", chargingProfile1.profileName)
    XCTAssertTrue(chargingProfile1.profileActive)
    
    XCTAssertNotNil(chargingProfile1.chargingOptions)
    let chargingOptionsForChargingProfile1 = chargingProfile1.chargingOptions
    XCTAssertEqual(100, chargingOptionsForChargingProfile1.minimumChargeLevel)
    XCTAssertTrue(chargingOptionsForChargingProfile1.smartChargingEnabled)
    XCTAssertFalse(chargingOptionsForChargingProfile1.preferredChargingEnabled)
    XCTAssertEqual("00:00", chargingOptionsForChargingProfile1.preferredChargingTimeStart)
    XCTAssertEqual("06:00", chargingOptionsForChargingProfile1.preferredChargingTimeEnd)
    
    XCTAssertNotNil(chargingProfile1.position)
    let positionForChargingProfile1 = chargingProfile1.position
    XCTAssertEqual(0, positionForChargingProfile1.latitude)
    XCTAssertEqual(0, positionForChargingProfile1.longitude)
    
    let chargingProfile2 = chargingProfiles.profiles[1]
    XCTAssertNotNil(chargingProfile2)
    XCTAssertEqual(5, chargingProfile2.profileId)
    XCTAssertEqual("HOME", chargingProfile2.profileName)
    XCTAssertTrue(chargingProfile2.profileActive)
    
    XCTAssertNotNil(chargingProfile2.chargingOptions)
    let chargingOptionsForChargingProfile2 = chargingProfile2.chargingOptions
    XCTAssertEqual(25, chargingOptionsForChargingProfile2.minimumChargeLevel)
    XCTAssertFalse(chargingOptionsForChargingProfile2.smartChargingEnabled)
    XCTAssertTrue(chargingOptionsForChargingProfile2.preferredChargingEnabled)
    XCTAssertEqual("23:00", chargingOptionsForChargingProfile2.preferredChargingTimeStart)
    XCTAssertEqual("08:00", chargingOptionsForChargingProfile2.preferredChargingTimeEnd)
    
    XCTAssertNotNil(chargingProfile2.position)
    let positionForChargingProfile2 = chargingProfile2.position
    XCTAssertEqual(53.376328, positionForChargingProfile2.latitude)
    XCTAssertEqual(-6.332705, positionForChargingProfile2.longitude)
    
    XCTAssertNil(emobility.climateTimer)
    
    XCTAssertNotNil(emobility.timers)
    XCTAssertEqual(1, emobility.timers!.count)
    
    let timer = emobility.timers![0]
    XCTAssertNotNil(timer)
    XCTAssertEqual("1", timer.timerID)
    XCTAssertEqual("2021-02-20T07:00:00.000Z", timer.departureDateTime)
    XCTAssertFalse(timer.preferredChargingTimeEnabled)
    XCTAssertNil(timer.preferredChargingStartTime)
    XCTAssertNil(timer.preferredChargingEndTime)
    XCTAssertEqual("CYCLIC", timer.frequency)
    XCTAssertFalse(timer.climatised)
    XCTAssertTrue(timer.active)
    XCTAssertTrue(timer.chargeOption)
    XCTAssertEqual(80, timer.targetChargeLevel)
    XCTAssertFalse(timer.climatisationTimer)
    
    XCTAssertNotNil(timer.weekDays)
    let weekdays = timer.weekDays
    XCTAssertTrue(weekdays.SUNDAY)
    XCTAssertTrue(weekdays.MONDAY)
    XCTAssertTrue(weekdays.TUESDAY)
    XCTAssertTrue(weekdays.WEDNESDAY)
    XCTAssertTrue(weekdays.THURSDAY)
    XCTAssertTrue(weekdays.FRIDAY)
    XCTAssertTrue(weekdays.SATURDAY)
  }
}
