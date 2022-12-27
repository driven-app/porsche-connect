import XCTest
@testable import PorscheConnect

final class PorscheConnectCarControlTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: Application = .carControl
  let vehicle = Vehicle(vin: "A1234")
  let capabilites = buildCapabilites()
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    connect = PorscheConnect(username: "homer.simpson@icloud.example", password: "Duh!", environment: .test)
    connect.auths[application] = kTestPorschePortalAuth
  }
  
  // MARK: - Summary Tests
  
  func testSummaryAuthRequiredSuccessful() async {
    connect.auths[application] = nil
    let expectation = expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetSummarySuccessful(router: MockServer.shared.router)
    
    XCTAssertFalse(connect.authorized(application: application))
    
    let result = try! await connect.summary(vehicle: vehicle)
    
    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.summary)
    assertSummary(result.summary!)
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testSummaryNoAuthRequiredSuccessful() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetSummarySuccessful(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))
    
    let result = try! await connect.summary(vehicle: vehicle)
    
    expectation.fulfill()
    XCTAssert(connect.authorized(application: application))
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.summary)
    assertSummary(result.summary!)
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testSummaryNoAuthRequiredFailure() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetSummaryFailure(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))
    
    do {
      _ = try await connect.summary(vehicle: vehicle)
    } catch {
      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
    }
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testSummaryAuthRequiredAuthFailure() async {
    connect.auths[application] = nil
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)
    
    XCTAssertFalse(connect.authorized(application: application))
    
    do {
      _ = try await connect.summary(vehicle: vehicle)
    } catch {
      expectation.fulfill()
      XCTAssertFalse(connect.authorized(application: application))
      XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
    }
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  // MARK: - Position Tests
  
  func testPositionAuthRequiredSuccessful() async {
    connect.auths[application] = nil
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetPositionSuccessful(router: MockServer.shared.router)
    
    XCTAssertFalse(connect.authorized(application: application))
    
    let result = try! await connect.position(vehicle: vehicle)
    
    expectation.fulfill()
    XCTAssert(connect.authorized(application: application))
    XCTAssertNotNil(result.response)
    XCTAssertNotNil(result.position)
    assertPosition(result.position!)
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
    func testPositionNoAuthRequiredSuccessful() async {
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockGetPositionSuccessful(router: MockServer.shared.router)
  
      XCTAssert(connect.authorized(application: application))
  
      let result = try! await connect.position(vehicle: vehicle)
      
      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertNotNil(result.response)
      XCTAssertNotNil(result.position)
  
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testPositionNoAuthRequiredFailure() async {
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockGetPositionFailure(router: MockServer.shared.router)
  
      XCTAssert(connect.authorized(application: application))
  
      do {
        _ = try await connect.position(vehicle: vehicle)
      } catch {
        expectation.fulfill()
        XCTAssert(connect.authorized(application: application))
        XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
      }
      
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testPositionAuthRequiredAuthFailure() async {
      connect.auths[application] = nil
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)
  
      XCTAssertFalse(connect.authorized(application: application))
  
      do {
        _ = try await connect.position(vehicle: vehicle)
      } catch {
        expectation.fulfill()
        XCTAssertFalse(connect.authorized(application: application))
        XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
      }
        
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    // MARK: - Capabilities Tests
  
    func testCapabilitiesAuthRequiredSuccessful() async {
      connect.auths[application] = nil
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
      mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
      mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
      mockNetworkRoutes.mockGetCapabilitiesSuccessful(router: MockServer.shared.router)
  
      XCTAssertFalse(connect.authorized(application: application))
      
      let result = try! await connect.capabilities(vehicle: vehicle)
      
      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertNotNil(result.response)
      XCTAssertNotNil(result.capabilities)
      assertCapabilities(result.capabilities!)
  
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testCapabilitiesNoAuthRequiredSuccessful() async {
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockGetCapabilitiesSuccessful(router: MockServer.shared.router)
  
      XCTAssert(connect.authorized(application: application))
  
      let result = try! await connect.capabilities(vehicle: vehicle)
      
      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertNotNil(result.response)
      XCTAssertNotNil(result.capabilities)
      assertCapabilities(result.capabilities!)
      
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testCapabilitiesNoAuthRequiredFailure() async {
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockGetCapabilitiesFailure(router: MockServer.shared.router)
  
      XCTAssert(connect.authorized(application: application))
  
      do {
        _ = try await connect.capabilities(vehicle: vehicle)
      } catch {
        expectation.fulfill()
        XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
      }
        
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testCapabilitiesAuthRequiredAuthFailure() async {
      connect.auths[application] = nil
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)
  
      XCTAssertFalse(connect.authorized(application: application))
  
      do {
        _ = try await connect.capabilities(vehicle: vehicle)
      } catch {
        expectation.fulfill()
        XCTAssertFalse(connect.authorized(application: application))
        XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
      }
      
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    // MARK: - Emobility Tests
  
    func testEmobilityAuthRequiredSuccessful() async {
      connect.auths[application] = nil
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
      mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
      mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
      mockNetworkRoutes.mockGetEmobilityNotChargingSuccessful(router: MockServer.shared.router)
  
      XCTAssertFalse(connect.authorized(application: application))
      
      let result = try! await connect.emobility(vehicle: vehicle, capabilities: capabilites)
      
      expectation.fulfill()
      XCTAssertNotNil(result.response)
      XCTAssertNotNil(result.emobility)
      assertEmobilityWhenNotCharging(result.emobility!)
  
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testEmobilityNotChargingNoAuthRequiredSuccessful() async {
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockGetEmobilityNotChargingSuccessful(router: MockServer.shared.router)
  
      XCTAssert(connect.authorized(application: application))
  
      let result = try! await connect.emobility(vehicle: vehicle, capabilities: capabilites)
      
      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertNotNil(result.response)
      XCTAssertNotNil(result.emobility)
        
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testEmobilityACTimerChargingNoAuthRequiredSuccessful() async {
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockGetEmobilityACTimerChargingSuccessful(router: MockServer.shared.router)
  
      XCTAssert(connect.authorized(application: application))
  
      let result = try! await connect.emobility(vehicle: vehicle, capabilities: capabilites)

      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertNotNil(result.response)
      XCTAssertNotNil(result.emobility)
      assertEmobilityWhenACTimerCharging(result.emobility!)
        
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testEmobilityACDirectChargingNoAuthRequiredSuccessful() async {
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockGetEmobilityACDirectChargingSuccessful(router: MockServer.shared.router)
  
      XCTAssert(connect.authorized(application: application))
  
      let result = try! await connect.emobility(vehicle: vehicle, capabilities: capabilites)

      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertNotNil(result.response)
      XCTAssertNotNil(result.emobility)
      assertEmobilityWhenACDirectCharging(result.emobility!)
        
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testEmobilityDCChargingNoAuthRequiredSuccessful() async {
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockGetEmobilityDCChargingSuccessful(router: MockServer.shared.router)
  
      XCTAssert(connect.authorized(application: application))
  
      let result = try! await connect.emobility(vehicle: vehicle, capabilities: capabilites)

      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertNotNil(result.response)
      XCTAssertNotNil(result.emobility)
      assertEmobilityWhenDCCharging(result.emobility!)
  
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testEmobilityNoAuthRequiredFailure() async {
      let expectation = expectation(description: "Network Expectation")
      mockNetworkRoutes.mockGetEmobilityFailure(router: MockServer.shared.router)
  
      XCTAssert(connect.authorized(application: application))
  
      do {
        _ = try await connect.emobility(vehicle: vehicle, capabilities: capabilites)
      } catch {
        expectation.fulfill()
        XCTAssert(connect.authorized(application: application))
        XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
      }
        
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
    func testEmobilityAuthRequiredAuthFailure() async {
      connect.auths[application] = nil
      let expectation = expectation(description: "Network Expectation")

      mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)

      XCTAssertFalse(connect.authorized(application: application))

      do {
        _ = try await connect.emobility(vehicle: vehicle, capabilities: capabilites)
      } catch {
        expectation.fulfill()
        XCTAssertFalse(connect.authorized(application: application))
        XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
      }
      
      await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
    }
  
  // MARK: - Honk and Flash Tests
  
  func testFlashAuthRequiredSuccessful() async {
    connect.auths[application] = nil
    let expectation = expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostFlashSuccessful(router: MockServer.shared.router)
    
    XCTAssertFalse(connect.authorized(application: application))
    
    let result = try! await connect.flash(vehicle: vehicle)
    
    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.remoteCommandAccepted)
    assertRemoteCommandAccepted(result.remoteCommandAccepted!)
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testFlashAuthRequiredFailure() async {
    connect.auths[application] = nil
    let expectation = expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostFlashFailure(router: MockServer.shared.router)
    
    XCTAssertFalse(connect.authorized(application: application))
    
    do {
      _ = try await connect.flash(vehicle: vehicle)
    } catch {
      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
    }
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testHonkAndFlashAuthRequiredSuccessful() async {
    connect.auths[application] = nil
    let expectation = expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostHonkAndFlashSuccessful(router: MockServer.shared.router)
    
    XCTAssertFalse(connect.authorized(application: application))
    
    let result = try! await connect.flash(vehicle: vehicle, andHonk: true)
    
    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.remoteCommandAccepted)
    assertRemoteCommandAccepted(result.remoteCommandAccepted!)
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testHonkAndFlashAuthRequiredFailure() async {
    connect.auths[application] = nil
    let expectation = expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostHonkAndFlashFailure(router: MockServer.shared.router)
    
    XCTAssertFalse(connect.authorized(application: application))
    
    do {
      _ = try await connect.flash(vehicle: vehicle, andHonk: true)
    } catch {
      expectation.fulfill()
      XCTAssert(connect.authorized(application: application))
      XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
    }
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
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
  
  private func assertEmobilityWhenNotCharging(_ emobility: Emobility) {
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
    XCTAssertEqual(53.365771, positionForChargingProfile2.latitude)
    XCTAssertEqual(-6.330550, positionForChargingProfile2.longitude)
    
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
  
  private func assertEmobilityWhenACTimerCharging(_ emobility: Emobility) {
    XCTAssertNotNil(emobility.batteryChargeStatus)
    XCTAssertNotNil(emobility.directCharge)
    XCTAssertNotNil(emobility.directClimatisation)
    
    let batteryChargeStatus = emobility.batteryChargeStatus
    
    XCTAssertEqual("CONNECTED", batteryChargeStatus.plugState)
    XCTAssertEqual("LOCKED", batteryChargeStatus.lockState)
    XCTAssertEqual("CHARGING", batteryChargeStatus.chargingState)
    XCTAssertEqual("TIMER1", batteryChargeStatus.chargingReason)
    XCTAssertEqual("AVAILABLE", batteryChargeStatus.externalPowerSupplyState)
    XCTAssertEqual("GREEN", batteryChargeStatus.ledColor)
    XCTAssertEqual("BLINK", batteryChargeStatus.ledState)
    XCTAssertEqual("AC", batteryChargeStatus.chargingMode)
    XCTAssertEqual(56, batteryChargeStatus.stateOfChargeInPercentage)
    XCTAssertEqual(260, batteryChargeStatus.remainingChargeTimeUntil100PercentInMinutes)
    
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
    XCTAssertEqual(0.5, chargeRate.value)
    XCTAssertEqual("KM_PER_MIN", chargeRate.unit)
    XCTAssertEqual(30, chargeRate.valueInKmPerHour)
    XCTAssertEqual("EC.COMMON.UNIT.KM_PER_MIN", chargeRate.unitTranslationKey)
    
    XCTAssertEqual(6.58, batteryChargeStatus.chargingPower)
    XCTAssertFalse(batteryChargeStatus.chargingInDCMode)
    
    let directCharge = emobility.directCharge
    XCTAssertFalse(directCharge.disabled)
    XCTAssertFalse(directCharge.isActive)
    
    let directClimatisation = emobility.directClimatisation
    XCTAssertEqual("OFF", directClimatisation.climatisationState)
    XCTAssertNil(directClimatisation.remainingClimatisationTime)
    
    XCTAssertEqual("ONGOING_TIMER", emobility.chargingStatus)
    
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
    XCTAssertEqual(53.365771, positionForChargingProfile2.latitude)
    XCTAssertEqual(-6.330550, positionForChargingProfile2.longitude)
    
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
  
  private func assertEmobilityWhenACDirectCharging(_ emobility: Emobility) {
    XCTAssertNotNil(emobility.batteryChargeStatus)
    XCTAssertNotNil(emobility.directCharge)
    XCTAssertNotNil(emobility.directClimatisation)
    
    let batteryChargeStatus = emobility.batteryChargeStatus
    
    XCTAssertEqual("CONNECTED", batteryChargeStatus.plugState)
    XCTAssertEqual("LOCKED", batteryChargeStatus.lockState)
    XCTAssertEqual("CHARGING", batteryChargeStatus.chargingState)
    XCTAssertEqual("IMMEDIATE", batteryChargeStatus.chargingReason)
    XCTAssertEqual("AVAILABLE", batteryChargeStatus.externalPowerSupplyState)
    XCTAssertEqual("GREEN", batteryChargeStatus.ledColor)
    XCTAssertEqual("BLINK", batteryChargeStatus.ledState)
    XCTAssertEqual("AC", batteryChargeStatus.chargingMode)
    XCTAssertEqual(56, batteryChargeStatus.stateOfChargeInPercentage)
    XCTAssertEqual(260, batteryChargeStatus.remainingChargeTimeUntil100PercentInMinutes)
    
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
    XCTAssertEqual(1.1, chargeRate.value)
    XCTAssertEqual("KM_PER_MIN", chargeRate.unit)
    XCTAssertEqual(66, chargeRate.valueInKmPerHour)
    XCTAssertEqual("EC.COMMON.UNIT.KM_PER_MIN", chargeRate.unitTranslationKey)
    
    XCTAssertEqual(20.71, batteryChargeStatus.chargingPower)
    XCTAssertFalse(batteryChargeStatus.chargingInDCMode)
    
    let directCharge = emobility.directCharge
    XCTAssertFalse(directCharge.disabled)
    XCTAssertTrue(directCharge.isActive)
    
    let directClimatisation = emobility.directClimatisation
    XCTAssertEqual("OFF", directClimatisation.climatisationState)
    XCTAssertNil(directClimatisation.remainingClimatisationTime)
    
    XCTAssertEqual("INSTANT_CHARGING", emobility.chargingStatus)
    
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
    XCTAssertEqual(53.365771, positionForChargingProfile2.latitude)
    XCTAssertEqual(-6.330550, positionForChargingProfile2.longitude)
    
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
  
  private func assertEmobilityWhenDCCharging(_ emobility: Emobility) {
    XCTAssertNotNil(emobility.batteryChargeStatus)
    XCTAssertNotNil(emobility.directCharge)
    XCTAssertNotNil(emobility.directClimatisation)
    
    let batteryChargeStatus = emobility.batteryChargeStatus
    
    XCTAssertEqual("CONNECTED", batteryChargeStatus.plugState)
    XCTAssertEqual("LOCKED", batteryChargeStatus.lockState)
    XCTAssertEqual("CHARGING", batteryChargeStatus.chargingState)
    XCTAssertEqual("IMMEDIATE", batteryChargeStatus.chargingReason)
    XCTAssertEqual("UNAVAILABLE", batteryChargeStatus.externalPowerSupplyState)
    XCTAssertEqual("GREEN", batteryChargeStatus.ledColor)
    XCTAssertEqual("BLINK", batteryChargeStatus.ledState)
    XCTAssertEqual("DC", batteryChargeStatus.chargingMode)
    XCTAssertEqual(56, batteryChargeStatus.stateOfChargeInPercentage)
    XCTAssertEqual(122, batteryChargeStatus.remainingChargeTimeUntil100PercentInMinutes)
    
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
    XCTAssertEqual(3.0, chargeRate.value)
    XCTAssertEqual("KM_PER_MIN", chargeRate.unit)
    XCTAssertEqual(180, chargeRate.valueInKmPerHour)
    XCTAssertEqual("EC.COMMON.UNIT.KM_PER_MIN", chargeRate.unitTranslationKey)
    
    XCTAssertEqual(48.56, batteryChargeStatus.chargingPower)
    XCTAssertTrue(batteryChargeStatus.chargingInDCMode)
    
    let directCharge = emobility.directCharge
    XCTAssertTrue(directCharge.disabled)
    XCTAssertFalse(directCharge.isActive)
    
    let directClimatisation = emobility.directClimatisation
    XCTAssertEqual("OFF", directClimatisation.climatisationState)
    XCTAssertNil(directClimatisation.remainingClimatisationTime)
    
    XCTAssertEqual("INSTANT_CHARGING", emobility.chargingStatus)
    
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
    XCTAssertEqual(53.365771, positionForChargingProfile2.latitude)
    XCTAssertEqual(-6.330550, positionForChargingProfile2.longitude)
    
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
  
  private func assertRemoteCommandAccepted(_ remoteCommandAccepted: RemoteCommandAccepted) {
    XCTAssertNotNil(remoteCommandAccepted)
    XCTAssertEqual("123456789", remoteCommandAccepted.id)
    XCTAssertEqual(ISO8601DateFormatter().date(from: "2022-12-27T13:19:23Z"), remoteCommandAccepted.lastUpdated)
  }
}
