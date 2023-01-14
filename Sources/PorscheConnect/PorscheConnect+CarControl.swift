import Foundation

extension PorscheConnect {

  public func summary(vin: String) async throws -> (
    summary: Summary?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Summary.self, url: networkRoutes.vehicleSummaryURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (summary: result.data, response: result.response)
  }

  public func position(vin: String) async throws -> (
    position: Position?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Position.self, url: networkRoutes.vehiclePositionURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (position: result.data, response: result.response)
  }

  public func capabilities(vin: String) async throws -> (
    capabilities: Capabilities?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Capabilities.self, url: networkRoutes.vehicleCapabilitiesURL(vin: vin),
      headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (capabilities: result.data, response: result.response)
  }

  public func emobility(vin: String, capabilities: Capabilities) async throws -> (
    emobility: Emobility?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let result = try await networkClient.get(
      Emobility.self,
      url: networkRoutes.vehicleEmobilityURL(vin: vin, capabilities: capabilities),
      headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys)
    return (emobility: result.data, response: result.response)
  }

  public func status(vin: String) async throws -> (
    status: Status?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .api)

    let result = try await networkClient.get(
      Status.self, url: networkRoutes.vehicleStatusURL(vin: vin), headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    return (status: result.data, response: result.response)
  }

  public func flash(vin: String, andHonk honk: Bool = false) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)

    let url =
      honk
      ? networkRoutes.vehicleHonkAndFlashURL(vin: vin)
      : networkRoutes.vehicleFlashURL(vin: vin)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .honkAndFlash
    return (remoteCommandAccepted: result.data, response: result.response)
  }

  public func toggleDirectCharging(
    vin: String, capabilities: Capabilities, enable: Bool = true
  ) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleToggleDirectChargingURL(
      vin: vin, capabilities: capabilities, enable: enable)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .toggleDirectCharge
    return (remoteCommandAccepted: result.data, response: result.response)
  }
  
  public func toggleDirectClimatisation(
    vin: String, enable: Bool = true
  ) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleToggleDirectClimatisationURL(
      vin: vin, enable: enable)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .toggleDirectClimatisation
    return (remoteCommandAccepted: result.data, response: result.response)
  }

  public func lock(vin: String) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleLockUnlockURL(vin: vin, lock: true)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: kBlankString, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)
    result.data?.remoteCommand = .lock
    return (remoteCommandAccepted: result.data, response: result.response)
  }

  public func unlock(vin: String, pin: String) async throws -> (
    remoteCommandAccepted: RemoteCommandAccepted?, response: HTTPURLResponse
  ) {
    let headers = try await performAuthFor(application: .carControl)
    let url = networkRoutes.vehicleLockUnlockURL(vin: vin, lock: false)

    let pinSecurity = try await networkClient.get(
      PinSecurity.self, url: url, headers: headers, jsonKeyDecodingStrategy: .useDefaultKeys
    ).data

    guard let pinSecurity = pinSecurity, let pinHash = pinSecurity.generateSecurityPinHash(pin: pin)
    else {
      throw PorscheConnectError.UnlockChallengeFailure
    }

    let unlockSecurity = UnlockSecurity(
      challenge: pinSecurity.challenge,
      securityPinHash: pinHash,
      securityToken: pinSecurity.securityToken)

    var result = try await networkClient.post(
      RemoteCommandAccepted.self, url: url, body: unlockSecurity, headers: headers,
      jsonKeyDecodingStrategy: .useDefaultKeys)

    switch result.data?.pcckErrorKey {
    case .lockedFor60Minutes:
      throw PorscheConnectError.lockedFor60Minutes
    case .incorrectPin:
      throw PorscheConnectError.IncorrectPin
    case .none:
      break
    }

    result.data?.remoteCommand = .unlock
    return (remoteCommandAccepted: result.data, response: result.response)
  }
}
