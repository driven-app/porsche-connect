import XCTest

@testable import PorscheConnect

final class ModelsEmobilityTests: XCTestCase {

  // MARK: - E-Mobility tests

  func testEmobilityDecodingJsonIntoModel() {
    let emobility = buildEmobilityWhenNotCharging()

    XCTAssertNotNil(emobility)
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
    if let weekdays = timer.weekDays {
      XCTAssertTrue(weekdays.SUNDAY)
      XCTAssertTrue(weekdays.MONDAY)
      XCTAssertTrue(weekdays.TUESDAY)
      XCTAssertTrue(weekdays.WEDNESDAY)
      XCTAssertTrue(weekdays.THURSDAY)
      XCTAssertTrue(weekdays.FRIDAY)
      XCTAssertTrue(weekdays.SATURDAY)
    }
  }

  // MARK: - Private functions

  private func buildEmobilityWhenNotCharging() -> Emobility {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(Emobility.self, from: kEmobilityNotChargingJson)
  }
}
