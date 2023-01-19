import XCTest
import func XCTAsync.XCTAssertFalse
import func XCTAsync.XCTAssertTrue

@testable import PorscheConnect

final class PorscheConnectTripTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: OAuthApplication = .api
  let vin = "A1234"
  
  // MARK: - Lifecycle
  
  override func setUp() async throws {
    try await super.setUp()
    connect = PorscheConnect(
      username: "homer.simpson@icloud.example", password: "Duh!", environment: .test)
    try await connect.authStorage.storeAuthentication(
      token: OAuthToken(authResponse: kTestPorschePortalAuth),
      for: application.clientId
    )
  }
  
  // MARK: - Tests
  
  func testShortTermTripsNoAuthRequiredSuccessful() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetShortTermTripsSuccessful(router: router)
    
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    let results = try! await connect.trips(vin: vin)

    expectation.fulfill()
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))
    XCTAssertNotNil(results)
    XCTAssertNotNil(results.trips)
    XCTAssertEqual(1, results.trips!.count)
    
    let trip = results.trips!.first!
    XCTAssertEqual(Trip.TripType.shortTerm, trip.type)
    XCTAssertEqual(1162572771, trip.id)
    XCTAssertEqual(31, trip.travelTime)
    XCTAssertEqual(ISO8601DateFormatter().date(from: "2023-01-17T20:10:14Z"), trip.timestamp)
    
    let averageSpeed = trip.averageSpeed
    XCTAssertEqual(11, averageSpeed.value)
    XCTAssertEqual(SpeedUnit.kmh, averageSpeed.unit)
    XCTAssertEqual(11, averageSpeed.valueInKmh)
    XCTAssertEqual("TC.UNIT.KMH", averageSpeed.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KMH", averageSpeed.unitTranslationKey)
    
    let averageFuelConsumption = trip.averageFuelConsumption
    XCTAssertEqual(0, averageFuelConsumption.value)
    XCTAssertEqual(Trip.AverageFuelConsumption.FuelConsumptionUnit.litersPer100Km, averageFuelConsumption.unit)
    XCTAssertEqual(0, averageFuelConsumption.valueInLitersPer100Km)
    XCTAssertEqual("TC.UNIT.LITERS_PER_100_KM", averageFuelConsumption.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_LITERS_PER_100_KM", averageFuelConsumption.unitTranslationKey)
    
    let averageElectricEngineConsumption = trip.averageElectricEngineConsumption
    XCTAssertEqual(39.6, averageElectricEngineConsumption.value)
    XCTAssertEqual(Trip.AverageElectricEngineConsumption.ElectricConsumptionUnit.kilowattHoursPer100Km, averageElectricEngineConsumption.unit)
    XCTAssertEqual(39.6, averageElectricEngineConsumption.valueKwhPer100Km)
    XCTAssertEqual("TC.UNIT.KWH_PER_100KM", averageElectricEngineConsumption.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KWH_PER_100KM", averageElectricEngineConsumption.unitTranslationKey)
    
    let tripMileage = trip.tripMileage
    XCTAssertEqual(6, tripMileage.value)
    XCTAssertEqual(6, tripMileage.originalValue)
    XCTAssertEqual(6, tripMileage.valueInKilometers)
    XCTAssertEqual(DistanceUnit.kilometers, tripMileage.unit)
    XCTAssertEqual(DistanceUnit.kilometers, tripMileage.originalUnit)
    XCTAssertEqual("TC.UNIT.KILOMETER", tripMileage.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", tripMileage.unitTranslationKey)
    
    let startMileage = trip.startMileage
    XCTAssertEqual(1442, startMileage.value)
    XCTAssertEqual(1442, startMileage.originalValue)
    XCTAssertEqual(1442, startMileage.valueInKilometers)
    XCTAssertEqual(DistanceUnit.kilometers, startMileage.unit)
    XCTAssertEqual(DistanceUnit.kilometers, startMileage.originalUnit)
    XCTAssertEqual("TC.UNIT.KILOMETER", startMileage.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", startMileage.unitTranslationKey)
    
    let endMileage = trip.endMileage
    XCTAssertEqual(1448, endMileage.value)
    XCTAssertEqual(1448, endMileage.originalValue)
    XCTAssertEqual(1448, endMileage.valueInKilometers)
    XCTAssertEqual(DistanceUnit.kilometers, endMileage.unit)
    XCTAssertEqual(DistanceUnit.kilometers, endMileage.originalUnit)
    XCTAssertEqual("TC.UNIT.KILOMETER", endMileage.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", endMileage.unitTranslationKey)
    
    let zeroEmissionDistance = trip.zeroEmissionDistance
    XCTAssertEqual(6, zeroEmissionDistance.value)
    XCTAssertEqual(6, zeroEmissionDistance.originalValue)
    XCTAssertEqual(6, zeroEmissionDistance.valueInKilometers)
    XCTAssertEqual(DistanceUnit.kilometers, zeroEmissionDistance.unit)
    XCTAssertEqual(DistanceUnit.kilometers, zeroEmissionDistance.originalUnit)
    XCTAssertEqual("TC.UNIT.KILOMETER", zeroEmissionDistance.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", zeroEmissionDistance.unitTranslationKey)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testShortTermTripsNoAuthRequiredFailure() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetShortTermTripsFailure(router: router)

    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    do {
      _ = try await connect.trips(vin: vin)
    } catch {
      expectation.fulfill()
      XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
    }

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testLongTermTripsNoAuthRequiredSuccessful() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetLongTermTripsSuccessful(router: router)
    
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    let results = try! await connect.trips(vin: vin, type: .longTerm)

    expectation.fulfill()
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))
    XCTAssertNotNil(results)
    XCTAssertNotNil(results.trips)
    XCTAssertEqual(1, results.trips!.count)
    
    let trip = results.trips!.first!
    XCTAssertEqual(Trip.TripType.longTerm, trip.type)
    XCTAssertEqual(1158728093, trip.id)
    XCTAssertEqual(2279, trip.travelTime)
    XCTAssertEqual(ISO8601DateFormatter().date(from: "2023-01-17T20:10:14Z"), trip.timestamp)
    
    let averageSpeed = trip.averageSpeed
    XCTAssertEqual(39, averageSpeed.value)
    XCTAssertEqual(SpeedUnit.kmh, averageSpeed.unit)
    XCTAssertEqual(39, averageSpeed.valueInKmh)
    XCTAssertEqual("TC.UNIT.KMH", averageSpeed.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KMH", averageSpeed.unitTranslationKey)
    
    let averageFuelConsumption = trip.averageFuelConsumption
    XCTAssertEqual(0, averageFuelConsumption.value)
    XCTAssertEqual(Trip.AverageFuelConsumption.FuelConsumptionUnit.litersPer100Km, averageFuelConsumption.unit)
    XCTAssertEqual(0, averageFuelConsumption.valueInLitersPer100Km)
    XCTAssertEqual("TC.UNIT.LITERS_PER_100_KM", averageFuelConsumption.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_LITERS_PER_100_KM", averageFuelConsumption.unitTranslationKey)
    
    let averageElectricEngineConsumption = trip.averageElectricEngineConsumption
    XCTAssertEqual(29.9, averageElectricEngineConsumption.value)
    XCTAssertEqual(Trip.AverageElectricEngineConsumption.ElectricConsumptionUnit.kilowattHoursPer100Km, averageElectricEngineConsumption.unit)
    XCTAssertEqual(29.9, averageElectricEngineConsumption.valueKwhPer100Km)
    XCTAssertEqual("TC.UNIT.KWH_PER_100KM", averageElectricEngineConsumption.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KWH_PER_100KM", averageElectricEngineConsumption.unitTranslationKey)
    
    let tripMileage = trip.tripMileage
    XCTAssertEqual(1448, tripMileage.value)
    XCTAssertEqual(1448, tripMileage.originalValue)
    XCTAssertEqual(1448, tripMileage.valueInKilometers)
    XCTAssertEqual(DistanceUnit.kilometers, tripMileage.unit)
    XCTAssertEqual(DistanceUnit.kilometers, tripMileage.originalUnit)
    XCTAssertEqual("TC.UNIT.KILOMETER", tripMileage.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", tripMileage.unitTranslationKey)
    
    let startMileage = trip.startMileage
    XCTAssertEqual(-1, startMileage.value)
    XCTAssertEqual(-1, startMileage.originalValue)
    XCTAssertEqual(-1, startMileage.valueInKilometers)
    XCTAssertEqual(DistanceUnit.kilometers, startMileage.unit)
    XCTAssertEqual(DistanceUnit.kilometers, startMileage.originalUnit)
    XCTAssertEqual("TC.UNIT.KILOMETER", startMileage.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", startMileage.unitTranslationKey)
    
    let endMileage = trip.endMileage
    XCTAssertEqual(1448, endMileage.value)
    XCTAssertEqual(1448, endMileage.originalValue)
    XCTAssertEqual(1448, endMileage.valueInKilometers)
    XCTAssertEqual(DistanceUnit.kilometers, endMileage.unit)
    XCTAssertEqual(DistanceUnit.kilometers, endMileage.originalUnit)
    XCTAssertEqual("TC.UNIT.KILOMETER", endMileage.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", endMileage.unitTranslationKey)
    
    let zeroEmissionDistance = trip.zeroEmissionDistance
    XCTAssertEqual(1448, zeroEmissionDistance.value)
    XCTAssertEqual(1448, zeroEmissionDistance.originalValue)
    XCTAssertEqual(1448, zeroEmissionDistance.valueInKilometers)
    XCTAssertEqual(DistanceUnit.kilometers, zeroEmissionDistance.unit)
    XCTAssertEqual(DistanceUnit.kilometers, zeroEmissionDistance.originalUnit)
    XCTAssertEqual("TC.UNIT.KILOMETER", zeroEmissionDistance.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KILOMETER", zeroEmissionDistance.unitTranslationKey)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testLongTermTripsNoAuthRequiredFailure() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetLongTermTripsFailure(router: router)

    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    do {
      _ = try await connect.trips(vin: vin, type: .longTerm)
    } catch {
      expectation.fulfill()
      XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
    }

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
}
