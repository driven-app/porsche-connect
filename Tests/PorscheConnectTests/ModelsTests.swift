import SwiftUI
import XCTest

@testable import PorscheConnect

final class ModelsTests: XCTestCase {

  let porscheAuth = kTestPorschePortalAuth

  // MARK: - Auth tests

  func testPorscheAuthConstruction() {
    XCTAssertNotNil(porscheAuth)
    XCTAssertNotNil(porscheAuth.apiKey)
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", porscheAuth.apiKey!)
    XCTAssertNotNil(porscheAuth.expiresAt)
    XCTAssertFalse(porscheAuth.expired)
  }

  func testPorscheAuthDecodingJsonIntoModel() {
    let json =
      "{\"access_token\":\"Kpjg2m1ZXd8GM0pvNIB3jogWd0o6\",\"id_token\":\"eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ\",\"token_type\":\"Bearer\",\"expires_in\":7199}\r\n"
      .data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let decodedPorscheAuth = try! decoder.decode(PorscheAuth.self, from: json)
    XCTAssertNotNil(decodedPorscheAuth)
    XCTAssertEqual("Kpjg2m1ZXd8GM0pvNIB3jogWd0o6", decodedPorscheAuth.accessToken)
    XCTAssertEqual(
      "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ",
      decodedPorscheAuth.idToken)
    XCTAssertEqual("Bearer", decodedPorscheAuth.tokenType)
    XCTAssertEqual(7199, decodedPorscheAuth.expiresIn)
    XCTAssertNotNil(decodedPorscheAuth.apiKey)
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", porscheAuth.apiKey!)
    XCTAssertNotNil(porscheAuth.expiresAt)
    XCTAssertFalse(porscheAuth.expired)
  }

  func testDecodedJwtToken() {
    XCTAssertNotNil(porscheAuth)
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", porscheAuth.apiKey)
  }

  // MARK: - Vehicle tests

  func testVehicleConstructionVariantOne() {
    let vehicle = Vehicle(
      vin: "WP0ZZZY4MSA38703",
      modelDescription: "Taycan 4S",
      modelType: "Y1ADB1",
      modelYear: "2021",
      exteriorColor: "neptunblau/neptunblau",
      exteriorColorHex: "#47402e",
      attributes: nil,
      pictures: nil)

    XCTAssertNotNil(vehicle)
    XCTAssertEqual("neptunblau/neptunblau", vehicle.exteriorColor)
    XCTAssertEqual("#47402e", vehicle.exteriorColorHex)
    XCTAssertEqual(Color(hex: "#47402e"), vehicle.color)
    XCTAssertNil(vehicle.attributes)
    XCTAssertNil(vehicle.pictures)
  }

  func testVehicleConstructionVariantTwo() {
    let vehicle = Vehicle(
      vin: "VIN12345",
      modelDescription: "Taycan 4S",
      modelType: "Y1ADB1",
      modelYear: "2021")

    XCTAssertEqual("VIN12345", vehicle.vin)
    XCTAssertEqual("Taycan 4S", vehicle.modelDescription)
    XCTAssertEqual("Y1ADB1", vehicle.modelType)
    XCTAssertEqual("2021", vehicle.modelYear)
    XCTAssertNil(vehicle.exteriorColor)
    XCTAssertNil(vehicle.exteriorColorHex)
    XCTAssertNil(vehicle.attributes)
    XCTAssertNil(vehicle.pictures)
  }

  func testVehicleConstructionVariantThree() {
    let vehicle = Vehicle(vin: "VIN12345")

    XCTAssertEqual("VIN12345", vehicle.vin)
    XCTAssertEqual(kBlankString, vehicle.modelDescription)
    XCTAssertEqual(kBlankString, vehicle.modelType)
    XCTAssertEqual(kBlankString, vehicle.modelYear)
    XCTAssertNil(vehicle.exteriorColor)
    XCTAssertNil(vehicle.exteriorColorHex)
    XCTAssertNil(vehicle.attributes)
    XCTAssertNil(vehicle.pictures)
  }

  func testVehicleDecodingJsonIntoModel() {
    let json =
      "[ {\n  \"vin\" : \"VIN12345\",\n  \"isPcc\" : true,\n  \"relationship\" : \"OWNER\",\n  \"maxSecondaryUsers\" : 5,\n  \"modelDescription\" : \"Taycan 4S\",\n  \"modelType\" : \"Y1ADB1\",\n  \"modelYear\" : \"2021\",\n  \"exteriorColor\" : \"neptunblau/neptunblau\",\n  \"exteriorColorHex\" : \"#47402e\",\n  \"spinEnabled\" : true,\n  \"loginMethod\" : \"PORSCHE_ID\",\n  \"pictures\" : [ {\n    \"url\" : \"https://picserv.porsche.com/picserv/images-api/v1/ec2bed3b73260c6f0116e12f538b1ac6/5\",\n    \"view\" : \"extcam01\",\n    \"size\" : 5,\n    \"width\" : 1920,\n    \"height\" : 1080,\n    \"transparent\" : true,\n    \"placeholder\" : null\n  }, {\n    \"url\" : \"https://picserv.porsche.com/picserv/images-api/v1/c11fb8a8bb320523ce6591d52c68f5cf/4\",\n    \"view\" : \"extcam01\",\n    \"size\" : 4,\n    \"width\" : 1440,\n    \"height\" : 810,\n    \"transparent\" : false,\n    \"placeholder\" : null\n  }, {\n    \"url\" : \"https://picserv.porsche.com/picserv/images-api/v1/c11fb8a8bb320523ce6591d52c68f5cf/3\",\n    \"view\" : \"extcam01\",\n    \"size\" : 3,\n    \"width\" : 960,\n    \"height\" : 540,\n    \"transparent\" : false,\n    \"placeholder\" : null\n  }, {\n    \"url\" : \"https://picserv.porsche.com/picserv/images-api/v1/ec2bed3b73260c6f0116e12f538b1ac6/2\",\n    \"view\" : \"extcam01\",\n    \"size\" : 2,\n    \"width\" : 640,\n    \"height\" : 360,\n    \"transparent\" : true,\n    \"placeholder\" : null\n  }, {\n    \"url\" : \"https://picserv.porsche.com/picserv/images-api/v1/ec2bed3b73260c6f0116e12f538b1ac6/1\",\n    \"view\" : \"extcam01\",\n    \"size\" : 1,\n    \"width\" : 128,\n    \"height\" : 72,\n    \"transparent\" : true,\n    \"placeholder\" : \"data:image/png;base64,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\"\n  } ],\n  \"attributes\" : [ {\n    \"name\" : \"licenseplate\",\n    \"value\" : \"Porsche Taycan\"\n  }, {\n    \"name\" : \"service-favorites\",\n    \"value\" : \"taycan_charging_EU_v1\"\n  } ],\n  \"validFrom\" : \"2021-01-15T11:00:01.000Z\"\n} ]"
      .data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    let decodedVehicles = try! decoder.decode([Vehicle].self, from: json)
    XCTAssertNotNil(decodedVehicles)
    XCTAssertEqual(1, decodedVehicles.count)

    let decodedVehicle = decodedVehicles.first!
    XCTAssertEqual("VIN12345", decodedVehicle.vin)
    XCTAssertEqual("Taycan 4S", decodedVehicle.modelDescription)
    XCTAssertEqual("Y1ADB1", decodedVehicle.modelType)
    XCTAssertEqual("2021", decodedVehicle.modelYear)

    XCTAssertEqual(2, decodedVehicle.attributes!.count)

    let vehicleAttribute1 = decodedVehicle.attributes![0]
    XCTAssertNotNil(vehicleAttribute1)
    XCTAssertEqual("licenseplate", vehicleAttribute1.name)
    XCTAssertEqual("Porsche Taycan", vehicleAttribute1.value)

    let vehicleAttribute2 = decodedVehicle.attributes![1]
    XCTAssertNotNil(vehicleAttribute2)
    XCTAssertEqual("service-favorites", vehicleAttribute2.name)
    XCTAssertEqual("taycan_charging_EU_v1", vehicleAttribute2.value)

    XCTAssertEqual(5, decodedVehicle.pictures!.count)

    let vehiclePicture1 = decodedVehicle.pictures![0]
    XCTAssertNotNil(vehiclePicture1)
    XCTAssertEqual(
      URL(
        string:
          "https://picserv.porsche.com/picserv/images-api/v1/ec2bed3b73260c6f0116e12f538b1ac6/5")!,
      vehiclePicture1.url)
    XCTAssertEqual("extcam01", vehiclePicture1.view)
    XCTAssertEqual(5, vehiclePicture1.size)
    XCTAssertEqual(1080, vehiclePicture1.height)
    XCTAssertEqual(1920, vehiclePicture1.width)
    XCTAssert(vehiclePicture1.transparent)
    XCTAssertNil(vehiclePicture1.placeholder)

    let vehiclePicture2 = decodedVehicle.pictures![1]
    XCTAssertNotNil(vehiclePicture2)
    XCTAssertEqual(
      URL(
        string:
          "https://picserv.porsche.com/picserv/images-api/v1/c11fb8a8bb320523ce6591d52c68f5cf/4")!,
      vehiclePicture2.url)
    XCTAssertEqual("extcam01", vehiclePicture2.view)
    XCTAssertEqual(4, vehiclePicture2.size)
    XCTAssertEqual(810, vehiclePicture2.height)
    XCTAssertEqual(1440, vehiclePicture2.width)
    XCTAssertFalse(vehiclePicture2.transparent)
    XCTAssertNil(vehiclePicture2.placeholder)

    let vehiclePicture3 = decodedVehicle.pictures![2]
    XCTAssertNotNil(vehiclePicture3)
    XCTAssertEqual(
      URL(
        string:
          "https://picserv.porsche.com/picserv/images-api/v1/c11fb8a8bb320523ce6591d52c68f5cf/3")!,
      vehiclePicture3.url)
    XCTAssertEqual("extcam01", vehiclePicture3.view)
    XCTAssertEqual(3, vehiclePicture3.size)
    XCTAssertEqual(540, vehiclePicture3.height)
    XCTAssertEqual(960, vehiclePicture3.width)
    XCTAssertFalse(vehiclePicture3.transparent)
    XCTAssertNil(vehiclePicture3.placeholder)

    let vehiclePicture4 = decodedVehicle.pictures![3]
    XCTAssertNotNil(vehiclePicture4)
    XCTAssertEqual(
      URL(
        string:
          "https://picserv.porsche.com/picserv/images-api/v1/ec2bed3b73260c6f0116e12f538b1ac6/2")!,
      vehiclePicture4.url)
    XCTAssertEqual("extcam01", vehiclePicture4.view)
    XCTAssertEqual(2, vehiclePicture4.size)
    XCTAssertEqual(360, vehiclePicture4.height)
    XCTAssertEqual(640, vehiclePicture4.width)
    XCTAssert(vehiclePicture4.transparent)
    XCTAssertNil(vehiclePicture4.placeholder)

    let vehiclePicture5 = decodedVehicle.pictures![4]
    XCTAssertNotNil(vehiclePicture5)
    XCTAssertEqual(
      URL(
        string:
          "https://picserv.porsche.com/picserv/images-api/v1/ec2bed3b73260c6f0116e12f538b1ac6/1")!,
      vehiclePicture5.url)
    XCTAssertEqual("extcam01", vehiclePicture5.view)
    XCTAssertEqual(1, vehiclePicture5.size)
    XCTAssertEqual(72, vehiclePicture5.height)
    XCTAssertEqual(128, vehiclePicture5.width)
    XCTAssert(vehiclePicture5.transparent)
    XCTAssertNotNil(vehiclePicture5.placeholder)
  }

  // MARK: - Summary tests

  func testSummaryConstruction() {
    let summary = Summary(modelDescription: "A model description", nickName: nil)
    XCTAssertNotNil(summary)
    XCTAssertNil(summary.nickName)
  }

  func testSummaryDecodingJsonIntoModel() {
    let json = "{\n \"modelDescription\": \"Taycan 4S\", \n \"nickName\": \"211-D-12345\"}".data(
      using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    let summary = try! decoder.decode(Summary.self, from: json)
    XCTAssertNotNil(summary)
    XCTAssertEqual("Taycan 4S", summary.modelDescription)
    XCTAssertEqual("211-D-12345", summary.nickName!)
  }

  func testSummaryDecodingJsonIntoModelWithNoNickname() {
    let json = "{\"modelDescription\": \"Taycan 4S\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    let summary = try! decoder.decode(Summary.self, from: json)
    XCTAssertNotNil(summary)
    XCTAssertEqual("Taycan 4S", summary.modelDescription)
    XCTAssertNil(summary.nickName)
  }

  // MARK: - Position tests

  func testPositionDecodingJsonIntoModel() {
    let position = buildPosition()

    XCTAssertNotNil(position)
    XCTAssertNotNil(position.carCoordinate)
    XCTAssertEqual(53.365771, position.carCoordinate.latitude)
    XCTAssertEqual(-6.330550, position.carCoordinate.longitude)
    XCTAssertEqual(68, position.heading)
  }

  // MARK: - Capabilities tests

  func testCapabilitiesConstruction() {
    let capabilities = Capabilities(engineType: "Test Engine Type", carModel: "Test Car Model")
    XCTAssertEqual("Test Engine Type", capabilities.engineType)
    XCTAssertEqual("Test Car Model", capabilities.carModel)
    XCTAssertFalse(capabilities.displayParkingBrake)
    XCTAssertFalse(capabilities.needsSPIN)
    XCTAssertFalse(capabilities.hasRDK)
    XCTAssertFalse(capabilities.hasHonkAndFlash)
    XCTAssertTrue(capabilities.onlineRemoteUpdateStatus.active)
    XCTAssertTrue(capabilities.onlineRemoteUpdateStatus.editableByUser)
    XCTAssertTrue(capabilities.heatingCapabilities.frontSeatHeatingAvailable)
    XCTAssertFalse(capabilities.heatingCapabilities.rearSeatHeatingAvailable)
  }

  func testCapabilitiesDecodingJsonIntoModel() {
    let capabilities = buildCapabilites()

    XCTAssertNotNil(capabilities)
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

  // MARK: - Flash & Honk

  func testFlashDecodingJsonIntoModel() {
    let remoteCommandAccepted = buildRemoteCommandAccepted()

    XCTAssertNotNil(remoteCommandAccepted)
    XCTAssertEqual("2119999", remoteCommandAccepted.id)
    XCTAssertEqual(
      ISO8601DateFormatter().date(from: "2022-12-27T13:19:23Z"), remoteCommandAccepted.lastUpdated)
  }

  // MARK: – Remote Command Status

  func testRemoteCommandStatusInProgress() {
    let remoteCommandStatus = buildRemoteCommandStatusInProgress()

    XCTAssertNotNil(remoteCommandStatus)
    XCTAssertEqual("IN_PROGRESS", remoteCommandStatus.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, remoteCommandStatus.remoteStatus)
  }

  func testRemoteCommandStatusSuccess() {
    let remoteCommandStatus = buildRemoteCommandStatusInSuccess()

    XCTAssertNotNil(remoteCommandStatus)
    XCTAssertEqual("SUCCESS", remoteCommandStatus.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, remoteCommandStatus.remoteStatus)
  }

  func testRemoteCommandStatusUnknown() {
    let remoteCommandStatus = buildRemoteCommandStatusInUnknown()

    XCTAssertNotNil(remoteCommandStatus)
    XCTAssertNil(remoteCommandStatus.remoteStatus)
  }

  // MARK: - Private functions

  private func buildPosition() -> Position {
    let json =
      "{\"carCoordinate\": {\"geoCoordinateSystem\": \"WGS84\",\"latitude\": 53.365771, \"longitude\": -6.330550}, \"heading\": 68}"
      .data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(Position.self, from: json)
  }

  private func buildEmobilityWhenNotCharging() -> Emobility {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(Emobility.self, from: kEmobilityNotChargingJson)
  }

  private func buildRemoteCommandAccepted() -> RemoteCommandAccepted {
    let json = "{\"id\" : \"2119999\", \"lastUpdated\" : \"2022-12-27T13:19:23Z\"}".data(
      using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    decoder.dateDecodingStrategy = .iso8601

    return try! decoder.decode(RemoteCommandAccepted.self, from: json)
  }

  private func buildRemoteCommandStatusInProgress() -> RemoteCommandStatus {
    let json = "{\"status\" : \"IN_PROGRESS\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(RemoteCommandStatus.self, from: json)
  }

  private func buildRemoteCommandStatusInSuccess() -> RemoteCommandStatus {
    let json = "{\"status\" : \"SUCCESS\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(RemoteCommandStatus.self, from: json)
  }

  private func buildRemoteCommandStatusInUnknown() -> RemoteCommandStatus {
    let json = "{\"status\" : \"Not Known\"}".data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys

    return try! decoder.decode(RemoteCommandStatus.self, from: json)
  }
}
