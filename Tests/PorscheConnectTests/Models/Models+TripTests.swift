import XCTest

@testable import PorscheConnect

final class TripTests: XCTestCase {
  
  // MARK: - Trips
  
  func testShortTermTripsMetricDecodingJsonIntoModel() {
    let shortTrips = buildShortTermTrips()
    
    XCTAssertNotNil(shortTrips)
    XCTAssertEqual(1, shortTrips.count)
    
    let trip = shortTrips.first!
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
  }
  
  func testShortTermTripsImperialDecodingJsonIntoModel() {
    let shortTrips = buildShortTermTrips(metric: false)
    
    XCTAssertNotNil(shortTrips)
    XCTAssertEqual(1, shortTrips.count)
    
    let trip = shortTrips.first!
    XCTAssertEqual(Trip.TripType.shortTerm, trip.type)
    XCTAssertEqual(1162658714, trip.id)
    XCTAssertEqual(24, trip.travelTime)
    XCTAssertEqual(ISO8601DateFormatter().date(from: "2023-01-17T20:58:58Z"), trip.timestamp)
    
    let averageSpeed = trip.averageSpeed
    XCTAssertEqual(44.11735, averageSpeed.value)
    XCTAssertEqual(SpeedUnit.mph, averageSpeed.unit)
    XCTAssertEqual(70.99999, averageSpeed.valueInKmh)
    XCTAssertEqual("TC.UNIT.MPH", averageSpeed.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_MPH", averageSpeed.unitTranslationKey)
    
    let averageFuelConsumption = trip.averageFuelConsumption
    XCTAssertEqual(0, averageFuelConsumption.value)
    XCTAssertEqual(Trip.AverageFuelConsumption.FuelConsumptionUnit.milesPerUSGallon, averageFuelConsumption.unit)
    XCTAssertEqual(0, averageFuelConsumption.valueInLitersPer100Km)
    XCTAssertEqual("TC.UNIT.MILES_PER_GALLON_US", averageFuelConsumption.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_MILES_PER_GALLON_US", averageFuelConsumption.unitTranslationKey)
    
    let averageElectricEngineConsumption = trip.averageElectricEngineConsumption
    XCTAssertEqual(0.3250875, averageElectricEngineConsumption.value)
    XCTAssertEqual(Trip.AverageElectricEngineConsumption.ElectricConsumptionUnit.kilowattHourPerMile, averageElectricEngineConsumption.unit)
    XCTAssertEqual(20.2, averageElectricEngineConsumption.valueKwhPer100Km)
    XCTAssertEqual("TC.UNIT.KWH_PER_MILE", averageElectricEngineConsumption.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_KWH_PER_MILE", averageElectricEngineConsumption.unitTranslationKey)
    
    let tripMileage = trip.tripMileage
    XCTAssertEqual(17.39839, tripMileage.value)
    XCTAssertEqual(28, tripMileage.originalValue)
    XCTAssertEqual(28, tripMileage.valueInKilometers)
    XCTAssertEqual(DistanceUnit.miles, tripMileage.unit)
    XCTAssertEqual(DistanceUnit.kilometers, tripMileage.originalUnit)
    XCTAssertEqual("TC.UNIT.MILES", tripMileage.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_MILES", tripMileage.unitTranslationKey)
    
    let startMileage = trip.startMileage
    XCTAssertEqual(14781.8, startMileage.value)
    XCTAssertEqual(23789.0, startMileage.originalValue)
    XCTAssertEqual(23789.0, startMileage.valueInKilometers)
    XCTAssertEqual(DistanceUnit.miles, startMileage.unit)
    XCTAssertEqual(DistanceUnit.kilometers, startMileage.originalUnit)
    XCTAssertEqual("TC.UNIT.MILES", startMileage.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_MILES", startMileage.unitTranslationKey)
    
    let endMileage = trip.endMileage
    XCTAssertEqual(14799.2, endMileage.value)
    XCTAssertEqual(23817, endMileage.originalValue)
    XCTAssertEqual(23817, endMileage.valueInKilometers)
    XCTAssertEqual(DistanceUnit.miles, endMileage.unit)
    XCTAssertEqual(DistanceUnit.kilometers, endMileage.originalUnit)
    XCTAssertEqual("TC.UNIT.MILES", endMileage.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_MILES", endMileage.unitTranslationKey)
    
    let zeroEmissionDistance = trip.zeroEmissionDistance
    XCTAssertEqual(17.39839, zeroEmissionDistance.value)
    XCTAssertEqual(28, zeroEmissionDistance.originalValue)
    XCTAssertEqual(28, zeroEmissionDistance.valueInKilometers)
    XCTAssertEqual(DistanceUnit.miles, zeroEmissionDistance.unit)
    XCTAssertEqual(DistanceUnit.kilometers, zeroEmissionDistance.originalUnit)
    XCTAssertEqual("TC.UNIT.MILES", zeroEmissionDistance.unitTranslationKeyV2)
    XCTAssertEqual("GRAY_SLICE_UNIT_MILES", zeroEmissionDistance.unitTranslationKey)
  }
  
  func testLongTripsMetricDecodingJsonIntoModel() {
    let shortTrips = buildLongTermTrips()
    
    XCTAssertNotNil(shortTrips)
    XCTAssertEqual(1, shortTrips.count)
    
    let trip = shortTrips.first!
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
  }
  
  // MARK: - Private functions
  
  private func buildShortTermTrips(metric: Bool = true) -> [Trip] {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601
    
    return try! decoder.decode([Trip].self, from: metric ? kShortTermTripsInMetricJson : kShortTermTripsInImperialJson)
  }
  
  private func buildLongTermTrips() -> [Trip] {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601
    
    return try! decoder.decode([Trip].self, from: kLongTermTripsInMetricJson)
  }
}
